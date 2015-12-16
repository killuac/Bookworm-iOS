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
    return [UIColor colorWithRed:238/255.0 green:189/255.0 blue:68/255.0 alpha:1.0];
}

+ (instancetype)backgroundColor
{
    return [UIColor colorWithRed:236/255.0 green:238/255.0 blue:242/255.0 alpha:1.0];
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
    return [UIColor colorWithRed:194/255.0 green:223/255.0 blue:232/255.0 alpha:1];
}

+ (instancetype)defaultTitleColor
{
    return [UIColor colorWithRed:88/255.0 green:88/255.0 blue:97/255.0 alpha:1.0];
}

+ (instancetype)defaultSubtitleColor
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
