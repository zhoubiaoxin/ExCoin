//
//  TardeViewController.m
//  ExCoin
//
//  Created by 周飙 on 2018/9/14.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "TardeViewController.h"
#import "CLCustomSwitch.h"
#import "TardeViewCell.h"
#import "MarketModel.h"
#import "MarketDetailViewController.h"
#import "WalletModel.h"
#import "MoneyModel.h"
#import "PriceModel.h"

@interface TardeViewController ()<CLCustomSwitchDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greenBgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redBgH;
@property (weak, nonatomic) IBOutlet UIView *greenLine;
@property (weak, nonatomic) IBOutlet UIView *redLine;
@property (weak, nonatomic) IBOutlet UIButton *greebBtn;
@property (weak, nonatomic) IBOutlet UIButton *redBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (weak, nonatomic) IBOutlet UILabel *bili;
@property (weak, nonatomic) IBOutlet UILabel *numShowLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frameCenter;
@property (weak, nonatomic) IBOutlet UISlider *silder;
@property (weak, nonatomic) IBOutlet UIView *tableViewHeadView;

@property (strong, nonatomic) CLCustomSwitch *priceSwitch;
@property (strong, nonatomic) UIImageView *image1;
@property (strong, nonatomic) UIImageView *image2;
@property (strong, nonatomic) UIImageView *image3;
@property (strong, nonatomic) UIImageView *image4;
@property (strong, nonatomic) UIImageView *image5;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *sybLab;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *listBtn;
@property (weak, nonatomic) IBOutlet UILabel *useLab;
@property (weak, nonatomic) IBOutlet UILabel *buyNameLab;
@property (weak, nonatomic) IBOutlet UITextField *buyText;
@property (weak, nonatomic) IBOutlet UITextField *numText;
@property (weak, nonatomic) IBOutlet UILabel *cnyAboutLab;
@property (weak, nonatomic) IBOutlet UILabel *aboutLab;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *zhangfuImg;
@property (weak, nonatomic) IBOutlet UILabel *cnyLab;

@property (strong, nonatomic) MarketModel *marketModel;
@end

@implementation TardeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHex:@"#151935"];
    self.navigationController.navigationBarHidden = YES;
    [self createBaseUI];
    [self createUI];
}
-(void)createBaseUI{
    self.redBgH.constant = 0;
    self.priceSwitch = [[CLCustomSwitch alloc] initWithFrame:CGRectMake(ScreenW-115, 61, 100, 40)];
    // 开关背景
    self.priceSwitch.bgImageView.image = [UIImage imageNamed:@"icon_switchBg"];
    // 开关滑块
    self.priceSwitch.switchImageView.image = [UIImage imageNamed:@"icon_switchSe"];
    self.priceSwitch.delegate = self;
    self.priceSwitch.on = NO ; // 初始状态为开
    [self.tableViewHeadView addSubview:self.priceSwitch];
    
    [self.numberText setValue:[UIColor colorWithHex:@"#646c8c"] forKeyPath:@"_placeholderLabel.textColor"];
    self.numberText.delegate = self;
    
    //初始化
    self.silder.frame = CGRectMake(ScreenW/2.0+15, 310, ScreenW/2.0+15, 10);
    self.frameCenter.constant = -5;
    /// 也可设置为图片
    [self.silder setMinimumTrackImage:[UIImage imageNamed:@"icon_min"] forState:UIControlStateNormal];
    [self.silder setMaximumTrackImage:[UIImage imageNamed:@"icon_max"] forState:UIControlStateNormal];
    //设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
    [self.silder setThumbImage:[UIImage imageNamed:@"icon_schedule"] forState:UIControlStateNormal];
    // 针对值变化添加响应方法
    [self.silder addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tag = 1000;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view bringSubviewToFront:self.leftView];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBtn)];
    [self.leftView addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"nameStrLab" object:nil];
    
    [self.buyText setValue:[UIColor colorWithHex:@"#ADB7EA"] forKeyPath:@"_placeholderLabel.textColor"];
    self.buyText.textColor = [UIColor colorWithHex:@"#ADB7EA"];
    self.numText.textColor = [UIColor colorWithHex:@"#ADB7EA"];
}

