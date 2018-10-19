//
//  TardeViewCell.h
//  ExCoin
//
//  Created by 周飙 on 2018/10/8.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TardeViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buyNum;
@property (weak, nonatomic) IBOutlet UILabel *buyPrice;
@property (weak, nonatomic) IBOutlet UILabel *sellPrice;
@property (weak, nonatomic) IBOutlet UILabel *sellNum;

@end
