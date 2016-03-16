//
//  UIColor+Factory.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Factory)

+ (instancetype)tintColor;
+ (instancetype)barTintColor;

+ (instancetype)backgroundColor;
+ (instancetype)bookWhileBackgroundColor;
+ (instancetype)bookYellowBackgroundColor;
+ (instancetype)bookGrayBackgroundColor;
+ (instancetype)bookBlackBackgroundColor;
+ (instancetype)bubbleBackgroundColor;

+ (instancetype)titleColor;
+ (instancetype)subtitleColor;
+ (instancetype)separatorColor;

+ (instancetype)defaultButtonColor;
+ (instancetype)primaryButtonColor;
+ (instancetype)destructiveButtonColor;
+ (instancetype)disabledButtonColor;
+ (instancetype)linkButtonColor;

- (UIColor *)lighterColor;
- (UIColor *)darkerColor;

@end
