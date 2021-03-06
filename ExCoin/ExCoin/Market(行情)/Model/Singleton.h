//
//  Singleton.h
//  ZWXYMTDemo
//
//  Created by 周飙 on 2018/3/30.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Singleton : NSObject
@property (strong, nonatomic)NSString * name;

+ (instancetype)sharedInstance;
@end
