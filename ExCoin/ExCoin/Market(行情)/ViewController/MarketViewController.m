//
//  MarketViewController.m
//  ExCoin
//
//  Created by 周飙 on 2018/9/14.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "MarketViewController.h"
#import "XQQScrollerMenuView.h"
#import "XQQScrollBtn.h"
#import "MarketListViewController1.h"
#import "MarketListViewController2.h"
#import "MarketListViewController3.h"
#import "MarketListViewController4.h"
#import "MarketListViewController5.h"
#import "MarketListViewController6.h"
#import "MarketDetailViewController.h"
#import "MarketModel.h"
#import "WalletModel.h"


@interface MarketViewController ()<UIScrollViewDelegate,scrollMenuDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchText;
/**下方的scrollView*/
@property(nonatomic, strong)  UIScrollView * scrollView;
/**菜单的View*/
@property(nonatomic, strong)  XQQScrollerMenuView * menuView;
@property (weak, nonatomic) IBOutlet UIView *meunbg;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIImageView *menuUp;
@property (weak, nonatomic) IBOutlet UIImageView *menuDown;

@property (assign, nonatomic) int selectNum;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property(nonatomic, strong)  NSArray * controllerNameArr;
@end

@implementation MarketViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHex:@"#151935"];
    self.navigationController.navigationBarHidden = YES;
    [self createUI];
        
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"paixu"];
    NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"paixustate"];
    if (str.length != 0) {
        if ([str isEqualToString:@"allStr"]) {
            [self.menuBtn setTitle:@"成交额" forState:UIControlStateNormal];
        }else if([str isEqualToString:@"zhangfu"]){
            [self.menuBtn setTitle:@"涨幅" forState:UIControlStateNormal];
        }else if([str isEqualToString:@"last"]){
            [self.menuBtn setTitle:@"价格" forState:UIControlStateNormal];
        }else if([str isEqualToString:@"tickername"]){
            [self.menuBtn setTitle:@"币种" forState:UIControlStateNormal];
        }
    }
    if(str1.length != 0){
        if([str1 isEqualToString:@"up"]){
            self.menuUp.image = [UIImage imageNamed:@"icon_up_un"];
            self.menuDown.image = [UIImage imageNamed:@"icon_down_se"];
        }else{
            self.menuUp.image = [UIImage imageNamed:@"icon_up_se"];
            self.menuDown.image = [UIImage imageNamed:@"icon_down_un"];
        }
    }
}
- (void)createUI{
    self.navigationItem.title = @"滚动菜单";
    NSArray * titleArr = @[@"自选",@"BCH",@"BTC",@"ETH",@"CET",@"USDT"];
    self.controllerNameArr = @[@"MarketListViewController1",@"MarketListViewController2",@"MarketListViewController3",@"MarketListViewController4",@"MarketListViewController5",@"MarketListViewController6"];
    _menuView  = [[XQQScrollerMenuView alloc]initWithFrame:CGRectMake(15, 84, ScreenW-30, 44)];
    _menuView.titleArr = titleArr;
    _menuView.scrollDelegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_menuView];
    
    [self.searchText setValue:[UIColor colorWithHex:@"#ADB7EA"] forKeyPath:@"_placeholderLabel.textColor"];
    self.searchText.delegate = self;
    
    //控制器的滚动视图
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_menuView.frame), ScreenW, ScreenH - CGRectGetMaxY(_menuView.frame)-1)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    //添加controllers
//    NSArray * chelidControlls = [_menuView addChildrenControllersWithArr:controllerNameArr AndSuperController:self];
    [_menuView addChildrenControllersWithArr:self.controllerNameArr AndSuperController:self];
    //给底部的滚动视图添加View  这个方法 会一次性把所有的控制器都初始化了
//    [_menuView addSubViewToScrollView:_scrollView controllerArr:chelidControlls];
    /**根据下标添加控制器的View    刚开始为第一项*/
    [_menuView addSubViewToScrollViewWithIndex:0 superView:_scrollView];
    [_menuView changeBtnStatesWithBtnIndex:1];
    [self scrollMenuDidPressBtn:[[XQQScrollBtn alloc] init] index:1];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBtn)];
    [self.meunbg addGestureRecognizer:tapGesture];
    
    self.selectNum = 1;
    NSString * selectNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectNum"];
    if(selectNumStr.length != 0){
        self.selectNum = [selectNumStr intValue];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"marketDetail" object:nil];
    [self createData];
    
}
-(void)receiveNotification:(NSNotification *)infoNotification {
    NSDictionary *dic = [infoNotification object];
    NSString *str = [dic objectForKey:@"info"];
    [self marketDetail:str];
}

