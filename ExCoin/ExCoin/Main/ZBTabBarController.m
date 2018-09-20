//
//  ZBTabBarController.m
//  EcologicalExamination
//
//  Created by 周飙 on 2018/8/8.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "ZBTabBarController.h"
#import "ZBBaseNavVC.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

#define childArray @[@{ClassKey : @"MarketViewController",  TitleKey : @"行情", ImgKey: @"tab1_un", SelImgKey: @"tab1_se", StoryKey:@"Market"},@{ClassKey : @"TardeViewController",   TitleKey : @"交易", ImgKey: @"tab2_un", SelImgKey: @"tab2_se", StoryKey:@"Trade"},@{ClassKey : @"WalletViewController",  TitleKey : @"钱包", ImgKey: @"tab3_un", SelImgKey: @"tab3_se", StoryKey:@"Wallet"},@{ClassKey : @"AccountViewController", TitleKey : @"账户", ImgKey: @"tab4_un", SelImgKey: @"tab4_se", StoryKey:@"Account"}]

@interface ZBTabBarController ()<UITabBarControllerDelegate>

@end

@implementation ZBTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUpTabBar];
    [self setupViewControllers];
}

#pragma mark - 更换系统tabbar
-(void)setUpTabBar    {
    UITabBar *tabBar = [[UITabBar alloc] init];
    [tabBar setBackgroundColor:ZBBGColor];
    //KVC把系统换成自定义
//    [self setValue:tabBar forKey:@"tabBar"];
    
}
    
#pragma mark - 添加子控制器
- (void)addDcChildViewContorller{
//    NSArray *childArray = @[@{ClassKey : @"MarketViewController",  TitleKey : @"行情", ImgKey: @"tab1_un", SelImgKey: @"tab1_se", StoryKey:@"Market"},
//                            @{ClassKey : @"TardeViewController",   TitleKey : @"交易", ImgKey: @"tab2_un", SelImgKey: @"tab2_se", StoryKey:@"Trade"},
//                            @{ClassKey : @"WalletViewController",  TitleKey : @"钱包", ImgKey: @"tab3_un", SelImgKey: @"tab3_se", StoryKey:@"Wallet"},
//                            @{ClassKey : @"AccountViewController", TitleKey : @"账户", ImgKey: @"tab4_un", SelImgKey: @"tab4_se", StoryKey:@"Account"},
//                            ];
    
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:dict[StoryKey] bundle:nil];
        
        UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:dict[ClassKey]];
        
        //导航栏、tabbar的标题
        vc.title = dict[TitleKey];
        
        //导航栏的标题
//        vc.navigationItem.title = dict[TitleKey];
//        ZBBaseNavVC *nav = [[ZBBaseNavVC alloc] initWithRootViewController:vc];
//        UITabBarItem *item = vc.tabBarItem;
//
//
//        item.image = [UIImage imageNamed:dict[ImgKey]];
//        item.selectedImage = [[UIImage imageNamed:dict[SelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //tabbar的标题
//        [item setTitle:dict[TitleKey]];
        //    item.imageInsets = UIEdgeInsetsMake(6, 0,-6, 0);//（当只有图片的时候）需要自动调整
        [self addChildViewController:vc];
    }];
}

#pragma mark - Methods

- (void)setupViewControllers {
    NSMutableArray * vcArr = [[NSMutableArray alloc] init];
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:dict[StoryKey] bundle:nil];
        
        UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:dict[ClassKey]];
        
        [vcArr addObject:vc];
    }];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:vcArr];
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
//    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
//    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
//    NSArray *tabBarItemImages = @[@"first", @"second", @"third"];
    
//    NSInteger index = 0;
//    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
//        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
//        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
//                                                      [tabBarItemImages objectAtIndex:index]]];
//        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
//                                                        [tabBarItemImages objectAtIndex:index]]];
//        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
//
//        index++;
//    }
//    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
////        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:dict[StoryKey] bundle:nil];
//
////        UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:dict[ClassKey]];
//        RDVTabBarItem *item = [[RDVTabBarItem alloc] init];
//        [item setBackgroundSelectedImage:dict[SelImgKey] withUnselectedImage:dict[ImgKey]];
//
//    }];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        NSDictionary *dict = childArray[index];
        [item setBackgroundSelectedImage:dict[SelImgKey] withUnselectedImage:dict[ImgKey]];
        UIImage *selectedimage = [UIImage imageNamed:dict[ImgKey]];
        UIImage *unselectedimage = [UIImage imageNamed:dict[ImgKey]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}



@end
