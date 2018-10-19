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
#import "FSSegmentTitleView.h"
#import "TradeCell.h"

@interface TardeViewController ()<CLCustomSwitchDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,FSSegmentTitleViewDelegate>
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
@property (weak, nonatomic) IBOutlet UILabel *numNameLab;
@property (weak, nonatomic) IBOutlet UITextField *numText;
@property (weak, nonatomic) IBOutlet UILabel *cnyAboutLab;
@property (weak, nonatomic) IBOutlet UILabel *aboutName;
@property (weak, nonatomic) IBOutlet UILabel *aboutLab;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *zhangfuImg;
@property (weak, nonatomic) IBOutlet UILabel *cnyLab;
@property (weak, nonatomic) IBOutlet UILabel *shijiaLab;

@property (strong, nonatomic) MarketModel *marketModel;
@property (strong, nonatomic) UILabel *shijiaStr;
@property (strong, nonatomic) UILabel *xianjianStr;

@property (assign, nonatomic) Boolean buyOrSell;
@property (assign, nonatomic) Boolean kaiguan;

@property(nonatomic,strong)NSTimer * timer;
@property (strong, nonatomic) NSString *merge;
@property (strong, nonatomic) NSArray *buyArr;
@property (strong, nonatomic) NSArray *sellArr;
@property (weak, nonatomic) IBOutlet UIView *changeMeView;
@property (weak, nonatomic) IBOutlet UIButton *changeMeBtn;


@property (weak, nonatomic) IBOutlet UIView *leftHeadView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *hiddenBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn2;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn3;
@property (strong, nonatomic) CLCustomSwitch *switchBtn;
@property (strong, nonatomic) UILabel *zhangfuStr;
@property (strong, nonatomic) UILabel *chengjiaoeStr;
@property (strong, nonatomic) FSSegmentTitleView *changeBZView;
@property(nonatomic,assign)BOOL hasPaixu;
@property (strong, nonatomic) NSString *changeBZStr;
@property(nonatomic,strong)NSString * selectStr2;
@property(nonatomic,strong)NSArray * dataArr;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@end