-(void)createData{
    [MarketModel deleteObjectsWhere:@"WHERE store = '1' and store = '0'" arguments:nil];
    [NetWorking requestWithApi:@"https://api.coinex.com/v1/market/list" param:nil thenSuccess:^(NSDictionary *responseObject) {
        //NSLog(@"===:%@",responseObject);
        [self createAll:responseObject[@"data"]];
    } fail:^{
        
    }];
    
    //请求钱包
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"access_id"] = @"4F76C19E3F57486280715356CA0FDE93";
    NSString * timeStr = [TimeUse currentTimeStr];
    param[@"tonce"] = timeStr;
    [NetWorking requestWithApi2:@"https://api.coinex.com/v1/balance/info" param:param thenSuccess:^(NSDictionary *responseObject) {
        //NSLog(@"===:%@",responseObject);
        NSDictionary * dic = responseObject[@"data"];
        for (NSString * key in dic) {
//            NSLog(@"%@",key);
            //[dic objectForKey:key];
            NSDictionary * dicList = dic[key];
            NSArray * arr1 = [WalletModel objectsWhere:[NSString stringWithFormat:@"WHERE tickername = '%@'",key] arguments:nil];
            NSString * allNum= [NSString stringWithFormat:@"%.8f",[dicList[@"available"] doubleValue]+[dicList[@"frozen"] doubleValue]];
            if(arr1.count == 0){
                WalletModel * walletModel = [[WalletModel alloc] initWithtickername:key available:dicList[@"available"] frozen:dicList[@"frozen"] allNum:allNum];
                [walletModel save];
            }else{
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"available"] = dicList[@"available"];
                param[@"frozen"] = dicList[@"frozen"];
                param[@"allNum"] = allNum;
                [WalletModel updateObjectsSet:param Where:[NSString stringWithFormat:@"WHERE tickername = '%@'",key] arguments:nil];
            }
        }
    } fail:^{
        
    }];
}

