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
@property (strong, nonatomic) NSString *buy;
@property (strong, nonatomic) NSString *buy_amount;
@property (strong, nonatomic) NSString *open;
@property (strong, nonatomic) NSString *high;
@property (strong, nonatomic) NSString *last;
@property (strong, nonatomic) NSString *low;
@property (strong, nonatomic) NSString *sell;
@property (strong, nonatomic) NSString *sell_amount;
@property (strong, nonatomic) NSString *vol;
- (instancetype)initWithtickername:(NSString *)tickername
                               buy:(NSString *)buy
                        buy_amount:(NSString *)buy_amount
                              open:(NSString *)open
                              high:(NSString *)high
                              last:(NSString *)last
                               low:(NSString *)low
                              sell:(NSString *)sell
                       sell_amount:(NSString *)sell_amount
                               vol:(NSString *)vol;
@end
