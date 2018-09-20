//
//  MarketCell.h
//  ExCoin
//
//  Created by 周飙 on 2018/9/19.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketModel.h"

@interface MarketCell : UITableViewCell
@property (strong,nonatomic)MarketModel * model;
@property (weak, nonatomic) IBOutlet PYZoomEchartsView *kchartView;

-(void)setCellModel:(MarketModel*)model;
@end
