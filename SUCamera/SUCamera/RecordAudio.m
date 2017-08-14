//
//  POVoiceHUD.m
//  POVoiceHUD
//
//  Created by Polat Olu on 18/04/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//


// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2013 Polat Olu
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RecordAudio.h"
#import "VideoPoint.h"

@interface RecordAudio()
{
    int soundMeters[40];
    
    NSMutableDictionary *recordSetting;
    NSString *recorderFilePath;
    AVAudioRecorder *recorder;
    
    SystemSoundID soundID;
    NSTimer *timer;
    
    double _startDeviceTime;
}

@end

@implementation RecordAudio

#pragma mark - RecordAudio

- (void)sticherAudio:(NSArray *)array toPath:(NSString *)path withCompletionHandler:(void (^)(NSString *path))completionHandler
{
    NSLog(@"sticher audio");
    if (!array || array.count == 0) {
        if (completionHandler) {
            completionHandler(nil);
        }
        return;
    }
    AVMutableComposition *composition;
    AVMutableCompositionTrack *compositionAudioTrack;
    
    composition = [AVMutableComposition composition];
    compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSError *error;
    CMTime audioTime = kCMTimeZero;

    for (VideoPoint *vp in array) {
        @try {
            NSURL *url = vp.fileURL;
            AVURLAsset *asset = [[AVURLAsset alloc]initWithURL:url options:nil];
            AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioTrack.timeRange.duration) ofTrack:audioTrack atTime:audioTime error:&error];
            if(error){
                NSLog(@"%@", error.description);
                continue;
            }
            audioTime = CMTimeAdd(audioTime, audioTrack.timeRange.duration);
        }
        @catch (NSException *exception) {
            NSLog(@"sticher audio failed");
        }
        @finally {
        }
    }
    if (CMTIME_COMPARE_INLINE(audioTime, ==, kCMTimeZero)) {
        if (completionHandler) {
            completionHandler(nil);
        }
        return;
    }
    AVAssetExportSession *exporter = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    NSParameterAssert(exporter != nil);
    exporter.outputFileType = AVFileTypeAppleM4A;
    exporter.outputURL = [NSURL fileURLWithPath:path];
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"exporter succ");
        switch([exporter status])
        {
            case AVAssetExportSessionStatusFailed:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(nil);
                });
            } break;
            case AVAssetExportSessionStatusCancelled:
            case AVAssetExportSessionStatusCompleted:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(path);
                });
            } break;
            default:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(nil);
                });
            } break;
        }
    }];
}

#pragma mark - RecordAudio

- (id)init
{
    self = [super init];
    if (self) {
        for(int i=0; i<SOUND_METER_COUNT; i++) {
            soundMeters[i] = 0;
        }
    }
    
    return self;
}

- (int *)getMeters
{
    return soundMeters;
}

- (void)startForFilePath:(NSString *)filePath {
    
    
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
	if(err){
        NSLog(@"audioSession: %@ %zd %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
    
	[audioSession setActive:YES error:&err];
	if(err){
        NSLog(@"audioSession: %@ %zd %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    
    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride
                             );
	recordSetting = [[NSMutableDictionary alloc] init];
	
	// You can change the settings for the voice quality
	[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
	[recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
	[recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
	
	// if you are using kAudioFormatLinearPCM format, activate these settings
	//[recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	//[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	//[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
	
    NSLog(@"Recording at: %@", filePath);
	recorderFilePath = filePath;
	
	NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
	

	if([[NSFileManager defaultManager] fileExistsAtPath:recorderFilePath]){
		[[NSFileManager defaultManager] removeItemAtPath:recorderFilePath error:&err];
	}
	
	recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    
	if(!recorder){
        NSLog(@"recorder: %@ %zd %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [alert show];
        return;
	}
	
	recorder.delegate = self;
	recorder.meteringEnabled = YES;
	[recorder prepareToRecord];

	BOOL audioHWAvailable = audioSession.isInputAvailable;
	if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: @"Audio input hardware not available"
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
	}
	
	[recorder record];
	_startDeviceTime = CFAbsoluteTimeGetCurrent();
	timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

- (void)updateMeters {
    [recorder updateMeters];
    [self addSoundMeterItem:[recorder averagePowerForChannel:0]];
    
    double durationn = CFAbsoluteTimeGetCurrent() - _startDeviceTime;
    if ([_delegate respondsToSelector:@selector(voiceRecord:progress:)]) {
        [_delegate voiceRecord:self progress:durationn];
    }
}

- (void)finish {
    CGFloat recordTime1 = recorder.currentTime;
    
    [recorder stop];
    recorder = nil;
    
    [timer invalidate];
    timer = nil;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    if ([self.delegate respondsToSelector:@selector(POVoiceHUD:voiceRecorded:length:)]) {
        [self.delegate recordAudio:self path:recorderFilePath length:recordTime1];
    }
    if ([_delegate respondsToSelector:@selector(recordAudio:meter:)]) {
        [_delegate recordAudio:self meter:-160];
    }
}

#pragma mark - Sound meter operations

- (void)shiftSoundMeterLeft {
    for(int i=0; i<SOUND_METER_COUNT - 1; i++) {
        soundMeters[i] = soundMeters[i+1];
    }
}

- (void)addSoundMeterItem:(int)lastValue {
//    [self shiftSoundMeterLeft];
//    [self shiftSoundMeterLeft];
//    soundMeters[SOUND_METER_COUNT - 1] = lastValue;
//    soundMeters[SOUND_METER_COUNT - 2] = lastValue;
    
    if ([_delegate respondsToSelector:@selector(recordAudio:meter:)]) {
        [_delegate recordAudio:self meter:lastValue];
    }
}

@end
