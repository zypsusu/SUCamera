//
//  SURecord.h
//  SUCamera
//
//  Created by zypsusu on 2017/7/31.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SURecordDelegate <NSObject>

@optional

@end

@interface SURecord : NSObject

+ (SURecord *)shared;

@property (nonatomic, weak) id<SURecordDelegate> delegate;

@end
