//
//  WalletViewController.m
//  ExCoin
//
//  Created by 周飙 on 2018/9/14.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "WalletViewController.h"
#import "WalletModel.h"
#import "WalletCell.h"
#import "CustomAlertView.h"
#import "PriceModel.h"
#import "MoneyModel.h"

@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *huilvLab;
@property (weak, nonatomic) IBOutlet UILabel *cnyLab;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *saixuanBtn;
@property (strong, nonatomic) NSArray *languages;
@property (nonatomic,strong)NSArray * dataArr;
@property (nonatomic,assign)NSInteger selectNum;
@property(nonatomic,strong)NSTimer * timer;
@end

@implementation WalletViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self createData];
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
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = RGB(28, 35, 64);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = RGB(28, 35, 64);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.searchText setValue:[UIColor colorWithHex:@"#ADB7EA"] forKeyPath:@"_placeholderLabel.textColor"];
    self.searchText.delegate = self;
    [self.searchText addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];

    
    self.languages = @[@"BCH",@"BTC",@"ETH",@"CET",@"USDT"];
    
    self.selectNum = 0;
    [self qhqb:self.selectNum];
}
-(void)qhqb:(NSInteger)num{
    NSArray * arr = [WalletModel objectsWhere:[NSString stringWithFormat:@"where tickername = '%@'",self.languages[num]] arguments:nil];
    if (arr.count != 0) {
        WalletModel * model = arr[0];
        self.cnyLab.text = [NSString stringWithFormat:@"%.4f",model.allNum];
    }

    NSArray * firstArr = [PriceModel objectsWhere:[NSString stringWithFormat:@"WHERE tickername = '%@'",self.languages[num]] arguments:nil];
    if (firstArr.count > 0) {
        PriceModel *priceModel = firstArr[0];
        self.huilvLab.text = [NSString stringWithFormat:@"%@/CNY=%.2f",self.languages[num],[priceModel.price floatValue]];
    }
    NSArray * secondArr = [MoneyModel objectsWhere:[NSString stringWithFormat:@"WHERE tickername = '%@'",self.languages[num]] arguments:nil];
    if (secondArr.count > 0) {
        MoneyModel *moneyModel = secondArr[0];
        self.huilvLab.text = [NSString stringWithFormat:@"%@/CNY=%.2f",self.languages[num],[moneyModel.price floatValue]];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    [self.searchText resignFirstResponder];
    [self createData];
    return YES;
}
- (void)textChange{
    //变化后的字符串
    NSLog(@"-----------------%@",_searchText.text);
    [self createData];
}

-(void)createData{
    if (_searchText.text) {
        NSArray * arr = [WalletModel objectsWhere:[NSString stringWithFormat:@"where tickername like '%@%@' ORDER BY allNum DESC",_searchText.text,@"%"] arguments:nil];
        _dataArr = arr;
        [self.tableView reloadData];
    }else{
        NSArray * arr = [WalletModel objectsWhere:@"ORDER BY allNum DESC" arguments:nil];
        _dataArr = arr;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletModel * model = _dataArr[indexPath.row];
    WalletCell *cell = [tableView dequeueReusableCellWithIdentifier: @"WalletCell" forIndexPath:indexPath];
    [cell setCellModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)jiluBtnClick:(id)sender {
    
}
- (IBAction)zjlsBtnClick:(id)sender {
    
}
- (IBAction)changeBiBtnClick:(id)sender {
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithListData:self.languages andSelect:self.selectNum];
    alertView.tapDoneAction = ^(NSInteger tag){
        if (tag==999) {
            NSLog(@"999:你没有选择啊");
        }else{
            NSLog(@"你选中的数据在数组中下标-->Array[index=%ld]",tag);
            [alertView removeFromSuperview];
            self.selectNum = tag;
            [self qhqb:self.selectNum];
        }
        
    };
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:alertView];
}
- (IBAction)hiddenBtnClick:(id)sender {
    self.saixuanBtn.selected = !self.saixuanBtn.selected;
    if (self.saixuanBtn.selected) {
        NSArray * arr = [WalletModel objectsWhere:@"where allNum > '1' ORDER BY allNum DESC" arguments:nil];
        _dataArr = arr;
    }else{
        NSArray * arr = [WalletModel objectsWhere:@"ORDER BY allNum DESC" arguments:nil];
        _dataArr = arr;
    }
    [self.tableView reloadData];
}


@end
