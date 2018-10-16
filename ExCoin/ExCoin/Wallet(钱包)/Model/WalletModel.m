//
//  WalletModel.m
//  ExCoin
//
//  Created by 周飙 on 2018/10/16.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "WalletModel.h"

@implementation WalletModel
-(instancetype)initWithtickername:(NSString *)tickername available:(NSString *)available frozen:(NSString *)frozen allNum:(NSString *)allNum{
    self = [super init];
    if (!self) return nil;
    
    self.tickername = [tickername copy];
    self.available = [available copy];
    self.frozen = [frozen copy];
    self.allNum = [allNum copy];
    return self;
}
+ (NSString *)dbName {
    return @"GYDataCenterTests";
}
+ (NSString *)tableName {
    return @"WalletModel";
}
+ (NSString *)primaryKey {
    return @"tickername";
}
//持久化属性(也就是要在表中储存的column列名)
+ (NSArray *)persistentProperties {
    static NSArray *properties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        properties = @[
                       @"tickername",
                       @"available",
                       @"frozen",
                       @"allNum"
                       ];
    });
    return properties;
}

@end
