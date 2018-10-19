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
#import "MoneyModel.h"
#import "PriceModel.h"
#import "Singleton.h"

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
        NSArray * arr = [MoneyModel objectsWhere:@"where tickername ='USDT'" arguments:nil];
        if (arr) {
            MoneyModel * model1 = arr[0];
            double cnydou = [model.last doubleValue]*[model1.price doubleValue];
            if (cnydou>1) {
                self.cnyLab.text = [NSString stringWithFormat:@"%.2f",[model.last doubleValue]*[model1.price doubleValue]];
            }else{
                self.cnyLab.text = [NSString stringWithFormat:@"%.4f",[model.last doubleValue]*[model1.price doubleValue]];
            }
            NSArray * cnyArr = [PriceModel objectsWhere:[NSString stringWithFormat:@"where tickername ='%@'",first] arguments:nil];
            if (cnyArr.count > 0) {
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"price"] = [NSString stringWithFormat:@"%.4f",cnydou];
                [PriceModel updateObjectsSet:param Where:[NSString stringWithFormat:@"where tickername ='%@'",first] arguments:nil];
            }else{
                PriceModel * price = [[PriceModel alloc] initWithtickername:first price:[NSString stringWithFormat:@"%.4f",cnydou]];
                [price save];
            }
        }
    }else{
        self.symbolLab.text = [NSString stringWithFormat:@"/%@",last3];
        NSString *first = [model.tickername substringToIndex:model.tickername.length-3];
        self.nameLab.text = first;
        NSArray * arr = [MoneyModel objectsWhere:[NSString stringWithFormat:@"where tickername ='%@'",last3] arguments:nil];
        if (arr) {
            MoneyModel * model1 = arr[0];
            double cnydou = [model.last doubleValue]*[model1.price doubleValue];
            if (cnydou>1) {
                self.cnyLab.text = [NSString stringWithFormat:@"%.2f",[model.last doubleValue]*[model1.price doubleValue]];
            }else{
                self.cnyLab.text = [NSString stringWithFormat:@"%.4f",[model.last doubleValue]*[model1.price doubleValue]];
            }
            NSArray * cnyArr = [PriceModel objectsWhere:[NSString stringWithFormat:@"where tickername ='%@'",first] arguments:nil];
            if (cnyArr.count > 0) {
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"price"] = [NSString stringWithFormat:@"%.4f",cnydou];
                [PriceModel updateObjectsSet:param Where:[NSString stringWithFormat:@"where tickername ='%@'",first] arguments:nil];
            }else{
                PriceModel * price = [[PriceModel alloc] initWithtickername:first price:[NSString stringWithFormat:@"%.4f",cnydou]];
                [price save];
            }
        }
    }
    
    if (model.allStr>=10000) {
        self.volLab.text = [NSString stringWithFormat:@"%.2f万",model.allStr/10000];
    }else{
        self.volLab.text = [NSString stringWithFormat:@"%.2f",model.allStr];
    }
    
    self.numLab.text = [NSString stringWithFormat:@"%.8f",[model.last doubleValue]];
    
    if ([model.last doubleValue]>[model.open doubleValue]) {
        [self.scaleLab setBackgroundImage:[UIImage imageNamed:@"icon_upBg"] forState:UIControlStateNormal];
        [self.scaleLab setTitle:[NSString stringWithFormat:@"+%.2f%@",[model.zhangfu doubleValue]*100-100,@"%"] forState:UIControlStateNormal];
        self.numLab.textColor = [UIColor colorWithHex:@"#0ab9bd"];
    }else{
        [self.scaleLab setBackgroundImage:[UIImage imageNamed:@"icon_downBg"] forState:UIControlStateNormal];
        [self.scaleLab setTitle:[NSString stringWithFormat:@"%.2f%@",[model.zhangfu doubleValue]*100-100,@"%"] forState:UIControlStateNormal];
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
    if ([model.last floatValue]>[model.open floatValue]) {
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
    if (![[Singleton sharedInstance].name containsString:model.tickername]) {
        [_kchartView loadEcharts];
    }else{
        [_kchartView refreshEchartsWithOption:option];
    }
    if ([Singleton sharedInstance].name.length == 0) {
        [Singleton sharedInstance].name = model.tickername;
    }else{
        [Singleton sharedInstance].name = [NSString stringWithFormat:@"%@,%@",[Singleton sharedInstance].name,model.tickername];
    }
}

@end
