//
//  TardeViewController.m
//  ExCoin
//
//  Created by 周飙 on 2018/9/14.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "TardeViewController.h"
#import "CLCustomSwitch.h"
@interface TardeViewController ()<CLCustomSwitchDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greenBgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redBgH;
@property (weak, nonatomic) IBOutlet UIView *greenLine;
@property (weak, nonatomic) IBOutlet UIView *redLine;
@property (weak, nonatomic) IBOutlet UIButton *greebBtn;
@property (weak, nonatomic) IBOutlet UIButton *redBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (weak, nonatomic) IBOutlet UILabel *bili;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *numShowLab;

@property (strong, nonatomic) CLCustomSwitch *priceSwitch;
@property (strong, nonatomic) UISlider *slider;
@end

@implementation TardeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(28, 35, 64);
    self.navigationController.navigationBarHidden = YES;
    self.redBgH.constant = 0;
    
    self.priceSwitch = [[CLCustomSwitch alloc] initWithFrame:CGRectMake(ScreenW-115, 135, 100, 40)];
    // 开关背景
    self.priceSwitch.bgImageView.image = [UIImage imageNamed:@"icon_switchBg"];
    // 开关滑块
    self.priceSwitch.switchImageView.image = [UIImage imageNamed:@"icon_switchSe"];
    self.priceSwitch.delegate = self;
    self.priceSwitch.on = NO ; // 初始状态为开
    [self.view addSubview:self.priceSwitch];
    
    [self.numberText setValue:[UIColor colorWithHex:@"#646c8c"] forKeyPath:@"_placeholderLabel.textColor"];
    self.numberText.delegate = self;
    
    // 初始化
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(ScreenW/2.0-30, 325, ScreenW/2.0+15, 20)];
    // 添加到俯视图
    [self.view addSubview:self.slider];
    // 设置最小值
    self.slider.minimumValue = 0;
    // 设置最大值
    self.slider.maximumValue = 100;
    // 设置初始值
    self.slider.value = 0;
    // 设置可连续变化
    self.slider.continuous = YES;
    
    /// 也可设置为图片
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"icon_min"] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"icon_max"] forState:UIControlStateNormal];
    
    //设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
    [self.slider setThumbImage:[UIImage imageNamed:@"icon_schedule"] forState:UIControlStateNormal];
    // 针对值变化添加响应方法
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}
-(void)sliderValueChanged:(UISlider*)sender{
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
        [UIView animateWithDuration:3 animations:^{
            self.greenBgH.constant = 42.5;
        } completion:^(BOOL finished) {
            self.greenBgH.constant = 42.5;
        }];
        self.greenLine.hidden = NO;
    }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        self.redBgH.constant = 42.5;
        [UIView commitAnimations];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
