//
//  RecordViewController.m
//  SUCamera
//
//  Created by zypsusu on 2017/7/31.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import "RecordViewController.h"
#import "SURecord.h"
#import "GPUImage.h"
#import "Video.h"
#import "VideoPoint.h"
#import "AVAssetStitcher.h"
#import "EffectViewController.h"
#import "PointProgress.h"
#import "SampleEffectViewController.h"


static CGFloat RecordMaxDuration = 8.0;

@interface RecordViewController () <SURecordDelegate, GPUImageVideoCameraDelegate>
@property (nonatomic, assign) BOOL countDown;
@property (nonatomic, weak) IBOutlet UIView *exitView;
@property (nonatomic, weak) IBOutlet UIView *exitButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeViewHeight;
@property (nonatomic, weak) IBOutlet UIImageView *skinBgImage;

@property (nonatomic, strong) GPUImageVideoCamera *camera;
@property (nonatomic, strong) GPUImageMovieWriter *writer;
@property (nonatomic, assign) BOOL recordFish;             // 辅助判断录制完成，没则导致执行终止录制操作
@property (nonatomic, assign) NSInteger recordCount;       // 录制完成标识
@property (nonatomic, assign) BOOL recordEnd;              // 超过限定时长后面代码只执行一次
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RecordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _pointProgress.colorBg     = RGBToColor(0,0,0, 0.1);
    _pointProgress.colorNomal  = RGBToColor(2,212,225,1);
    _pointProgress.colorSelect = RGBToColor(255,72,72,1);
    _pointProgress.colorNotice = RGBToColor(255,255,255,1);
    
    _video = [[Video alloc] init];
    [SURecord shared].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    _pointProgress.array = self.video.arrayPoint;
    _pointProgress.showCursor = YES;
    _pointProgress.showBlink = YES;
    [self recordTimeFresh:[self.video recordDuration]];
    
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    [videoCamera addAudioInputsAndOutputs];
    [videoCamera addTarget:self.gpuImageView];
    _camera = videoCamera;
    [videoCamera startCameraCapture];
}

- (IBAction)buttonRecordDown:(id)sender{
    _pointProgress.showBlink = NO;
    _pointProgress.showCursor = YES;
    _recordCount += 1;
    
    NSString *path = [self.video newUniquePathWithExt:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    VideoPoint *point = [[VideoPoint alloc] init];
    point.fileURL = url;
    point.startTime = [[self.video lastPoint] endTime];
    point.endTime = [[self.video lastPoint] endTime];
    point.maxDuration = RecordMaxDuration;
    [_video.arrayPoint addObject:point];
    
    GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:url size:self.video.size];
    _writer = movieWriter;
    [_camera setAudioEncodingTarget:movieWriter];
    [self refreshChain];
    [self addTimer];
    [movieWriter startRecording];
}

- (void)addTimer{
    [self removeTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self recodUpdate];
    }];
}

- (void)removeTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)recodUpdate{
    CGFloat duration = CMTimeGetSeconds([_writer duration]);
    if (duration < 0) {
        return;
    }
    [self recordTimeFresh:duration + [self.video alreadyRecordDuration]];
    if (self.video.recordDuration > RecordMaxDuration) {
        _recordFish = YES;
        [self endRecord];
    }
}

- (void)recordTimeFresh:(CGFloat)time{
    self.video.duration = time;
    [self.video lastPoint].endTime = time;
    
    _pointProgress.showNoticePoint = time < 2.0;
    [_pointProgress updateProgress:time];
}

- (void)refreshChain{
    [_camera removeAllTargets];
    [_camera addTarget:_gpuImageView];
    if (_writer) {
        [_camera addTarget:_writer];
    }
}

- (IBAction)buttonRecordUp:(id)sender{
    _pointProgress.showBlink = YES;
    _pointProgress.showCursor = YES;
    
    if (_recordCount == 0) {
        return;
    }
    [self endRecord];
}

- (void)endRecord{
    if (_recordCount == 0 || _recordEnd) {
        return;
    }
    _recordEnd = YES;
    [self removeTimer];
    [_camera removeTarget:_writer];
    [_writer finishRecordingWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endRecordHandler];
        });
    }];
}

- (void)endRecordHandler{
    _writer = nil;
    _recordCount -= 1;
    _recordEnd = NO;
    if (_recordFish) {
        [self finishRecordToSave];
    } else {
        [self finishRecordThenRecord];
    }
}

- (void)finishRecordToSave{
    _recordFish = NO;
    [self stitcherVideoWithCompletionBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self finishRecordHandleWithError:error];
        });
    }];
}

- (void)finishRecordHandleWithError:(NSError *)error{
    if (error) {
        
    }else{
        self.video.finalURL = self.video.originURL;/* 最终文件为原始 视频 */
        SampleEffectViewController *effVC = [[SampleEffectViewController alloc] initWithNibName:@"SampleEffectViewController" bundle:nil withVideo:_video];
        [self.navigationController pushViewController:effVC animated:YES];
    }
}

- (void)stitcherVideoWithCompletionBlock:(void(^)(NSError *error))blcok{
    AVAssetStitcher *sticher = [[AVAssetStitcher alloc] initWithOutputSize:self.video.size];
    for (VideoPoint *vp in self.video.arrayPoint) {
        NSURL *url = vp.fileURL;
        AVURLAsset *asset = [[AVURLAsset alloc]initWithURL:url options:nil];
        [sticher addAsset:asset rotate:0 withError:nil];
    }
    NSURL *url = [NSURL fileURLWithPath:[self.video newUniquePathWithExt:@"mp4"]];
    self.video.originURL = url;
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    NSString *preset = AVAssetExportPresetMediumQuality;
    [sticher exportTo:url withPreset:preset withCompletionHandler:blcok];
}

// 刷新videoPoint时间
- (void)finishRecordThenRecord{
    [self.video updateTimestamp];
    [self recordTimeFresh:[self.video recordDuration]];
}



- (IBAction)buttonCloseClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonFinishClick:(id)sender{}
- (IBAction)viewBottomDown:(id)sender{}
- (IBAction)buttonLibraryClick:(id)sender{}
- (IBAction)buttonPositionClick:(id)sender{}
- (IBAction)buttonFlashClick:(id)sender{}
- (IBAction)buttonTimeClick:(id)sender{}
- (IBAction)buttonSaveClick:(id)sender{}

- (IBAction)sliderValueChanged:(id)sender{}
- (IBAction)sliderTouchDown:(id)sender{}
- (IBAction)sliderTouchCancel:(id)sender{}
- (IBAction)buttonSkinClick:(id)sender{}
- (IBAction)viewCenterPinchGesture:(id)sender{}
- (IBAction)viewCenterTapGesture:(id)sender{}
- (IBAction)viewCenterPanGesture:(id)sender{}

- (CGPoint)buttonLibrarayCenterPointToView{
    return CGPointZero;
}
@end