@implementation TardeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
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
    self.buyOrSell = YES;
    self.kaiguan = YES;
    self.merge = @"0.00000001";
    self.changeBZStr = @"BCH";
    self.hasPaixu = YES;
    
    
    [self createUI];
    [self createBaseUI];
}
-(void)createBaseUI{
    self.redBgH.constant = 0;
    
    self.priceSwitch = [[CLCustomSwitch alloc] initWithFrame:CGRectMake(ScreenW-115, 61, 100, 40)];
    // 开关背景
    self.priceSwitch.bgImageView.image = [UIImage imageNamed:@"icon_switchBg"];
    // 开关滑块
    self.priceSwitch.switchImageView.image = [UIImage imageNamed:@"icon_switchSe"];
    self.priceSwitch.delegate = self;
    self.priceSwitch.on = YES ; // 初始状态为开
    self.priceSwitch.tag = 30;
    [self.tableViewHeadView addSubview:self.priceSwitch];
    _shijiaStr = [[UILabel alloc] initWithFrame:CGRectMake(0,-5 , 50, 40)];
    _shijiaStr.textAlignment = NSTextAlignmentCenter;
    _shijiaStr.text = @"市价";
    _shijiaStr.textColor = [UIColor whiteColor];
    [self.priceSwitch addSubview:_shijiaStr];
    
    _xianjianStr = [[UILabel alloc] initWithFrame:CGRectMake(50,-5 , 50, 40)];
    _xianjianStr.textAlignment = NSTextAlignmentCenter;
    _xianjianStr.text = @"限价";
    _xianjianStr.textColor = [UIColor colorWithHex:@"#ADB7EA"];
    [self.priceSwitch addSubview:_xianjianStr];
    
    self.switchBtn = [[CLCustomSwitch alloc] initWithFrame:CGRectMake(15, 40, 100, 30)];
    self.switchBtn.bgImageView.image = [UIImage imageNamed:@"icon_switchBg"];
    self.switchBtn.switchImageView.image = [UIImage imageNamed:@"icon_switchSe"];
    self.switchBtn.delegate = self;
    self.switchBtn.tag = 31;
    self.switchBtn.on = YES ; // 初始状态为开
    [self.leftHeadView addSubview:self.switchBtn];
    _zhangfuStr = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 50, 30)];
    _zhangfuStr.textAlignment = NSTextAlignmentCenter;
    _zhangfuStr.text = @"涨幅";
    _zhangfuStr.font = [UIFont systemFontOfSize:11];
    _zhangfuStr.textColor = [UIColor whiteColor];
    [self.switchBtn addSubview:_zhangfuStr];
    
    _chengjiaoeStr = [[UILabel alloc] initWithFrame:CGRectMake(50,0 , 50, 30)];
    _chengjiaoeStr.textAlignment = NSTextAlignmentCenter;
    _chengjiaoeStr.text = @"成交额";
    _chengjiaoeStr.font = [UIFont systemFontOfSize:11];
    _chengjiaoeStr.textColor = [UIColor colorWithHex:@"#ADB7EA"];
    [self.switchBtn addSubview:_chengjiaoeStr];
    
    [self.numberText setValue:[UIColor colorWithHex:@"#646c8c"] forKeyPath:@"_placeholderLabel.textColor"];
    self.numberText.delegate = self;
    
    
    self.changeBZView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(15, 70, 235, 30) titles:@[@"BCH",@"BTC",@"ETH",@"CET",@"USDT"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.changeBZView.titleSelectFont = [UIFont systemFontOfSize:10];
    self.changeBZView.selectIndex = 0;
    [self.leftHeadView addSubview:self.changeBZView];

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(15, 100, 235, 1)];
    view.backgroundColor = [UIColor colorWithHex:@"ADB7EA"];
    [self.leftHeadView addSubview:view];

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
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView = [UIView new];
    self.leftTableView.tag = 1001;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.leftTableView registerNib:[UINib nibWithNibName:@"TradeCell" bundle:nil] forCellReuseIdentifier:@"TradeCell"];

    
    [self.view bringSubviewToFront:self.leftView];
//    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBtnClick)];
//    [self.leftView addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"nameStrLab" object:nil];
    
    [self.buyText setValue:[UIColor colorWithHex:@"#ADB7EA"] forKeyPath:@"_placeholderLabel.textColor"];
    self.buyText.textColor = [UIColor colorWithHex:@"#ADB7EA"];
    self.numText.textColor = [UIColor colorWithHex:@"#ADB7EA"];
    
    [self.searchText setValue:[UIColor colorWithHex:@"#ADB7EA"] forKeyPath:@"_placeholderLabel.textColor"];
    self.searchText.delegate = self;
    [self.searchText addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];

    [self createDataList:self.changeBZStr];
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
        [self.leftTableView reloadData];
    }
}
#pragma mark --
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.changeBZStr = @[@"BCH",@"BTC",@"ETH",@"CET",@"USDT"][endIndex];
    [self createDataList:self.changeBZStr];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    [self.searchText resignFirstResponder];
    [self.numberText resignFirstResponder];
    //    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"sousu"];
//    self.selectStr2 = textField.text;
//    [self createDataList:self.selectStr];
    return YES;
}

