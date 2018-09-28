//
//  MarketListViewController.h
//  ExCoin
//
//  Created by 周飙 on 2018/9/18.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketModel.h"
@interface MarketListViewController1 : UIViewController
@property (nonatomic, copy) void(^passValueBlock)(MarketModel * model);
@end
