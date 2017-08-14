//
//  Video.m
//  SUCamera
//
//  Created by zypsusu on 2017/8/1.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import "Video.h"
#import "VideoPoint.h"
#import "YYModel.h"

@interface Video ()
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic) CGSize size;

@end

@implementation Video

- (instancetype)init{
    self = [super init];
    if (self) {
        _uuid = [Video uuid];
        _size = [Video videoSize];
    }
    return self;
}

- (void)updateTimestamp
{
    [[self lastPoint] updateTime];
    /*不改变原始分段数据，修正进度条*/
    
    CGFloat duration = 0.0;
    for (int i = 0; i < _arrayPoint.count; ++i) {
        VideoPoint *vp = _arrayPoint[i];
        vp.startTime = duration;
        duration = duration + vp.duration;
        vp.endTime = duration;
    }
}

- (NSString *)newUniquePathWithExt:(NSString *)ext
{
    NSString *path = [[[self recordDir] stringByAppendingPathComponent:[Video uuid]] stringByAppendingPathExtension:ext];
    return path;
}

- (CGFloat)alreadyRecordDuration
{
    CGFloat duration = 0.0;
    for (int i = 0; i < _arrayPoint.count; ++i) {
        if (i != _arrayPoint.count - 1) {
            VideoPoint *vp = _arrayPoint[i];
            duration = duration + vp.endTime - vp.startTime;
        }
    }
    return duration;
}

- (CGFloat)recordDuration
{
    CGFloat duration = 0.0;
    for (int i = 0; i < _arrayPoint.count; ++i) {
        VideoPoint *vp = _arrayPoint[i];
        duration = duration + vp.endTime - vp.startTime;
    }
    return duration;
}

- (VideoPoint *)lastPoint{
    return (VideoPoint *)_arrayPoint.lastObject;
}

- (NSString *)recordDir
{
    NSString *dir = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
                      stringByAppendingPathComponent:@"record"] stringByAppendingPathComponent:self.uuid];
    [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    return dir;
}

- (NSMutableArray *)arrayPoint{
    if (!_arrayPoint) {
        _arrayPoint = [NSMutableArray arrayWithCapacity:2];
    }
    return _arrayPoint;
}

+ (NSString*)uuid{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (CGSize)videoSize
{
    return CGSizeMake(640, 640);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    [self yy_modelInitWithCoder:aDecoder];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    Video *video            = [[Video allocWithZone:zone] init];
    video.uuid              = self.uuid;
    video.originURL         = self.originURL;
    video.finalURL          = self.finalURL;
    video.duration          = self.duration;
    video.arrayPoint        = [[NSMutableArray alloc]initWithArray:self.arrayPoint copyItems:YES];;
    
    //video.arrayPasterPoint = [[NSMutableArray alloc]initWithArray:self.arrayPasterPoint copyItems:YES];
    //video.arrayFace = [[NSMutableArray alloc]initWithArray:self.arrayFace copyItems:YES];
    return video;
}

@end
