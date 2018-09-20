//
//  UIColor+Extension.m
//  KidApp
//
//  Created by 吴刘松 on 16/1/17.
//  Copyright © 2016年 Lance. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)kidGrassGreen{
    return [self colorWithHex:@"4ccca2"];
}

+ (UIColor *)kidBlack{
    return [self colorWithHex:@"898989"];
    
    //return [self colorWithHex:@"5de2a8"];
}

+(UIColor *)navGreen
{
    return [self colorWithHex:@"5de2a8"];
    
}
+ (UIColor *)kidLightGray{
    return [self colorWithHex:@"aeaead"];
}

+ (UIColor *)kidShadowGray{
    return [self colorWithHex:@"e5e7e8"];
}

+ (UIColor *)colorWithHex:(NSString *)hex{
    return [self colorWithHex:hex alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha
{
    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
