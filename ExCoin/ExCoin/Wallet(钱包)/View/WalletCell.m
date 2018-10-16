//
//  WalletCell.m
//  ExCoin
//
//  Created by 周飙 on 2018/10/8.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "WalletCell.h"

@implementation WalletCell

-(void)setCellModel:(WalletModel *)model{
    self.nameLab.text = model.tickername;
    self.cnyLab1.text = model.frozen;
    self.priceLab.text = model.allNum;
    self.cnyLab2.text = [NSString stringWithFormat:@"≈%.2fCNY",([model.frozen doubleValue]+[model.available doubleValue])];
}

@end
