//
//  XQQScrollBtn.h
//  XQQScrollerMenu
//
//  Created by XQQ on 16/10/13.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XQQScrollBtn;
@protocol scrollBtnDidPress <NSObject>

- (void)scrollBtnDidPress:(XQQScrollBtn*)scrollBtn;

@end

@interface XQQScrollBtn : UIView

@property (nonatomic, weak)  id<scrollBtnDidPress> delegate;

- (void)setTitle:(NSString*)title;
- (void)setTitleColor:(UIColor*)color;
- (void)setBottomColor:(UIColor*)color;
@end
