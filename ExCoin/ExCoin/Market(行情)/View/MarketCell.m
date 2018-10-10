//
//  MarketCell.m
//  ExCoin
//
//  Created by 周飙 on 2018/9/19.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "MarketCell.h"
#import "PYCartesianSeries.h"
#import "Y_KLineGroupModel.h"

@implementation MarketCell

-(void)setCellModel:(MarketModel *)model{
    if ([model.store isEqualToString:@"0"]) {
        [self.storeBtn setBackgroundImage:[UIImage imageNamed:@"icon_unstore"] forState:UIControlStateNormal];
    }else{
        [self.storeBtn setBackgroundImage:[UIImage imageNamed:@"icon_store"] forState:UIControlStateNormal];
    }
    
    NSString *last3 = [model.tickername substringFromIndex:model.tickername.length-3];
    if ([last3 isEqualToString:@"SDT"]) {
        self.symbolLab.text = @"/USDT";
        NSString *first = [model.tickername substringToIndex:model.tickername.length-4];
        self.nameLab.text = first;
    }else{
        self.symbolLab.text = [NSString stringWithFormat:@"/%@",last3];
        NSString *first = [model.tickername substringToIndex:model.tickername.length-3];
        self.nameLab.text = first;
    }
    
    if ([model.sell_amount intValue]>=10000) {
        self.volLab.text = [NSString stringWithFormat:@"%.2f万",[model.sell_amount floatValue]/10000];
    }else{
        self.volLab.text = [NSString stringWithFormat:@"%.2f",[model.sell_amount floatValue]];
    }
    
    self.numLab.text = [NSString stringWithFormat:@"%.8f",[model.last floatValue]];
    if ([model.last floatValue]>[model.open floatValue]) {
        [self.scaleLab setBackgroundImage:[UIImage imageNamed:@"icon_upBg"] forState:UIControlStateNormal];
        [self.scaleLab setTitle:[NSString stringWithFormat:@"+%.2f%@",([model.last floatValue]-[model.open floatValue])/[model.open floatValue],@"%"] forState:UIControlStateNormal];
        self.numLab.textColor = [UIColor colorWithHex:@"#0ab9bd"];
    }else{
        [self.scaleLab setBackgroundImage:[UIImage imageNamed:@"icon_downBg"] forState:UIControlStateNormal];
        [self.scaleLab setTitle:[NSString stringWithFormat:@"%.2f%@",([model.last floatValue]-[model.open floatValue])/[model.open floatValue],@"%"] forState:UIControlStateNormal];
        self.numLab.textColor = [UIColor colorWithHex:@"#f13d68"];
    }
    
    [self createCharts:model];
}
-(void)createCharts:(MarketModel *)model{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"15min";
    param[@"market"] = model.tickername;
    param[@"limit"] = @"96";
    [NetWorking requestWithApi:@"https://api.coinex.com/v1/market/kline" param:param thenSuccess:^(NSDictionary *responseObject) {
        //NSLog(@"===:%@",responseObject);
        NSArray* arr = responseObject[@"data"];
        [self createChartsView:arr andModel:model];
    } fail:^{
        
    }];
}
-(void)createChartsView:(NSArray*)arr andModel:(MarketModel *)model{
    NSMutableArray * YArr = [[NSMutableArray alloc] init];
    NSMutableArray * XArr = [[NSMutableArray alloc] init];

    for (int i = 0; i<arr.count; i++) {
        NSArray * arrlist = arr[i];
        if (arrlist[0]!=NULL) {
            [XArr addObject:arrlist[0]];
        }
        if (arrlist[3]!=NULL&&arrlist[4]!=NULL) {
            [YArr addObject:arrlist[3]];
        }else{
            [YArr addObject:@""];
        }
        if (i == arr.count-1) {
            [self createChartsView:XArr andYArr:YArr andModel:model];
        }
    }
}
-(void)createChartsView:(NSArray*)XArr andYArr:(NSArray*)YArr andModel:(MarketModel *)model{
    NSString * colorStr;
    int r;
    int g;
    int b;
    if ([model.last floatValue]>=[model.open floatValue]) {
        colorStr = @"#0ad9bd";
        r = 10;
        g = 217;
        b = 189;
    }else{
        colorStr = @"#f13d68";
        r = 241;
        g = 61;
        b = 104;
    }
    PYOption *option = [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory).boundaryGapEqual(@NO).addDataArr(XArr)
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
                    normal.colorEqual([PYColor colorWithHexString:colorStr])
                    .areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault)
                        .colorEqual(PYRGBA(r, g, b, 0.3));
                    }]);
                }]);
            }])
            .dataEqual(YArr);
        }]);
    }];
    if (option != nil) {
        [_kchartView setOption:option];
    }
    [_kchartView loadEcharts];
}

@end
