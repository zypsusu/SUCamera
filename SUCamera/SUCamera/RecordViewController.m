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


@interface RecordViewController () <SURecordDelegate, GPUImageVideoCameraDelegate>
@property (nonatomic, assign) BOOL countDown;
@property (nonatomic, weak) IBOutlet UIView *exitView;
@property (nonatomic, weak) IBOutlet UIView *exitButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeViewHeight;
@property (nonatomic, weak) IBOutlet UIImageView *skinBgImage;

@property (nonatomic, strong) GPUImageVideoCamera *camera;
@property (nonatomic, strong) GPUImageMovieWriter *writer;
@property (nonatomic, assign) BOOL recordFish;

@end

@implementation RecordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [SURecord shared].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    [videoCamera addAudioInputsAndOutputs];
    videoCamera.delegate = self;
    [videoCamera addTarget:self.gpuImageView];
    _camera = videoCamera;
    [videoCamera startCameraCapture];
}

- (IBAction)buttonRecordDown:(id)sender{
    NSString *path = [self.video newUniquePathWithExt:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    VideoPoint *point = [[VideoPoint alloc] init];
    point.startTime = [[self.video lastPoint] endTime];
    point.endTime = point.startTime + [[self.video lastPoint] duration];
    [_video.arrayPoint addObject:point];
    GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:url size:self.video.size];
    _writer = movieWriter;
    [self refreshChain];
    [movieWriter startRecording];
}

- (void)refreshChain{
    [_camera removeAllTargets];
    [_camera addTarget:_gpuImageView];
    if (_writer) {
        [_camera addTarget:_writer];
    }
}

- (IBAction)buttonRecordUp:(id)sender{
    [_camera removeTarget:_writer];
    [_writer finishRecordingWithCompletionHandler:^{
        [self endRecordHandler];
    }];
}

- (void)endRecordHandler{
    _writer = nil;
    if (_recordFish) {
        [self finishRecordToSave];
    } else {
        [self finishRecordThenRecord];
    }
}

- (void)finishRecordToSave{
    [self stitcherVideoWithCompletionBlock:^(NSError *error) {
        [self finishRecordHandleWithError:error];
    }];
}

- (void)finishRecordHandleWithError:(NSError *)error{
    
}

- (void)stitcherVideoWithCompletionBlock:(void(^)(NSError *error))blcok{
    
}

// 刷新videoPoint时间
- (void)finishRecordThenRecord{
    [self.video updateTimestamp];
    [self recordTimeFresh:[self.video recordDuration]];
}

// 刷新进度条时间
- (void)recordTimeFresh:(CGFloat)time{
    
}




- (IBAction)buttonCloseClick:(id)sender{}
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
