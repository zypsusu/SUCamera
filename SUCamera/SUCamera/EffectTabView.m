//
//  EffectTabArrowLine.m
//  qupai
//
//  Created by yly on 14/11/12.
//  Copyright (c) 2014年 duanqu. All rights reserved.
//

#import "EffectTabView.h"

@implementation EffectTabView


- (void)setArrowX:(CGFloat)arrowX
{
    _arrowX = arrowX;
    [self setNeedsDisplay];
}

- (void)setArrowH:(CGFloat)arrowH
{
    _arrowH = arrowH;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat arrowX = _arrowX;
    CGPoint points[5] = {};
    points[0].x = 0;
    points[0].y = h;
    points[1].x = arrowX - 6;
    points[1].y = h;
    points[2].x = arrowX;
    points[2].y = h - _arrowH;
    points[3].x = arrowX + 6;
    points[3].y = h;
    points[4].x = w;
    points[4].y = h;
    CGContextAddLines(context, points, sizeof(points)/sizeof(CGPoint));
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokePath(context);
}


@end
