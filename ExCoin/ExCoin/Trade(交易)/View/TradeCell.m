//
//  TradeCell.m
//  ExCoin
//
//  Created by 周飙 on 2018/10/19.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "TradeCell.h"

@implementation TradeCell

-(void)setCellModel:(MarketModel *)model{
    if ([model.store isEqualToString:@"0"]) {
        [self.storeBtn setBackgroundImage:[UIImage imageNamed:@"icon_unstore"] forState:UIControlStateNormal];
    }else{
        [self.storeBtn setBackgroundImage:[UIImage imageNamed:@"icon_store"] forState:UIControlStateNormal];
    }
    
    NSString *last3 = [model.tickername substringFromIndex:model.tickername.length-3];
    if ([last3 isEqualToString:@"SDT"]) {
        NSString *first = [model.tickername substringToIndex:model.tickername.length-4];
        self.nameLab.text = first;
    }else{
        NSString *first = [model.tickername substringToIndex:model.tickername.length-3];
        self.nameLab.text = first;
    }
    
    
    self.priceLab.text = [NSString stringWithFormat:@"%.8f",[model.last doubleValue]];
    
    if ([model.last doubleValue]>[model.open doubleValue]) {
        self.zhangfuLab.text = [NSString stringWithFormat:@"+%.2f%@",[model.zhangfu doubleValue]*100-100,@"%"];
        self.zhangfuLab.textColor = [UIColor colorWithHex:@"#0ab9bd"];
        self.priceLab.textColor = [UIColor colorWithHex:@"#0ab9bd"];
    }else{
        self.zhangfuLab.text = [NSString stringWithFormat:@"%.2f%@",[model.zhangfu doubleValue]*100-100,@"%"];
        self.zhangfuLab.textColor = [UIColor colorWithHex:@"#f13d68"];
        self.priceLab.textColor = [UIColor colorWithHex:@"#f13d68"];

    }
    
}
@end
