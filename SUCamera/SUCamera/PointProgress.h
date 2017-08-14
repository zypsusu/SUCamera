//
//  PointProgress.h
//  SUCamera
//
//  Created by zypsusu on 2017/8/2.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointProgress : UIView
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) BOOL showNoticePoint;
@property (nonatomic, assign) BOOL showBlink;
@property (nonatomic, assign) BOOL showCursor;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, strong) UIColor *colorNomal;
@property (nonatomic, strong) UIColor *colorSelect;
@property (nonatomic, strong) UIColor *colorBg;
@property (nonatomic, strong) UIColor *colorNotice;

- (void)updateProgress:(CGFloat)progress;

@end
