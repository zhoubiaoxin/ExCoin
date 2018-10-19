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
#import "MarketDetailViewController.h"
#import "MarketModel.h"
#import "WalletModel.h"
#import "MoneyModel.h"
#import "PriceModel.h"
#import "MarketCell.h"


@interface MarketViewController ()<UIScrollViewDelegate,scrollMenuDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)  NSArray * controllerNameArr;
@property(nonatomic,strong)NSArray * dataArr;
@property(nonatomic,assign)BOOL hasPaixu;
@property(nonatomic,strong)NSString * selectStr;
@property(nonatomic,strong)NSString * selectStr2;
@property(nonatomic,strong)NSTimer * timer;
@end

@implementation MarketViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self createJBBZ];
            NSLog(@"NSTimer");
        }];
    } else {
        // Fallback on earlier versions
    }
}
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [self.timer invalidate];
//}

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
    [self.searchText setValue:[UIColor colorWithHex:@"#ADB7EA"] forKeyPath:@"_placeholderLabel.textColor"];
    self.searchText.delegate = self;
    [self.searchText addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];

    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#151935"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MarketCell" bundle:nil] forCellReuseIdentifier:@"MarketCell"];

    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectStr = @"BCH";
    [self createDataList:self.selectStr];
    
}
-(void)receiveNotification:(NSNotification *)infoNotification {
    NSDictionary *dic = [infoNotification object];
    NSString *str = [dic objectForKey:@"info"];
    [self marketDetail:str];
}
-(void)createJBBZ{
    [NetWorking requestWithApi2:@"https://otc.coinex.com/res/system/market/price" param:nil thenSuccess:^(NSDictionary *responseObject) {
        //NSLog(@"===:%@",responseObject);
        NSDictionary * dic = responseObject[@"data"];
        NSDictionary * dict = dic[@"CNY"];
        for (NSString * key in dict) {
            MoneyModel * moneyModel = [[MoneyModel alloc] initWithtickername:key price:dict[key]];
            [moneyModel save];
        }

        [self createData];
    } fail:^{
        
    }];
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
            double availableStr = [dicList[@"available"] doubleValue];
            double frozenStr = [dicList[@"frozen"] doubleValue];
            double allNum = [dicList[@"available"] doubleValue]+[dicList[@"frozen"] doubleValue];
            
            NSArray * firstArr = [PriceModel objectsWhere:[NSString stringWithFormat:@"WHERE tickername = '%@'",key] arguments:nil];
            double allstr = 0.0;
            if (firstArr.count > 0) {
                PriceModel *priceModel = firstArr[0];
                allstr = [priceModel.price doubleValue]* allNum;
            }
            
            if(arr1.count == 0){
                WalletModel * walletModel = [[WalletModel alloc] initWithtickername:key available:availableStr frozen:frozenStr allNum:allstr];
                [walletModel save];
            }else{
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"available"] = [NSString stringWithFormat:@"%.8f",availableStr];
                param[@"frozen"] = [NSString stringWithFormat:@"%.8f",frozenStr];
                param[@"allNum"] = [NSString stringWithFormat:@"%.8f",allstr];
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
            NSString * str1;
            if ([dicList[@"open"] doubleValue] != 0) {
                str1 = [NSString stringWithFormat:@"%.4f",([dicList[@"last"] doubleValue]-[dicList[@"open"] doubleValue])/[dicList[@"open"] doubleValue]+1];
            }else{
                str1 = @"0";
            }
            
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
                [self createDataList:self.selectStr];
            }
        }
    } fail:^{
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    [self.searchText resignFirstResponder];
//    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"sousu"];
    self.selectStr2 = textField.text;
    [self createDataList:self.selectStr];
    return YES;
}

- (void)textChange{
    //变化后的字符串
    NSLog(@"-----------------%@",_searchText.text);
    self.selectStr2 = _searchText.text;
    [self createDataList:self.selectStr];
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

- (IBAction)btnClick:(id)sender {
    for (int i = 0; i<6; i++) {
        UIView *view = (UIView *)[self.view viewWithTag:i+200];
        view.hidden = YES;
        UIButton *btn = (UIButton *)[self.view viewWithTag:i+100];
        btn.selected = NO;
    }
    UIButton * btn1 = (UIButton*)sender;
    UIView *view = (UIView *)[self.view viewWithTag:btn1.tag+100];
    view.hidden = NO;
    btn1.selected = YES;
    self.selectStr = [btn1 currentTitle];
    [self createDataList:self.selectStr];
}

-(void)createDataList:(NSString *)selectStr{
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"paixu"];
    NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"paixustate"];
    NSString * str2 = @"";
    if (str.length !=0&&str1.length !=0) {
        if ([str1 isEqualToString:@"up"]) {
            self.hasPaixu = YES;
        }else{
            self.hasPaixu = NO;
        }
        str2 = [NSString stringWithFormat:@" ORDER BY %@ DESC",str];
    }else{
        self.hasPaixu = YES;
        str2 = @" ORDER BY allstr DESC";
    }
    NSString * str3;
    if ([selectStr isEqualToString:@"自选"]) {
        str3 = @"WHERE store = '1'";
    }else{
        str3 = [NSString stringWithFormat:@"WHERE tickername like '%@%@'",@"%",selectStr];
    }
    if (self.selectStr2.length !=0){
        str3 = [NSString stringWithFormat:@" WHERE tickername like '%@%@%@'",self.selectStr2,@"%",selectStr];
    }
    
    NSArray * arr = [MarketModel objectsWhere:[NSString stringWithFormat:@"%@%@",str3,str2] arguments:nil];
    _dataArr = arr;
    if(arr.count>0){
        [self.tableView reloadData];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketModel * model;
    if (self.hasPaixu) {
        model = _dataArr[indexPath.row];
    }else{
        model = _dataArr[_dataArr.count-1- indexPath.row];
    }
    
    MarketCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MarketCell"];
    [cell setCellModel:model];
    cell.contentView.backgroundColor = [UIColor clearColor];
    if (indexPath.row%2 ==0) {
        cell.backgroundColor = [UIColor colorWithHex:@"#151935"];
    }else{
        cell.backgroundColor = [UIColor colorWithHex:@"#1b1e3d"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.storeBtn.tag = 100+indexPath.row;
    [cell.storeBtn addTarget:self action:@selector(storeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)storeBtnClick:(UIButton*)btn{
    MarketModel * model;
    if (self.hasPaixu) {
        model = _dataArr[btn.tag-100];
    }else{
        model = _dataArr[_dataArr.count-1- btn.tag+100];
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([model.store isEqualToString:@"0"]) {
        param[@"store"] = @"1";
    }else{
        param[@"store"] = @"0";
    }
    [MarketModel updateObjectsSet:param Where:[NSString stringWithFormat:@"WHERE tickername = '%@'",model.tickername] arguments:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
    [self createData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketModel * model;
    if (self.hasPaixu) {
        model = _dataArr[indexPath.row];
    }else{
        model = _dataArr[_dataArr.count-1- indexPath.row];
    }
//    NSDictionary *dataDic = [NSDictionary dictionaryWithObject:model.tickername forKey:@"info"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"marketDetail" object:dataDic];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Market" bundle:nil];
    MarketDetailViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MarketDetailViewController"];
    vc.name = model.tickername;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
