//
//  UIButton+Base.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SYButonStyle) {
    SYButonStyleNone,
    SYButonStyleDefault,
    SYButonStylePrimary,
    SYButonStyleDestructive
};

typedef NS_ENUM(NSUInteger, SYButtonLayout) {
    SYButtonLayoutHorizontalNone,
    SYButtonLayoutHorizontalImageLeft,      // Default for image and title
    SYButtonLayoutHorizontalImageRight,
    SYButtonLayoutVerticalImageUp,
    SYButtonLayoutVerticalImageDown
};

@interface UIButton (Base)

+ (instancetype)buttonWithTitle:(NSString *)title;
+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName;
+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName layout:(SYButtonLayout)layout;
+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName disabledImageName:(NSString *)disabledImageName;
+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName disabledImageName:(NSString *)disabledImageName layout:(SYButtonLayout)layout;
+ (instancetype)buttonWithImageName:(NSString *)imageName;
+ (instancetype)buttonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selImageName;
+ (instancetype)buttonWithImageName:(NSString *)imageName disabledImageName:(NSString *)disabledImageName;

+ (instancetype)systemButtonWithTitle:(NSString *)title;
+ (instancetype)linkButtonWithTitle:(NSString *)title;

+ (instancetype)defaultButtonWithTitle:(NSString *)title;
+ (instancetype)primaryButtonWithTitle:(NSString *)title;
+ (instancetype)destructiveButtonWithTitle:(NSString *)title;

- (void)setLayout:(SYButtonLayout)layout;
- (void)addTarget:(id)target action:(SEL)action;

@end
