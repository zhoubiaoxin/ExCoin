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
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *symbolLab;
@property (weak, nonatomic) IBOutlet UILabel *volLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *scaleLab;
@property (weak, nonatomic) IBOutlet UILabel *cnyLab;

-(void)setCellModel:(MarketModel*)model;

@end
