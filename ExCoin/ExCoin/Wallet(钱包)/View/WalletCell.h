//
//  WalletCell.h
//  ExCoin
//
//  Created by 周飙 on 2018/10/8.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletModel.h"
@interface WalletCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *cnyLab1;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *cnyLab2;


-(void)setCellModel:(WalletModel*)model;
@end
