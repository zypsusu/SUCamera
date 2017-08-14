//
//  UIWindow+QPLastWindow.m
//  qupai
//
//  Created by yly on 15/9/22.
//  Copyright © 2015年 duanqu. All rights reserved.
//

#import "UIWindow+QPLastWindow.h"

@implementation UIWindow (QPLastWindow)

+ (UIWindow *)qp_lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            
            return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

+ (UIWindow *)qp_rootWindow{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
       // if ([window isKindOfClass:[UIWindow class]] &&
            //CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds) &&
           // [window.rootViewController isKindOfClass:[RootViewController class]])
            
            return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}
@end
