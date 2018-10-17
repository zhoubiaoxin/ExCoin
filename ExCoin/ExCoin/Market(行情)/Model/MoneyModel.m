//
//  moneyModel.m
//  ExCoin
//
//  Created by 周飙 on 2018/10/16.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "MoneyModel.h"

@implementation MoneyModel
-(instancetype)initWithtickername:(NSString *)tickername price:(NSString *)price{
    self = [super init];
    if (!self) return nil;
    
    self.tickername = [tickername copy];
    self.price = [price copy];

    return self;
}
+ (NSString *)dbName {
    return @"GYDataCenterTests";
}
+ (NSString *)tableName {
    return @"moneyModel";
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
                       @"price"
                       ];
    });
    return properties;
}

@end
