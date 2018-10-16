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
@property (strong, nonatomic) NSString *available;
@property (strong, nonatomic) NSString *frozen;
@property (strong, nonatomic) NSString *allNum;


- (instancetype)initWithtickername:(NSString *)tickername
                         available:(NSString *)available
                            frozen:(NSString *)frozen
                            allNum:(NSString *)allNum;

@end
