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

@property (nonatomic, assign) SYButonStyle style;

+ (instancetype)customButtonWithTitle:(NSString *)title;
+ (instancetype)customButtonWithTitle:(NSString *)title imageName:(NSString *)imageName;
+ (instancetype)customButtonWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selImageName;
+ (instancetype)customButtonWithImageName:(NSString *)imageName;
+ (instancetype)customButtonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selImageName;

+ (instancetype)systemButtonWithTitle:(NSString *)title;

+ (instancetype)defaultButtonWithTitle:(NSString *)title;
+ (instancetype)defaultButtonWithTitle:(NSString *)title imageName:(NSString *)imageName;

+ (instancetype)primaryButtonWithTitle:(NSString *)title;
+ (instancetype)primaryButtonWithTitle:(NSString *)title imageName:(NSString *)imageName;

+ (instancetype)destructiveButtonWithTitle:(NSString *)title;
+ (instancetype)destructiveButtonWithTitle:(NSString *)title imageName:(NSString *)imageName;

- (void)setLayoutStyle:(SYButtonLayoutStyle)layoutStyle;
- (void)addTarget:(id)target action:(SEL)action;

@end
