
//
//  SUReaderToWriter.m
//  SUCamera
//
//  Created by zypsusu on 2017/8/2.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import "SUReaderToWriter.h"

@interface SUReaderToWriter ()
@property (nonatomic, copy) NSString *profileLevel;
@property (nonatomic, copy) void (^completionHandler)(NSError *error);
@property (nonatomic, strong) NSURL *toURL;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, assign) BOOL videoFinish;
@property (nonatomic, assign) BOOL audioFinish;
@property (nonatomic, strong) AVAssetWriter *writer;
@property (nonatomic, strong) AVAssetReader *reader;

@end

@implementation SUReaderToWriter

- (void)combineFromAsset:(AVAsset *)asset toURL:(NSURL *)toURL withCompletionHandler:(void (^)(NSError *error))completionHandler{
    _profileLevel = [self nextProfileLevelFrom:nil];
    _toURL = toURL;
    _asset = asset;
    _completionHandler = completionHandler;
    [self nextCombineFromAsset:asset toURL:toURL];
}

- (void)nextCombineFromAsset:(AVAsset *)asset toURL:(NSURL *)toURL{
    NSError *error;
    AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:asset error:&error];
    AVAssetWriter *writer = [AVAssetWriter assetWriterWithURL:toURL fileType:AVFileTypeMPEG4 error:&error];
    _reader = reader;
    _writer = writer;
    AVAssetTrack *videoTrack, *audioTrack;
    for (AVAssetTrack *track in asset.tracks) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoTrack = track;
        }
        if ([track.mediaType isEqualToString:AVMediaTypeAudio]) {
            audioTrack = track;
        }
    }
    AVAssetReaderTrackOutput *videoOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack outputSettings:@{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)}];
    [reader addOutput:videoOutput];
    AVAssetReaderTrackOutput *audioOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:@{AVFormatIDKey:@(kAudioFormatLinearPCM)}];
    [reader addOutput:audioOutput];
    [reader startReading];
    
    AVAssetWriterInput *videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:[self videoOuputSetting]];
    AVAssetWriterInput *audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:[self audioOuputSetting]];
    audioInput.expectsMediaDataInRealTime = YES;
    [writer addInput:videoInput];
    [writer addInput:audioInput];
    [writer startWriting];
    [writer startSessionAtSourceTime:kCMTimeZero];
    
    [videoInput requestMediaDataWhenReadyOnQueue:dispatch_get_global_queue(0, 0) usingBlock:^{
        while ([videoInput isReadyForMoreMediaData]) {
            CMSampleBufferRef buffer = [videoOutput copyNextSampleBuffer];
            BOOL sucess = NO;
            if (buffer) {
                @try {
                    sucess = [videoInput appendSampleBuffer:buffer];
                }@catch (NSException *exception) {
                    NSLog(@"%@",exception.reason);
                }@finally {
                    NSLog(@"%d %zd %0.2f",sucess, writer.status, CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(buffer)));
                    CFRelease(buffer);
                }
            }
            if (!sucess) {
                [videoInput markAsFinished];
                _videoFinish = YES;
                [self checkVideoFinish];
                break;
            }
        }
    }];
    
    [audioInput requestMediaDataWhenReadyOnQueue:dispatch_get_global_queue(0, 0) usingBlock:^{
        while ([audioInput isReadyForMoreMediaData]) {
            CMSampleBufferRef buffer = [audioOutput copyNextSampleBuffer];
            BOOL sucess = NO;
            if (buffer) {
                sucess = [audioInput appendSampleBuffer:buffer];
            }
            if (!sucess) {
                [audioInput markAsFinished];
                _audioFinish = YES;
                [self checkVideoFinish];
                break;
            }
        }
    }];
}

- (void)checkVideoFinish{
    if (!(_videoFinish && _audioFinish)) {
        return;
    }
    [_writer finishWritingWithCompletionHandler:^{
        if (_writer.error) {
            // 写入失败改变参数重试
            _profileLevel = [self nextProfileLevelFrom:_profileLevel];
        } else {
            _profileLevel = nil;
        }
        if (_profileLevel) {
            _videoFinish = NO;
            _audioFinish = NO;
            [_reader cancelReading];
            [_writer cancelWriting];
            _reader = nil;
            _writer = nil;
            [self nextCombineFromAsset:_asset toURL:_toURL];
        } else {
        }
    }];
    
}


- (NSString *)nextProfileLevelFrom:(NSString *)level{
    NSArray *levels = @[AVVideoProfileLevelH264HighAutoLevel, AVVideoProfileLevelH264MainAutoLevel, AVVideoProfileLevelH264BaselineAutoLevel];
    NSUInteger index = [levels indexOfObject:level];
    if (index == NSNotFound) {
        return  levels[0];
    }
    index += 1;
    if (index >= levels.count) {
        return  nil;
    }
    return levels[index];
}

- (NSDictionary *)videoOuputSetting
{
    CGSize size = CGSizeMake(640, 640);
    CGFloat bitRate = 2 * 1000 * 1000;
    NSString *profileLevel = _profileLevel;
    
    NSDictionary *outputSettings =@{
                                    AVVideoCodecKey:AVVideoCodecH264,
                                    AVVideoWidthKey:@(size.width),
                                    AVVideoHeightKey:@(size.height),
                                    AVVideoScalingModeKey:AVVideoScalingModeResizeAspectFill,
                                    AVVideoCompressionPropertiesKey:@{
                                            AVVideoAverageBitRateKey:@(bitRate),
                                            AVVideoProfileLevelKey:profileLevel,
                                            AVVideoCleanApertureKey:@{
                                                    AVVideoCleanApertureWidthKey:@(size.width),
                                                    AVVideoCleanApertureHeightKey:@(size.height),
                                                    AVVideoCleanApertureHorizontalOffsetKey:@(10),
                                                    AVVideoCleanApertureVerticalOffsetKey:@(10),
                                                    },
                                            AVVideoPixelAspectRatioKey:@{
                                                    AVVideoPixelAspectRatioHorizontalSpacingKey:@(1),
                                                    AVVideoPixelAspectRatioVerticalSpacingKey:@(1),
                                                    },
                                            },
                                    };
    return outputSettings;
}

- (NSDictionary *)audioOuputSetting
{
    double preferredHardwareSampleRate = [[AVAudioSession sharedInstance] sampleRate];
    AudioChannelLayout acl;
    bzero( &acl, sizeof(acl));
    acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;
    NSDictionary *outputSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                   [ NSNumber numberWithInt: 1 ], AVNumberOfChannelsKey,
                                   [ NSNumber numberWithFloat: preferredHardwareSampleRate ], AVSampleRateKey,
                                   [ NSData dataWithBytes: &acl length: sizeof( acl ) ], AVChannelLayoutKey,
                                   [ NSNumber numberWithInt: 64000 ], AVEncoderBitRateKey,
                                   nil];
    return outputSetting;
}

@end