-(void)createAll:(NSArray *)arr{
    [NetWorking requestWithApi:@"https://api.coinex.com/v1/market/ticker/all" param:nil thenSuccess:^(NSDictionary *responseObject) {
        //NSLog(@"===:%@",responseObject);
        NSDictionary * dic = responseObject[@"data"];
        NSDictionary * dict = dic[@"ticker"];
        for (int i = 0; i<arr.count; i++) {
            NSString *str = arr[i];
            NSDictionary * dicList = dict[str];
            NSArray * arr1 = [MarketModel objectsWhere:[NSString stringWithFormat:@"WHERE tickername = '%@'",str] arguments:nil];
            NSString * str1 = [NSString stringWithFormat:@"%.4f",([dicList[@"last"] doubleValue]-[dicList[@"open"] doubleValue])/[dicList[@"open"] doubleValue]+1];
            
            NSString * buyStr= [NSString stringWithFormat:@"%.8f",[dicList[@"buy"] doubleValue]];
            NSString * buy_amountStr= [NSString stringWithFormat:@"%.1f",[dicList[@"buy_amount"] doubleValue]];
            NSString * openStr= [NSString stringWithFormat:@"%.8f",[dicList[@"open"] doubleValue]];
            NSString * highStr= [NSString stringWithFormat:@"%.8f",[dicList[@"high"] doubleValue]];
            NSString * lastStr= [NSString stringWithFormat:@"%.8f",[dicList[@"last"] doubleValue]];
            NSString * lowStr= [NSString stringWithFormat:@"%.8f",[dicList[@"low"] doubleValue]];
            NSString * sellStr= [NSString stringWithFormat:@"%.8f",[dicList[@"sell"] doubleValue]];
            NSString * sell_amountStr= [NSString stringWithFormat:@"%.1f",[dicList[@"sell_amount"] doubleValue]];
            NSString * volStr= [NSString stringWithFormat:@"%.1f",[dicList[@"vol"] doubleValue]];
            float allStr = [dicList[@"last"] doubleValue]*[dicList[@"vol"] doubleValue];
//            NSLog(@"%f",allStr);
            if (arr1.count>0) {
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"date"] = dic[@"date"];
                param[@"buy"] = buyStr;
                param[@"buy_amount"] = buy_amountStr;
                param[@"open"] = openStr;
                param[@"high"] = highStr;
                param[@"last"] = lastStr;
                param[@"low"] = lowStr;
                param[@"sell"] = sellStr;
                param[@"sell_amount"] = sell_amountStr;
                param[@"vol"] = volStr;
                param[@"zhangfu"] = str1;
                param[@"allStr"] = [NSString stringWithFormat:@"%.2f",allStr];
                [MarketModel updateObjectsSet:param Where:[NSString stringWithFormat:@"WHERE tickername = '%@'",str] arguments:nil];
            }else{
                MarketModel * markertModel = [[MarketModel alloc] initWithtickername:str date:dic[@"date"] buy:buyStr buy_amount:buy_amountStr open:openStr high:highStr last:lastStr low:lowStr sell:sellStr sell_amount:sell_amountStr vol:volStr store:@"0" zhangfu:str1 allStr:allStr];
                [markertModel save];
            }
            if (i == (arr.count-1)) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
            }
        }
    } fail:^{
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    [self.searchText resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"sousu"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
    return YES;
}
-(void)marketDetail:(NSString*)str{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Market" bundle:nil];
    MarketDetailViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MarketDetailViewController"];
    vc.name = str;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - scrollMenuDelegate
- (void)scrollMenuDidPressBtn:(XQQScrollBtn*)button index:(NSInteger)index{
    //切换当前控制器滚动视图的偏移量
    [_menuView changeScrollViewContentOffsetWithIndex:index scrollView:_scrollView];
    //一个一个添加控制器的View 只有切换到这个页面才添加这个控制器的View
    [_menuView addSubViewToScrollViewWithIndex:index superView:_scrollView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //计算偏移量
    NSInteger x = scrollView.contentOffset.x / ScreenW;
    //一个一个添加控制器的View 只有切换到这个页面才添加这个控制器的View
    [_menuView addSubViewToScrollViewWithIndex:x superView:_scrollView];
    //上方按钮的偏移量
    _menuView.index = x;
    //改变顶部按钮的颜色
    [_menuView changeBtnStatesWithBtnIndex:x];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuBtn:(id)sender {
    self.meunbg.hidden = !self.meunbg.hidden;
    [self.view bringSubviewToFront:self.meunbg];
    NSArray * selectBtnArr = @[_btn1,_btn2,_btn3,_btn4,_btn5,_btn6,_btn7,_btn8];
    for (int i = 0; i<selectBtnArr.count; i++) {
        UIButton * btn = selectBtnArr[i];
        if (i==self.selectNum) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.selectNum] forKey:@"selectNum"];
}
-(void)hiddenBtn{
    self.meunbg.hidden = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)changeSe:(id)sender {
    UIButton * btn = (UIButton*)sender;
    //NSLog(@"%ld",(long)btn.tag);
    self.selectNum = (int)btn.tag - 100;
    if (btn.tag == 100||btn.tag == 101) {
        [self.menuBtn setTitle:@"成交额" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"allStr" forKey:@"paixu"];
    }else if (btn.tag == 102||btn.tag == 103){
        [self.menuBtn setTitle:@"涨幅" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"zhangfu" forKey:@"paixu"];
    }else if (btn.tag == 104||btn.tag == 105){
        [self.menuBtn setTitle:@"价格" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"last" forKey:@"paixu"];
    }else if (btn.tag == 106||btn.tag == 107){
        [self.menuBtn setTitle:@"币种" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"tickername" forKey:@"paixu"];
    }
    if (btn.tag%2 == 0) {
        self.menuUp.image = [UIImage imageNamed:@"icon_up_se"];
        self.menuDown.image = [UIImage imageNamed:@"icon_down_un"];
        [[NSUserDefaults standardUserDefaults] setObject:@"down" forKey:@"paixustate"];
    }else{
        self.menuUp.image = [UIImage imageNamed:@"icon_up_un"];
        self.menuDown.image = [UIImage imageNamed:@"icon_down_se"];
        [[NSUserDefaults standardUserDefaults] setObject:@"up" forKey:@"paixustate"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
    self.meunbg.hidden = YES;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
