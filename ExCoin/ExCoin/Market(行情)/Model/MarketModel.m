//
//  MarketModel.m
//  ExCoin
//
//  Created by 周飙 on 2018/10/9.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "MarketModel.h"

@implementation MarketModel
-(instancetype)initWithtickername:(NSString *)tickername buy:(NSString *)buy buy_amount:(NSString *)buy_amount open:(NSString *)open high:(NSString *)high last:(NSString *)last low:(NSString *)low sell:(NSString *)sell sell_amount:(NSString *)sell_amount vol:(NSString *)vol{
    self = [super init];
    if (!self) return nil;
    
    self.tickername = [tickername copy];
    self.buy = [buy copy];
    self.buy_amount = [buy_amount copy];
    self.open = [open copy];
    self.high = [high copy];
    self.last = [last copy];
    self.low = [low copy];
    self.sell = [sell copy];
    self.sell_amount = [sell_amount copy];
    self.vol = [vol copy];

    return self;
}
+ (NSString *)dbName {
    return @"GYDataCenterTests";
}
+ (NSString *)tableName {
    return @"MarketModel";
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
                       @"buy",
                       @"buy_amount",
                       @"open",
                       @"high",
                       @"last",
                       @"low",
                       @"sell",
                       @"sell_amount",
                       @"vol",
                       ];
    });
    return properties;
}
@end
