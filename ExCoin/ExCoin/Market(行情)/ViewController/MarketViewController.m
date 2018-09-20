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


@interface MarketViewController ()<UIScrollViewDelegate,scrollMenuDelegate>
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

@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(28, 35, 64);
    [self createUI];
}
- (void)createUI{
    self.navigationItem.title = @"滚动菜单";
    NSArray * titleArr = @[@"自选",@"BCH",@"BTC",@"ETH",@"USDT"];
    NSArray * controllerNameArr = @[@"MarketListViewController1",@"MarketListViewController2",@"MarketListViewController3",@"MarketListViewController4",@"MarketListViewController5"];
    _menuView  = [[XQQScrollerMenuView alloc]initWithFrame:CGRectMake(15, 84, ScreenW-30, 44)];
    _menuView.titleArr = titleArr;
    _menuView.scrollDelegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_menuView];
    
    //控制器的滚动视图
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_menuView.frame), ScreenW, ScreenH - CGRectGetMaxY(_menuView.frame))];
    _scrollView.pagingEnabled = YES;
//     _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    //添加controllers
    NSArray * chelidControlls = [_menuView addChildrenControllersWithArr:controllerNameArr AndSuperController:self];
//    //给底部的滚动视图添加View  这个方法 会一次性把所有的控制器都初始化了
    [_menuView addSubViewToScrollView:_scrollView controllerArr:chelidControlls];
    
    /**根据下标添加控制器的View    刚开始为第一项*/
    [_menuView addSubViewToScrollViewWithIndex:0 superView:_scrollView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBtn)];
    [self.meunbg addGestureRecognizer:tapGesture];
    
    self.selectNum = 1;
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
    NSLog(@"%ld",(long)btn.tag);
    self.selectNum = (int)btn.tag - 100;
    if (btn.tag == 100||btn.tag == 101) {
        [self.menuBtn setTitle:@"成交额" forState:UIControlStateNormal];
    }else if (btn.tag == 102||btn.tag == 103){
        [self.menuBtn setTitle:@"涨幅" forState:UIControlStateNormal];
    }else if (btn.tag == 104||btn.tag == 105){
        [self.menuBtn setTitle:@"价格" forState:UIControlStateNormal];
    }else if (btn.tag == 106||btn.tag == 107){
        [self.menuBtn setTitle:@"币种" forState:UIControlStateNormal];
    }
    if (btn.tag%2 == 0) {
        self.menuUp.image = [UIImage imageNamed:@"icon_up_se"];
        self.menuDown.image = [UIImage imageNamed:@"icon_down_un"];
    }else{
        self.menuUp.image = [UIImage imageNamed:@"icon_up_un"];
        self.menuDown.image = [UIImage imageNamed:@"icon_down_se"];
    }
    self.meunbg.hidden = YES;
}

@end
