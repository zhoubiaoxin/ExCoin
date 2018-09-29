//
//  MarketDetailViewController.m
//  ExCoin
//
//  Created by 周飙 on 2018/9/25.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "MarketDetailViewController.h"
#import "Y_StockChartView.h"
#import "Y_KLineGroupModel.h"
#import "Masonry.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define SCREEN_MAX_LENGTH MAX(kScreenWidth,kScreenHeight)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

@interface MarketDetailViewController ()<Y_StockChartViewDataSource>
@property (nonatomic, strong) Y_StockChartView *stockChartView;
@property (nonatomic, strong) Y_KLineGroupModel *groupModel;
@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) int indexNum;

@end

@implementation MarketDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.type = @"1min";
    self.currentIndex = -1;
    [self reloadData];
    self.indexNum=0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(28, 35, 64);
}

- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeTime:(id)sender {
    UIButton * btn = (UIButton*)sender;
    self.indexNum = (int)btn.tag-100;
    UIView *view = (UIView*)[self.view viewWithTag:btn.tag+10];
    [self stockDatasWithIndex:self.indexNum];
    for (int i=100;i<105;i++) {//num为总共设置单选效果按钮的数目
        UIButton *btn1 = (UIButton*)[self.view viewWithTag:i];//view为这些btn的父视图
        btn1.selected = NO;
        UIView *view1 = (UIView*)[self.view viewWithTag:i+10];
        view1.hidden = YES;
    }
    btn.selected = YES;//sender.selected = !sender.selected;
    view.hidden = NO;
}

-(id) stockDatasWithIndex:(NSInteger)index
{
    NSString *type;
    switch (self.indexNum) {
        case 0:
        {
            type = @"1min";
        }
            break;
        case 1:
        {
            type = @"15min";
        }
            break;
        case 2:
        {
            type = @"1hour";
        }
            break;
        case 3:
        {
            type = @"1day";
        }
            break;
        case 4:
        {
            type = @"1week";
        }
            break;
            
        default:
            break;
    }
    
    self.currentIndex = index;
    self.type = type;
    if(![self.modelsDict objectForKey:type])
    {
        [self reloadData];
    } else {
        return [self.modelsDict objectForKey:type].models;
    }
    return nil;
}
- (void)reloadData
{
    [self.modelsDict removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.type;
    param[@"market"] = @"btc_usdt";
    param[@"size"] = @"200";
    [NetWorking requestWithApi:@"http://api.bitkk.com/data/v1/kline" param:param thenSuccess:^(NSDictionary *responseObject) {
        //NSLog(@"===:%@",responseObject);
        Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:responseObject[@"data"]];
        self.groupModel = groupModel;
        [self.modelsDict setObject:groupModel forKey:self.type];
        
        [self.stockChartView reloadData];
    } fail:^{
        
    }];
}
- (Y_StockChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [[Y_StockChartView alloc] initWithFrame:CGRectMake(15, 200, ScreenW-30, ScreenH-210)];
        _stockChartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"15分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"60分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"日线" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"周线" type:Y_StockChartcenterViewTypeKline],
                                       ];
        self.stockChartView.backgroundColor = RGB(28, 35, 64);        _stockChartView.dataSource = self;
        [self.view addSubview:_stockChartView];
    }
    return _stockChartView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)dismissView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
