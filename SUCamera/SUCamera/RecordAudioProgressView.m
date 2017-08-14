//
//  RecordAudioProgressView.m
//  qupai
//
//  Created by yly on 15/5/22.
//  Copyright (c) 2015年 duanqu. All rights reserved.
//

#import "RecordAudioProgressView.h"

@implementation RecordAudioProgressView{
    UIImageView *_lineImageView;
    UIView *_maskView;
    CGFloat _progress;
}

- (void)updateProgress:(CGFloat)progress
{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = [UIColor colorWithRed:2/255.0 green:212/255.0 blue:255/255.0 alpha:1.0];
        _maskView.alpha = 0.5;
        [self addSubview:_maskView];
    }
    if (_lineImageView == nil) {
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record_progress"]];
        _lineImageView.center = CGPointMake(0, 0);
        [self addSubview:_lineImageView];
    }
    
    _progress = progress;
    
    CGPoint center = _lineImageView.center;
    center.x = CGRectGetWidth(self.bounds) * _progress;
    if (CGRectGetHeight([[UIScreen mainScreen] bounds]) == 480) {
        center.y = 42/2;
    }else{
        center.y = CGRectGetHeight(self.bounds) /2;
    }
    _lineImageView.center = center;
    
    CGRect frame = CGRectZero;
    frame.size.width = center.x;
    if (CGRectGetHeight([[UIScreen mainScreen] bounds]) == 480) {
        frame.size.height = 42;
    }else{
        frame.size.height = CGRectGetHeight(self.bounds);
        CGRect f = _lineImageView.frame;
        f.size.height = CGRectGetHeight(self.bounds);
        _lineImageView.frame = f;
    }
    _maskView.frame = frame;
}

@end
