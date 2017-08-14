//
//  AudioMetersView.h
//  duanqu2
//
//  Created by lyle on 13-11-11.
//  Copyright (c) 2013年 duanqu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioMetersView : UIView

@property (nonatomic, strong) UIColor *colorNormal;

- (void)refreshMeter:(CGFloat)meter;

@end
