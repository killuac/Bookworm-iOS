//
//  UIColor+Factory.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Factory)

+ (instancetype)primaryColor;
+ (instancetype)backgroundColor;
+ (instancetype)lightBackgroundColor;
+ (instancetype)playerBackgroundColor;
+ (instancetype)playerProgressTrackColor;
+ (instancetype)bubbleBackgroundColor;

+ (instancetype)titleColor;
+ (instancetype)subtitleColor;
+ (instancetype)separatorLineColor;
+ (instancetype)primaryTagColor;
+ (instancetype)defaultTagColor;

+ (instancetype)primaryButtonNormalColor;
+ (instancetype)primaryButtonHighlightedColor;
+ (instancetype)buttonDisabledColor;
+ (instancetype)defaultButtonNormalColor;
+ (instancetype)defaultButtonHighlightedColor;
+ (instancetype)destructiveButtonNormalColor;
+ (instancetype)destructiveButtonHighlightedColor;
+ (instancetype)linkButtonColor;

+ (instancetype)defaultCountFontColor;
+ (instancetype)messageFontColor;
+ (instancetype)recordingWaveColor;

@end
