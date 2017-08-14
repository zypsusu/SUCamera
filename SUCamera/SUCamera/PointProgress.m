//
//  PointProgress.m
//  SUCamera
//
//  Created by zypsusu on 2017/8/2.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import "PointProgress.h"
#import "VideoPoint.h"


@interface PointProgress ()
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PointProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)updateProgress:(CGFloat)progress
{
    [self setNeedsDisplay];
}

- (void)setShowBlink:(BOOL)showBlink
{
    _showBlink = showBlink;
    [_timer invalidate];
    if (_showBlink) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self
                                                selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    }
}

#define RGBToColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, CGRectGetHeight(self.bounds) * [[UIScreen mainScreen] scale]);
    
    CGFloat w = CGRectGetWidth(self.superview.bounds);
    
    if (_colorBg) {
        CGContextSetStrokeColorWithColor(context, _colorBg.CGColor);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, w, 0);
        CGContextStrokePath(context);
    }
    
    for (int i = 0; i < _array.count; ++i) {
        VideoPoint *vp = _array[i];
        //if (vp.select) {
          //  CGContextSetStrokeColorWithColor(context, _colorSelect.CGColor);
        //}else{
            CGContextSetStrokeColorWithColor(context, _colorNomal.CGColor);
        //}
        CGPoint point = [vp startPointFromWidth:self.frame.size.width];
        CGContextMoveToPoint(context, point.x, point.y);
        point = [vp endPointFromWidth:self.frame.size.width];
        CGContextAddLineToPoint(context, point.x, point.y);
        CGContextStrokePath(context);
    }
    for (int i = 0; i < _array.count; ++i) {
        VideoPoint *vp = _array[i];
        if (i < _array.count - 1) {
            CGContextSetStrokeColorWithColor(context, RGBToColor(0, 0, 0, 1).CGColor);
            CGPoint point = [vp endPointFromWidth:self.frame.size.width];
            CGContextMoveToPoint(context, point.x, point.y);
            CGContextAddLineToPoint(context, point.x, point.y);
            CGContextStrokePath(context);
        }
    }
    
    if (_showNoticePoint) {
        CGContextSetStrokeColorWithColor(context, _colorNotice.CGColor);
        CGContextMoveToPoint(context, w*2/8, 0);
        CGContextAddLineToPoint(context, w*2/8+1,0);
        CGContextStrokePath(context);
    }
    if (_showCursor && (_showBlink ? ++_times : (_times=1)) && (_times%2 == 1)) {
        
        CGRect r = CGRectMake(0, 0, 20/2, 27/2);
        VideoPoint *vp = (VideoPoint *)[_array lastObject];
        if (vp) {
            CGPoint point = [vp endPointFromWidth:self.frame.size.width];
            r.origin.x += point.x;
            r.origin.y += point.y;
        }
        
        CGContextSetStrokeColorWithColor(context, RGBToColor(0, 255, 255, 1).CGColor);
        CGContextMoveToPoint(context, r.origin.x, r.origin.y);
        CGContextAddLineToPoint(context, r.origin.x + 4, r.origin.y);
        CGContextStrokePath(context);
    }
}

@end
