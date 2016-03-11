//
//  UIButton+Factory.h
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

typedef NS_ENUM(NSUInteger, SYButtonLayoutStyle) {
    SYButtonLayoutStyleHorizontalImageLeft,     // Default
    SYButtonLayoutStyleHorizontalImageRight,
    SYButtonLayoutStyleVerticalImageUp,
    SYButtonLayoutStyleVerticalImageDown
};

@interface UIButton (Factory)

@property (nonatomic, assign) BOOL isAnimationEnabled;  // Default is NO

+ (instancetype)buttonWithTitle:(NSString *)title;
+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName;
+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName disabledImageName:(NSString *)disabledImageName;
+ (instancetype)buttonWithImageName:(NSString *)imageName;
+ (instancetype)buttonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selImageName;
+ (instancetype)buttonWithImageName:(NSString *)imageName disabledImageName:(NSString *)disabledImageName;

+ (instancetype)linkButtonWithTitle:(NSString *)title;

+ (instancetype)defaultButtonWithTitle:(NSString *)title;
+ (instancetype)primaryButtonWithTitle:(NSString *)title;
+ (instancetype)destructiveButtonWithTitle:(NSString *)title;

- (void)setLayoutStyle:(SYButtonLayoutStyle)layoutStyle;
- (void)addTarget:(id)target action:(SEL)action;

@end
