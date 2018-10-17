//
//  Singleton.m
//  ZWXYMTDemo
//
//  Created by 周飙 on 2018/3/30.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
static Singleton *instance = nil;
+ (instancetype)sharedInstance
{
    return [[self alloc] init];
}

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
    });
    return instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

@end
