//
//  CLCustomSwitch.h
//  customSwitchDemo
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 Charlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLCustomSwitch;
@protocol CLCustomSwitchDelegate <NSObject>
@optional
// 开启状态
- (void)customSwitchStatusWithOn:(CLCustomSwitch *)custonSwitch;
// 关闭状态
- (void)customSwitchStatusWithOff:(CLCustomSwitch *)custonSwitch;
@end

@interface CLCustomSwitch : UIView
@property (nonatomic, assign, getter=isOn) BOOL on;

// 背景
@property (nonatomic, strong) UIImageView *bgImageView;

// 滑块
@property (nonatomic, strong) UIImageView *switchImageView;

@property (nonatomic, weak) id<CLCustomSwitchDelegate> delegate;
@end
