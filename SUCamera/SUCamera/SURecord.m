//
//  SURecord.m
//  SUCamera
//
//  Created by zypsusu on 2017/7/31.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import "SURecord.h"

@interface SURecord ()

@end

@implementation SURecord

+ (SURecord *)shared{
    static SURecord *record;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        record = [[SURecord alloc] init];
    });
    return record;
}

@end