- (void)textChange{
    //变化后的字符串
    NSLog(@"-----------------%@",_searchText.text);
//    self.selectStr2 = _searchText.text;
//    [self createDataList:self.selectStr];
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
        NSArray * moneyArr;
        if (self.buyOrSell) {
            moneyArr = [WalletModel objectsWhere:[NSString stringWithFormat:@"where tickername ='%@'",@"USDT"] arguments:nil];
            self.buyNameLab.text = [NSString stringWithFormat:@"买入价(%@)",last3];
            if (moneyArr.count > 0) {
                WalletModel *walletModel = moneyArr[0];
                self.useLab.text = [NSString stringWithFormat:@"%.4f %@",walletModel.available,@"USDT"];
            }
            [self.buyBtn setBackgroundColor:[UIColor colorWithHex:@"#4796F6"]];
            [self.buyBtn setTitle:[NSString stringWithFormat:@"买入%@",first] forState:UIControlStateNormal];
            _shijiaLab.text = @"以当前卖盘挂单价格依次买入";
        }else{
            moneyArr = [WalletModel objectsWhere:[NSString stringWithFormat:@"where tickername ='%@'",first] arguments:nil];
            self.buyNameLab.text = [NSString stringWithFormat:@"卖出价(%@)",last3];
            if (moneyArr.count > 0) {
                WalletModel *walletModel = moneyArr[0];
                self.useLab.text = [NSString stringWithFormat:@"%.4f %@",walletModel.available,first];
            }
            [self.buyBtn setBackgroundColor:[UIColor colorWithHex:@"#f13d68"]];
            [self.buyBtn setTitle:@"卖出USDT" forState:UIControlStateNormal];
            _shijiaLab.text = @"以当前买盘挂单价格依次卖出";
        }
        NSArray * priceModelArr = [PriceModel objectsWhere:[NSString stringWithFormat:@"where tickername ='%@'",first] arguments:nil];
        if (priceModelArr.count>0) {
            PriceModel * priceModel = priceModelArr[0];
            self.cnyAboutLab.text = [NSString stringWithFormat:@"≈%@ CNY",priceModel.price];
            self.cnyLab.text = [NSString stringWithFormat:@"≈%@ CNY",priceModel.price];
        }
        self.buyNameLab.text = [NSString stringWithFormat:@"买入价(%@)",last3];
    }else{
        self.sybLab.text = [NSString stringWithFormat:@"/%@",last3];
        NSString *first = [self.nameStrLab substringToIndex:self.nameStrLab.length-3];
        self.nameLab.text = first;
        NSArray * moneyArr;
        if (self.buyOrSell) {
            moneyArr = [WalletModel objectsWhere:[NSString stringWithFormat:@"where tickername ='%@'",last3] arguments:nil];
            self.buyNameLab.text = [NSString stringWithFormat:@"买入价(%@)",last3];
            if (moneyArr.count > 0) {
                WalletModel *walletModel = moneyArr[0];
                self.useLab.text = [NSString stringWithFormat:@"%.4f %@",walletModel.available,last3];
            }
            [self.buyBtn setBackgroundColor:[UIColor colorWithHex:@"#4796F6"]];
            [self.buyBtn setTitle:[NSString stringWithFormat:@"买入%@",first] forState:UIControlStateNormal];
            _shijiaLab.text = @"以当前卖盘挂单价格依次买入";
        }else{
            moneyArr = [WalletModel objectsWhere:[NSString stringWithFormat:@"where tickername ='%@'",first] arguments:nil];
            self.buyNameLab.text = [NSString stringWithFormat:@"卖出价(%@)",last3];
            if (moneyArr.count > 0) {
                WalletModel *walletModel = moneyArr[0];
                self.useLab.text = [NSString stringWithFormat:@"%.4f %@",walletModel.available,first];
            }
            [self.buyBtn setBackgroundColor:[UIColor colorWithHex:@"#f13d68"]];
            [self.buyBtn setTitle:[NSString stringWithFormat:@"卖出%@",last3] forState:UIControlStateNormal];
            _shijiaLab.text = @"以当前买盘挂单价格依次卖出";
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

-(void)hiddenBtnClick{
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
        self.buyOrSell = YES;
        [self createUI];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.redBgH.constant = 42.5;
            [self.view layoutIfNeeded];
        }];
        self.redLine.hidden = NO;
        //卖出
        self.buyOrSell = NO;
        [self createUI];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)customSwitchStatusWithOn:(CLCustomSwitch *)custonSwitch
{
    NSLog(@"开启");
    if (custonSwitch.tag == 30) {
        _shijiaStr.textColor = [UIColor whiteColor];
        _xianjianStr.textColor = [UIColor colorWithHex:@"#ADB7EA"];
        self.kaiguan = YES;
        _shijiaLab.hidden = YES;
        _buyNameLab.hidden = NO;
        _buyText.hidden = NO;
        _cnyAboutLab.hidden = NO;
        _aboutLab.hidden = NO;
        _aboutName.hidden = NO;
    }else{
        _zhangfuStr.textColor = [UIColor whiteColor];
        _chengjiaoeStr.textColor = [UIColor colorWithHex:@"#ADB7EA"];
    }
}

