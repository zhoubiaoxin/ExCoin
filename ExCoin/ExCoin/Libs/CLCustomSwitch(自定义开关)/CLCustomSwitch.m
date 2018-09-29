//
//  CLCustomSwitch.m
//  customSwitchDemo
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 Charlin. All rights reserved.
//

#import "CLCustomSwitch.h"

@interface CLCustomSwitch ()
{
    CGFloat width;
    CGFloat height;
}
@end

@implementation CLCustomSwitch

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (frame.size.height > 30) {
            frame.size.height = 30;
        }
        width = frame.size.width;
        height = frame.size.height;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    // 背景
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    //    bgImageView.image = [UIImage imageNamed:@"onoffkey"];
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    // 开关
    UIImageView *switchImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width/2+2, height)];
//    switchImgView.image = [UIImage imageNamed:@"pantrol_slidebarbutton"];
    switchImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSwitchImgViewAcion:)];
    tapGR.numberOfTapsRequired = 1;
    [switchImgView addGestureRecognizer:tapGR];
    [self addSubview:switchImgView];
    self.switchImageView = switchImgView;
}

- (void)tapSwitchImgViewAcion:(UITapGestureRecognizer *)tap
{
    self.on = !self.isOn;
}

- (void)setOn:(BOOL)on
{
    _on = on;
    CGRect rect = _switchImageView.frame;
    CGFloat switchX = rect.origin.x;
    if (on == YES) {
        switchX = width - _switchImageView.frame.size.width;
        if ([self.delegate respondsToSelector:@selector(customSwitchStatusWithOn:)]) {
            [self.delegate customSwitchStatusWithOn:self];
        }
    } else {
        switchX = 0;
        if ([self.delegate respondsToSelector:@selector(customSwitchStatusWithOff:)]) {
            [self.delegate customSwitchStatusWithOff:self];
        }
    }
    rect.origin.x = switchX;
    [UIView animateWithDuration:0.2f animations:^{
        _switchImageView.frame = rect;
    }];
}

@end
