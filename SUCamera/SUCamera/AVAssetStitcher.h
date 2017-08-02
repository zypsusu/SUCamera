//
//  AVAssetStitcher.h
//  SUCamera
//
//  Created by zypsusu on 2017/8/2.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVAssetStitcher : NSObject
- (id)initWithOutputSize:(CGSize)outSize;
- (void)addAsset:(AVURLAsset *)asset rotate:(NSInteger)rotate withError:(NSError **)error;
- (void)exportTo:(NSURL *)outputFile withPreset:(NSString *)preset withCompletionHandler:(void (^)(NSError *error))completed;

@end
