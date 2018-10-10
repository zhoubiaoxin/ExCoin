//
//  MarketModel.h
//  ExCoin
//
//  Created by 周飙 on 2018/10/9.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "GYModelObject.h"

@interface MarketModel : GYModelObject
@property (strong, nonatomic) NSString *tickername;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *buy;
@property (strong, nonatomic) NSString *buy_amount;
@property (strong, nonatomic) NSString *open;
@property (strong, nonatomic) NSString *high;
@property (strong, nonatomic) NSString *last;
@property (strong, nonatomic) NSString *low;
@property (strong, nonatomic) NSString *sell;
@property (strong, nonatomic) NSString *sell_amount;
@property (strong, nonatomic) NSString *vol;
@property (strong, nonatomic) NSString *store;
@property (strong, nonatomic) NSString *zhangfu;

- (instancetype)initWithtickername:(NSString *)tickername
                               date:(NSString *)date
                               buy:(NSString *)buy
                        buy_amount:(NSString *)buy_amount
                              open:(NSString *)open
                              high:(NSString *)high
                              last:(NSString *)last
                               low:(NSString *)low
                              sell:(NSString *)sell
                       sell_amount:(NSString *)sell_amount
                               vol:(NSString *)vol
                             store:(NSString *)store
                           zhangfu:(NSString *)zhangfu;

@end
