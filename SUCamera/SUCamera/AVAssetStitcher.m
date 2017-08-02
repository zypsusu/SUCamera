
//
//  AVAssetStitcher.m
//  SUCamera
//
//  Created by zypsusu on 2017/8/2.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import "AVAssetStitcher.h"
#import "SUReaderToWriter.h"

@interface AVAssetStitcher ()
@property (nonatomic, assign) CGSize outSize;
@property (nonatomic, strong) AVMutableComposition *composition;
@property (nonatomic, strong) AVMutableCompositionTrack *videoTrack;
@property (nonatomic, strong) AVMutableCompositionTrack *audioTrack;
@property (nonatomic, strong) AVMutableVideoComposition *videoComposition;
@property (nonatomic, assign) CMTime atTime;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSMutableArray *instructions;

@property (nonatomic, copy) void (^completHandle)(NSError *error);
@end

@implementation AVAssetStitcher

- (id)initWithOutputSize:(CGSize)outSize{
    self = [super init];
    if (self) {
        _outSize = outSize;
        _instructions = [NSMutableArray arrayWithCapacity:2];
        _composition = [AVMutableComposition composition];
        _videoTrack = [_composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        _audioTrack = [_composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        _atTime = kCMTimeZero;
    }
    return nil;
}

- (void)addAsset:(AVURLAsset *)asset rotate:(NSInteger)rotate withError:(NSError **)error{
    AVAssetTrack *videoTrack;
    AVAssetTrack *audioTrack;
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count != 0) {
        videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([asset tracksWithMediaType:AVMediaTypeAudio].count != 0) {
        audioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    CMTime videoTime = asset.duration;
    CMTime audioTime = asset.duration;
    if (videoTrack && audioTrack) {
        float videoDuration = CMTimeGetSeconds(videoTrack.timeRange.duration);
        float audioDuration = CMTimeGetSeconds(audioTrack.timeRange.duration);
        if (videoDuration - audioDuration > 0.0001) {
            videoTime = audioTrack.timeRange.duration;
            audioTime = audioTrack.timeRange.duration;
        }
        if (audioDuration - videoDuration > 0.0001) {
            videoTime = videoTrack.timeRange.duration;
            audioTime = videoTrack.timeRange.duration;
        }
    }
    if (videoTrack) {
        [_videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoTime) ofTrack:videoTrack atTime:_atTime error:error];
    }
    if (audioTrack) {
        [_audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioTime) ofTrack:audioTrack atTime:_atTime error:error];
    }
    if (videoTrack) {
        _atTime = CMTimeAdd(_atTime, videoTime);
    }
    
}

- (void)exportTo:(NSURL *)outputFile withPreset:(NSString *)preset withCompletionHandler:(void (^)(NSError *error))completed{
    _completHandle = completed;
    _fileURL = outputFile;
    AVAssetExportSession *export = [AVAssetExportSession exportSessionWithAsset:_composition presetName:preset];
    export.outputFileType = AVFileTypeMPEG4;
    export.outputURL = _fileURL;
    
    [export exportAsynchronouslyWithCompletionHandler:^{
        switch (export.status) {
            case AVAssetExportSessionStatusCompleted:
                if ([[NSFileManager defaultManager] fileExistsAtPath:outputFile.path]) {
                    completed(nil);
                } else {
                    [self exportVideo2];
                }
                break;
            case AVAssetExportSessionStatusFailed:
                if ([export.presetName isEqualToString:AVAssetExportPresetPassthrough]) {
                    [self exportVideo2];
                }else{
                    _completHandle(export.error);
                }
                break;
            case AVAssetExportSessionStatusCancelled:
                _completHandle([NSError errorWithDomain:@"AVAssetExportSessionStatusCancelled" code:101 userInfo:nil]);
                break;
            default:
                _completHandle([NSError errorWithDomain:@"AVAssetExportSessionStatusUnknown" code:100 userInfo:nil]);
                break;
        }
    }];
    
}

- (void)exportVideo2{
    AVAssetExportSession *export = [AVAssetExportSession exportSessionWithAsset:_composition presetName:AVAssetExportPresetMediumQuality];
    export.outputFileType = AVFileTypeMPEG4;
    export.outputURL = _fileURL;
    
    [export exportAsynchronouslyWithCompletionHandler:^{
        switch (export.status) {
            case AVAssetExportSessionStatusCompleted:
                if ([[NSFileManager defaultManager] fileExistsAtPath:_fileURL.path]) {
                    _completHandle(nil);
                } else {
                    [self exportVideo3];
                }
                break;
            case AVAssetExportSessionStatusFailed:
                if ([export.presetName isEqualToString:AVAssetExportPresetPassthrough]) {
                    [self exportVideo3];
                }else{
                    _completHandle(export.error);
                }
                break;
            case AVAssetExportSessionStatusCancelled:
                _completHandle([NSError errorWithDomain:@"AVAssetExportSessionStatusCancelled" code:101 userInfo:nil]);
                break;
            default:
                _completHandle([NSError errorWithDomain:@"AVAssetExportSessionStatusUnknown" code:100 userInfo:nil]);
                break;
        }
    }];
}

- (void)exportVideo3{
    SUReaderToWriter *writer = [[SUReaderToWriter alloc] init];
    [writer combineFromAsset:_composition toURL:_fileURL withCompletionHandler:^(NSError *error) {
        _completHandle(error);
    }];
}

@end
