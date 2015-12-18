//
//  UIButton+Factory.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SYButonStyle) {
    SYButonStyleDefault,
    SYButonStylePrimary,
    SYButonStyleDestructive
};

typedef NS_ENUM(NSUInteger, SYLayoutStyle) {
    SYLayoutStyleHorizontalImageLeft,   // Default
    SYLayoutStyleHorizontalImageRight,
    SYLayoutStyleVerticalImageUp,
    SYLayoutStyleVerticalImageDown
};

@interface UIButton (Factory)

@property (nonatomic, assign) SYButonStyle style;

+ (instancetype)defaultButtonWithTitle:(NSString *)title;
+ (instancetype)defaultButtonWithTitle:(NSString *)title imageName:(NSString *)imageName;

+ (instancetype)primaryButtonWithTitle:(NSString *)title;
+ (instancetype)primaryButtonWithTitle:(NSString *)title imageName:(NSString *)imageName;

+ (instancetype)destructiveButtonWithTitle:(NSString *)title;
+ (instancetype)destructiveButtonWithTitle:(NSString *)title imageName:(NSString *)imageName;

+ (instancetype)customButtonWithImageName:(NSString *)imageName;
+ (instancetype)customButtonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selImageName;
+ (instancetype)customButtonWithTitle:(NSString *)title imageName:(NSString *)imageName;
+ (instancetype)customButtonWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selImageName;
+ (instancetype)customButtonWithTitle:(NSString *)title;

+ (instancetype)systemButtonWithTitle:(NSString *)title;

- (void)setLayoutStyle:(SYLayoutStyle)layoutStyle;
- (void)addTarget:(id)target action:(SEL)action;

@end
