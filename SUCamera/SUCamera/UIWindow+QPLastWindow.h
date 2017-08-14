//
//  UIWindow+QPLastWindow.h
//  qupai
//
//  Created by yly on 15/9/22.
//  Copyright © 2015年 duanqu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (QPLastWindow)

+ (UIWindow *)qp_lastWindow;
+ (UIWindow *)qp_rootWindow;

@end