- (void)customSwitchStatusWithOff:(CLCustomSwitch *)custonSwitch
{
    NSLog(@"关闭");
    if (custonSwitch.tag == 30) {
        _xianjianStr.textColor = [UIColor whiteColor];
        _shijiaStr.textColor = [UIColor colorWithHex:@"#ADB7EA"];
        self.kaiguan = NO;
        _shijiaLab.hidden = NO;
        _buyNameLab.hidden = YES;
        _buyText.hidden = YES;
        _cnyAboutLab.hidden = YES;
        _aboutLab.hidden = YES;
        _aboutName.hidden = YES;
    }else{
        _chengjiaoeStr.textColor = [UIColor whiteColor];
        _zhangfuStr.textColor = [UIColor colorWithHex:@"#ADB7EA"];
    }
}

-(void)createJBBZ{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"market"] = self.nameStrLab;
    param[@"limit"] = @"10";
    param[@"merge"] = self.merge;
    [NetWorking requestWithApi2:@"https://api.coinex.com/v1/market/depth" param:param thenSuccess:^(NSDictionary *responseObject) {
        //NSLog(@"===:%@",responseObject);
        NSDictionary * dic = responseObject[@"data"];
        self.sellArr = dic[@"asks"];
        self.buyArr = dic[@"bids"];
        [self.tableView reloadData];
    } fail:^{
        
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        if (self.sellArr.count>self.buyArr.count) {
            return self.sellArr.count;
        }else{
            return self.buyArr.count;
        }
    }else{
        return _dataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        TardeViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"TardeViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.sellArr.count>self.buyArr.count) {
            NSArray * sell = self.sellArr[indexPath.row];
            cell.sellPrice.text = sell[1];
            cell.sellNum.text = sell[0];
            if (indexPath.row < self.buyArr.count) {
                NSArray * buy = self.buyArr[indexPath.row];
                cell.buyPrice.text = buy[1];
                cell.buyNum.text = buy[0];
            }else{
                cell.buyPrice.text = @"";
                cell.buyNum.text = @"";
            }
        }else{
            NSArray * sell = self.buyArr[indexPath.row];
            cell.buyNum.text = sell[1];
            cell.buyPrice.text = sell[0];
            if (indexPath.row < self.sellArr.count) {
                NSArray * buy = self.sellArr[indexPath.row];
                cell.sellNum.text = buy[1];
                cell.sellPrice .text = buy[0];
            }else{
                cell.sellNum.text = @"";
                cell.sellPrice.text = @"";
            }
        }
        return cell;
    }else{
        MarketModel * model = _dataArr[indexPath.row];
        TradeCell *cell = [tableView dequeueReusableCellWithIdentifier: @"TradeCell" forIndexPath:indexPath];
        [cell setCellModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.storeBtn.tag = 100+indexPath.row;
        [cell.storeBtn addTarget:self action:@selector(storeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketModel * model = _dataArr[indexPath.row];
    self.nameStrLab = model.tickername;
    [self createUI];
    [self hiddenBtnClick];
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
- (IBAction)changeMe:(id)sender {
    self.changeMeView.hidden = !self.changeMeView.hidden;
    NSArray * arr = @[@"0.1",@"0.01",@"0.001",@"0.0001",@"0.00001",@"0.000001",@"0.0000001",@"0.00000001"];
    for (int i = 5000; i<5008; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        if ([self.merge isEqualToString:arr[i-5000]]) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
}
- (IBAction)changeMeBtn:(id)sender {
    NSArray * arr = @[@"0.1",@"0.01",@"0.001",@"0.0001",@"0.00001",@"0.000001",@"0.0000001",@"0.00000001"];
    UIButton * btn = (UIButton*)sender;
    self.merge = arr[btn.tag- 5000];
    self.changeMeView.hidden = YES;
    [self.changeMeBtn setTitle:self.merge forState:UIControlStateNormal];
    [self createJBBZ];
}
@end
