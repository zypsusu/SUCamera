//
//  Video.h
//  SUCamera
//
//  Created by zypsusu on 2017/8/1.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VideoPoint;

@interface Video : NSObject <NSCoding, NSCopying>

@property (nonatomic, readonly)CGSize size;
@property (nonatomic, strong) NSMutableArray *arrayPoint;
@property (nonatomic, assign) CGFloat recordDuration;
@property (nonatomic, assign) CGFloat alreadyRecordDuration;
@property (nonatomic, strong) NSURL *originURL;
@property (nonatomic, strong) NSURL *finalURL;
@property (nonatomic, assign) CGFloat duration;

- (NSString *)newUniquePathWithExt:(NSString *)ext;
- (VideoPoint *)lastPoint;
- (void)updateTimestamp;

@end
