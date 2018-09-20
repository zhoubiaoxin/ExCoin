//
//  MarketCell.m
//  ExCoin
//
//  Created by 周飙 on 2018/9/19.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "MarketCell.h"
#import "PYCartesianSeries.h"

@implementation MarketCell

-(void)setCellModel:(MarketModel *)model{
    
    PYOption *option = [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory).boundaryGapEqual(@NO).addDataArr(@[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"])
            .showEqual(false);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue)
                .showEqual(false)
                 .scaleEqual(true);
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@2).yEqual(@2).x2Equal(@2).y2Equal(@2)
                .borderWidthEqual(@0);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES)
            .symbolSizeEqual(@0)
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.colorEqual([PYColor colorWithHexString:@"#0ad9bd"])
                          .areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault)
                        .colorEqual(PYRGBA(10, 217, 189, 0.3));
                    }]);
                }]);
            }])
            .dataEqual(@[@(10),@(30),@(20),@(40),@(30),@(20),@(12)]);
        }]);
    }];
    if (option != nil) {
        [_kchartView setOption:option];
    }
    [_kchartView loadEcharts];
}

@end
