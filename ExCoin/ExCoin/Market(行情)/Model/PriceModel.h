//
//  PriceModel.h
//  ExCoin
//
//  Created by 周飙 on 2018/10/17.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "GYModelObject.h"

@interface PriceModel : GYModelObject
@property (strong, nonatomic) NSString *tickername;
@property (strong, nonatomic) NSString *price;

- (instancetype)initWithtickername:(NSString *)tickername
                             price:(NSString *)price;
@end
