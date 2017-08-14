//
//  AudioMetersView.m
//  duanqu2
//
//  Created by lyle on 13-11-11.
//  Copyright (c) 2013年 duanqu. All rights reserved.
//

#import "AudioMetersView.h"

@interface AudioMetersView()
{
    CGFloat _meter;
    CGFloat _level;
}

@end
@implementation AudioMetersView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)refreshMeter:(CGFloat)meter
{
    _meter = meter;
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels = _meter;
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    _level = level;
    NSLog(@"meter = %f %f",meter, level);
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 10.0f);
//    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:250.0/255.0 green:102.0/255.0 blue:42.0/255.0 alpha:1.0] CGColor]);
//    CGContextMoveToPoint(context, 0, 160);
//    CGContextAddLineToPoint(context, 0, 160 - 160 *_level);
//    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 10.0f);
    CGContextSetFillColorWithColor(context, _colorNormal.CGColor);
    CGFloat value = 0.0;
    CGRect r = CGRectMake(0, 160, 20, 5);
    while (value < _level) {
        CGContextFillRect(context, r);
        value = value + 0.03;
        r.origin.y = r.origin.y - 8;
    }
}

@end
