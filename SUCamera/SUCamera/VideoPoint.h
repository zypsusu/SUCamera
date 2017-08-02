//
//  VideoPoint.h
//  SUCamera
//
//  Created by zypsusu on 2017/8/1.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VideoPoint : NSObject
@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat endTime;
@property (nonatomic, strong) NSURL *fileURL;

@property (nonatomic, assign) CGFloat videoTime;
@property (nonatomic, assign) CGFloat audioTime;
@property (nonatomic, assign) CGFloat duration;


- (void)updateTime;

@end