-(void)receiveNotification:(NSNotification *)infoNotification {
    NSDictionary *dic = [infoNotification object];
    NSString *str = [dic objectForKey:@"info"];
    self.nameStrLab = str;
    [self createUI];
}
-(void)createUI{
    if(self.nameStrLab.length == 0){
        self.nameStrLab = @"BTCBCH";
    }
    MarketModel * marketModel;
    NSArray * arr = [MarketModel objectsWhere:[NSString stringWithFormat:@"where tickername = '%@'",self.nameStrLab] arguments:nil];
    if (arr.count>0) {
        marketModel = arr[0];
    }
    self.buyText.text = marketModel.last;
    self.priceLab.text = marketModel.last;
    
    NSString *last3 = [self.nameStrLab substringFromIndex:self.nameStrLab.length-3];
    if ([last3 isEqualToString:@"SDT"]) {
        self.sybLab.text = @"/USDT";
        NSString *first = [self.nameStrLab substringToIndex:self.nameStrLab.length-4];
        self.nameLab.text = first;
        NSArray * moneyArr = [WalletModel objectsWhere:[NSString stringWithFormat:@"where tickername ='%@'",@"USDT"] arguments:nil];
        if (moneyArr.count > 0) {
            WalletModel *walletModel = moneyArr[0];
            self.useLab.text = [NSString stringWithFormat:@"%.4f %@",walletModel.available,@"USDT"];
        }
        NSArray * priceModelArr = [PriceModel objectsWhere:[NSString stringWithFormat:@"where tickername ='%@'",first] arguments:nil];
        if (priceModelArr.count>0) {
            PriceModel * priceModel = priceModelArr[0];
            self.cnyAboutLab.text = [NSString stringWithFormat:@"≈%@ CNY",priceModel.price];
            self.cnyLab.text = [NSString stringWithFormat:@"≈%@ CNY",priceModel.price];
        }
    }else{
        self.sybLab.text = [NSString stringWithFormat:@"/%@",last3];
        NSString *first = [self.nameStrLab substringToIndex:self.nameStrLab.length-3];
        self.nameLab.text = first;
        NSArray * moneyArr = [WalletModel objectsWhere:[NSString stringWithFormat:@"where tickername ='%@'",last3] arguments:nil];
        if (moneyArr.count > 0) {
            WalletModel *walletModel = moneyArr[0];
            self.useLab.text = [NSString stringWithFormat:@"%.4f %@",walletModel.available,last3];
        }
        NSArray * priceModelArr = [PriceModel objectsWhere:[NSString stringWithFormat:@"where tickername ='%@'",first] arguments:nil];
        if (priceModelArr.count>0) {
            PriceModel * priceModel = priceModelArr[0];
            self.cnyAboutLab.text = [NSString stringWithFormat:@"≈%@ CNY",priceModel.price];
            self.cnyLab.text = [NSString stringWithFormat:@"≈%@ CNY",priceModel.price];
        }
    }
    
    NSArray * arr1 = [MarketModel objectsWhere:[NSString stringWithFormat:@"WHERE tickername = '%@'",self.nameStrLab] arguments:nil];
    if (arr1.count != 0) {
        self.marketModel = arr1[0];
    }
    
    if ([self.marketModel.store isEqualToString:@"0"]) {
        [self.storeBtn setBackgroundImage:[UIImage imageNamed:@"icon_unstore"] forState:UIControlStateNormal];
    }else{
        [self.storeBtn setBackgroundImage:[UIImage imageNamed:@"icon_store"] forState:UIControlStateNormal];
    }
    
    if ([marketModel.last doubleValue]>[marketModel.open doubleValue]) {
        self.priceLab.textColor = [UIColor colorWithHex:@"#0ab9bd"];
        self.cnyLab.textColor = [UIColor colorWithHex:@"#0ab9bd"];
        self.zhangfuImg.image = [UIImage imageNamed:@"icon_tradeUp"];
    }else{
        self.priceLab.textColor = [UIColor colorWithHex:@"#f13d68"];
        self.cnyLab.textColor = [UIColor colorWithHex:@"#f13d68"];
        self.zhangfuImg.image = [UIImage imageNamed:@"icon_tradeDown"];
    }
}

-(void)hiddenBtn{
    [UIView animateWithDuration:0.5 animations:^{
        self.viewWidth.constant = 0;
        self.tableViewWidth.constant = 0;
        [self.view layoutIfNeeded];
    }];
}
-(void)sliderValueChanged:(UISlider*)sender{
    self.frameCenter.constant = (ScreenW/2.0-15)*sender.value/100-5;
    self.bili.text = [NSString stringWithFormat:@"%d%s",(int)sender.value,"%"];
}

- (IBAction)changeState:(id)sender {
    self.greenBgH.constant = 0;
    self.redBgH.constant = 0;
    self.greenLine.hidden = YES;
    self.redLine.hidden = YES;
    self.greebBtn.selected = NO;
    self.redBtn.selected = NO;
    
    UIButton * btn = (UIButton*)sender;
    btn.selected = YES;
    if (btn.tag == 200) {
        [UIView animateWithDuration:0.5 animations:^{
            self.greenBgH.constant = 42.5;
            [self.view layoutIfNeeded];
        }];
        self.greenLine.hidden = NO;
        //买入
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.redBgH.constant = 42.5;
            [self.view layoutIfNeeded];
        }];
        self.redLine.hidden = NO;
        //卖出
        
        
        
    }
}
//收藏
- (IBAction)storeBtnClick:(id)sender {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([self.marketModel.store isEqualToString:@"0"]) {
        param[@"store"] = @"1";
    }else{
        param[@"store"] = @"0";
    }
    [MarketModel updateObjectsSet:param Where:[NSString stringWithFormat:@"WHERE tickername = '%@'",self.nameStrLab] arguments:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
    [self createUI];
}
//详情
- (IBAction)detailBtnClick:(id)sender {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Market" bundle:nil];
    MarketDetailViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MarketDetailViewController"];
    secondViewController.name = self.nameStrLab;
    [self.navigationController pushViewController:secondViewController animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    [self.numberText resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)customSwitchStatusWithOn:(CLCustomSwitch *)custonSwitch
{
    NSLog(@"开启");
}

- (void)customSwitchStatusWithOff:(CLCustomSwitch *)custonSwitch
{
    NSLog(@"关闭");
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        return 10;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SuperviseList * model;
//    if (indexPath.row<_dateArr.count) {
//        model = _dateArr[indexPath.row];
//    }
    TardeViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"TardeViewCell" forIndexPath:indexPath];
//    [cell setupCellWithSupervise:model];
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
- (IBAction)leftMeunBtn:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.tableViewWidth.constant = 265;
        self.viewWidth.constant = ScreenW;
        [self.view layoutIfNeeded];
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
