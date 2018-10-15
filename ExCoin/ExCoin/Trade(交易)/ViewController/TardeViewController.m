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
@end

@implementation TardeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHex:@"#151935"];
    self.navigationController.navigationBarHidden = YES;
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
    
//    // 初始化
    self.silder.frame = CGRectMake(ScreenW/2.0+15, 310, ScreenW/2.0+15, 10);
//    // 添加到俯视图
//    [self.view addSubview:self.slider];
    // 设置最小值
    self.silder.minimumValue = 0;
    // 设置最大值
    self.silder.maximumValue = 100;
    // 设置初始值
    self.silder.value = 0;
    // 设置可连续变化
    self.silder.continuous = YES;
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
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.redBgH.constant = 42.5;
            [self.view layoutIfNeeded];
        }];
        self.redLine.hidden = NO;
    }
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

@end
