
//
//  VideoPoint.m
//  SUCamera
//
//  Created by zypsusu on 2017/8/1.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import "VideoPoint.h"
#import <AVFoundation/AVFoundation.h>

#define ScreenWidth  CGRectGetWidth([[UIScreen mainScreen] bounds])

@implementation VideoPoint

- (CGFloat)duration
{
    if (_duration == 0) {
        [self updateTime];
    }
    return _duration;
}

- (void)updateTime
{
    AVAssetTrack *videoTrack;
    AVAssetTrack *audioTrack;
    AVURLAsset *asset = [[AVURLAsset alloc]initWithURL:_fileURL options:nil];
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        audioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    if (videoTrack) {
        _videoTime = CMTimeGetSeconds(videoTrack.timeRange.duration);
    }
    if (audioTrack) {
        _audioTime = CMTimeGetSeconds(audioTrack.timeRange.duration);
    }
    if (_audioTime == 0) {
        _duration = _videoTime;
    }else{
        _duration = _videoTime > _audioTime ? _audioTime : _videoTime;
    }
}

- (CGPoint)startPointFromWidth:(NSInteger)width
{
    return CGPointMake(_startTime/_maxDuration*ScreenWidth, 0);
}

- (CGPoint)endPointFromWidth:(NSInteger)width
{
    return CGPointMake(_endTime/_maxDuration*ScreenWidth - 1, 0);
}
@end
