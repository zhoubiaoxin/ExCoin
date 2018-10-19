//
//  TradeCell.h
//  ExCoin
//
//  Created by 周飙 on 2018/10/19.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketModel.h"
@interface TradeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *zhangfuLab;
-(void)setCellModel:(MarketModel*)model;
@end
