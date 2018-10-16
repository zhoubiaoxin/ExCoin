//
//  WalletModel.h
//  ExCoin
//
//  Created by 周飙 on 2018/10/16.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "GYModelObject.h"

@interface WalletModel : GYModelObject

@property (strong, nonatomic) NSString *tickername;
@property (assign, nonatomic) double available;
@property (assign, nonatomic) double frozen;
@property (assign, nonatomic) double allNum;


- (instancetype)initWithtickername:(NSString *)tickername
                         available:(double)available
                            frozen:(double)frozen
                            allNum:(double)allNum;

@end
