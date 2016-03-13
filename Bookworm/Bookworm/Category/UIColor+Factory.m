//
//  UIColor+Factory.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "UIColor+Factory.h"

@implementation UIColor (Factory)

- (UIColor *)lighterColor
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h saturation:s brightness:MIN(b * 1.3, 1.0) alpha:a];
    return self;
}

- (UIColor *)darkerColor
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h saturation:s brightness:b * 0.75 alpha:a];
    return self;
}

#pragma mark - Tint color
+ (instancetype)tintColor
{
    return [UIColor colorWithRed:102/255.0 green:153/255.0 blue:161/255.0 alpha:1.0];   // 青浅葱
}

+ (instancetype)barTintColor
{
    return [UIColor colorWithRed:64/255.0 green:91/255.0 blue:85/255.0 alpha:1.0];      // 青铁御纳户
}

#pragma mark - Background color
+ (instancetype)backgroundColor
{
    return [UIColor colorWithRed:240/255.0 green:240/255.0 blue:244/255.0 alpha:1.0];   // 冷白
}

+ (instancetype)bookWhileBackgroundColor
{
    return [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1.0];
}

+ (instancetype)bookYellowBackgroundColor
{
    return [UIColor colorWithRed:248/255.0 green:241/255.0 blue:227/255.0 alpha:1.0];
}

+ (instancetype)bookGrayBackgroundColor
{
    return [UIColor colorWithRed:222/255.0 green:226/255.0 blue:228/255.0 alpha:1.0];
}

+ (instancetype)bookBlackBackgroundColor
{
    return [UIColor colorWithRed:90/255.0 green:90/255.0 blue:92/255.0 alpha:1.0];
}

+ (instancetype)bubbleBackgroundColor
{
    return [UIColor colorWithRed:194/255.0 green:223/255.0 blue:232/255.0 alpha:1.0];
}

#pragma mark - Text color
+ (instancetype)titleColor
{
    return [UIColor colorWithRed:55/255.0 green:60/255.0 blue:56/255.0 alpha:1.0];
}

+ (instancetype)subtitleColor
{
    return [UIColor colorWithRed:145/255.0 green:152/255.0 blue:159/255.0 alpha:1.0];   // 银鼠
}

+ (instancetype)separatorLineColor
{
    return [UIColor lightGrayColor];
}

#pragma mark - Button color
+ (instancetype)defaultButtonColor
{
    return [UIColor whiteColor];
}

+ (instancetype)primaryButtonColor
{
    return [UIColor tintColor];
}

+ (instancetype)destructiveButtonColor
{
    return [UIColor redColor];
}

+ (instancetype)disabledButtonColor
{
    return [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0];
}

+ (instancetype)linkButtonColor
{
    return [[UIColor blueColor] colorWithAlphaComponent:0.6];
}

@end
