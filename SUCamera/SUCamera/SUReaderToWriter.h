//
//  SUReaderToWriter.h
//  SUCamera
//
//  Created by zypsusu on 2017/8/2.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SUReaderToWriter : NSObject

- (void)combineFromAsset:(AVAsset *)asset toURL:(NSURL *)toURL withCompletionHandler:(void (^)(NSError *error))completionHandler;

@end
