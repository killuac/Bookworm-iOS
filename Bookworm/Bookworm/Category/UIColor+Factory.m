//
//  UIColor+Factory.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "UIColor+Factory.h"

@implementation UIColor (Factory)

+ (instancetype)primaryColor
{
//    return [UIColor colorWithRed:162/255.0 green:175/255.0 blue:195/255.0 alpha:1.0];     // 蓝灰
//    return [UIColor colorWithRed:115/255.0 green:138/255.0 blue:153/255.0 alpha:1.0];       // 墨灰
//    return [UIColor colorWithRed:195/255.0 green:214/255.0 blue:29/255.0 alpha:1.0];        // 柳黄
//    return [UIColor colorWithRed:63/255.0 green:74/255.0 blue:80/255.0 alpha:1.0];       // 苍色
//    return [UIColor colorWithRed:142/255.0 green:150/255.0 blue:95/255.0 alpha:1.0];      // 柳煤竹茶
//    return [UIColor colorWithRed:110/255.0 green:101/255.0 blue:121/255.0 alpha:1.0];     // 鸠羽紫
//    return [UIColor colorWithRed:200/255.0 green:176/255.0 blue:143/255.0 alpha:1.0];     // 远州鼠
//    return [UIColor colorWithRed:158/255.0 green:184/255.0 blue:161/255.0 alpha:1.0];       // 锖青磁
    return [UIColor colorWithRed:238/255.0 green:222/255.0 blue:176/255.0 alpha:1.0];
}

+ (instancetype)backgroundColor
{
//    return [UIColor colorWithRed:255/255.0 green:251/255.0 blue:240/255.0 alpha:1.0];       // 象牙白
//    return [UIColor colorWithRed:240/255.0 green:252/255.0 blue:255/255.0 alpha:1.0];       // 雪白
//    return [UIColor colorWithRed:214/255.0 green:236/255.0 blue:240/255.0 alpha:1.0];       // 月白
//    return [UIColor colorWithRed:243/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];       // 荼白
    return [UIColor colorWithRed:240/255.0 green:240/255.0 blue:244/255.0 alpha:1.0];       // 铅白
}

+ (instancetype)lightBackgroundColor
{
    return [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
}

+ (instancetype)playerBackgroundColor
{
    return [UIColor colorWithRed:155/255.0 green:204/255.0 blue:220/255.0 alpha:1.0];
}

+ (instancetype)playerProgressTrackColor
{
    return [UIColor colorWithRed:100.0f/255.0f green:140.0f/255.0f blue:162.0f/255.0f alpha:1];
}

+ (instancetype)bubbleBackgroundColor
{
    return [UIColor colorWithRed:194/255.0 green:223/255.0 blue:232/255.0 alpha:1.0];
}

+ (instancetype)titleColor
{
    return [UIColor colorWithRed:67/255.0 green:52/255.0 blue:27/255.0 alpha:1.0];
}

+ (instancetype)subtitleColor
{
    return [UIColor colorWithRed:144/255.0 green:141/255.0 blue:155/255.0 alpha:1.0];
}

+ (instancetype)separatorLineColor
{
    return [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
}

+ (instancetype)primaryTagColor
{
    return [UIColor primaryColor];
}

+ (instancetype)defaultTagColor
{
    return [UIColor colorWithRed:144/255.0 green:141/255.0 blue:155/255.0 alpha:1.0];
}

+ (instancetype)primaryButtonNormalColor
{
    return [UIColor primaryColor];
}

+ (instancetype)primaryButtonHighlightedColor
{
    return [UIColor colorWithRed:218/255.0 green:169/255.0 blue:48/255.0 alpha:1.0];
}

+ (instancetype)buttonDisabledColor
{
    return [UIColor colorWithRed:222/255.0 green:224/255.0 blue:228/255.0 alpha:1.0];
}

+ (instancetype)defaultButtonNormalColor
{
    return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
}

+ (instancetype)defaultButtonHighlightedColor
{
    return [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
}

+ (instancetype)destructiveButtonNormalColor
{
    return [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
}

+ (instancetype)destructiveButtonHighlightedColor
{
    return [UIColor colorWithRed:235/255.0 green:0.0 blue:0.0 alpha:1.0];
}

+ (instancetype)linkButtonColor
{
    return [UIColor colorWithRed:155/255.0 green:204/255.0 blue:220/255.0 alpha:1.0];
}

+ (instancetype)defaultCountFontColor
{
    return [UIColor colorWithRed:155/255.0 green:204/255.0 blue:220/255.0 alpha:1.0];
}

+ (instancetype)messageFontColor
{
    return [UIColor colorWithRed:88/255.0 green:88/255.0 blue:97/255.0 alpha:1.0];
}

+ (instancetype)recordingWaveColor
{
    return [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0];
}

@end
