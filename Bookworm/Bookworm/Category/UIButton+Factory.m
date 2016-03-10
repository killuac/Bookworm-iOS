//
//  UIButton+Factory.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "UIButton+Factory.h"

@implementation UIButton (Factory)

- (void)setStyle:(SYButonStyle)style
{
    objc_setAssociatedObject(self, @selector(style), @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.layer.cornerRadius = DEFAULT_CORNER_RADIUS;
    [self setBackgroundColorForState:UIControlStateNormal];
}

- (SYButonStyle)style
{
    return [objc_getAssociatedObject(self, @selector(style)) unsignedIntegerValue];
}

- (void)setIsAnimationEnabled:(BOOL)isAnimationEnabled
{
    objc_setAssociatedObject(self, @selector(isAnimationEnabled), @(isAnimationEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isAnimationEnabled
{
    return [objc_getAssociatedObject(self, @selector(isAnimationEnabled)) boolValue];
}

- (void)setLayoutStyle:(SYButtonLayoutStyle)layoutStyle
{
    [self setLayoutStyle:layoutStyle spacing:DEFAULT_INSET * 2];
}

- (void)setLayoutStyle:(SYButtonLayoutStyle)layoutStyle spacing:(CGFloat)spacing
{
    if (SYButtonLayoutStyleVerticalImageUp == layoutStyle || SYButtonLayoutStyleVerticalImageDown == layoutStyle) {
        self.titleLabel.font = [UIFont defaultFont];
    }
    
    CGFloat inset = spacing / 2;
    CGFloat imageWidth = self.imageView.width;
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGFloat titleWidth = titleSize.width;
    CGFloat imageInset = (titleWidth > imageWidth) ? (titleWidth - imageWidth) / 2 : 0;
    
    switch (layoutStyle) {
        case SYButtonLayoutStyleHorizontalImageLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
            self.size = CGSizeMake(self.width+spacing, self.height);
            break;
            
        case SYButtonLayoutStyleHorizontalImageRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth+spacing, 0, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth+inset), 0, imageWidth+inset);
            self.size = CGSizeMake(self.width+spacing, self.height);
            break;
            
        case SYButtonLayoutStyleVerticalImageUp:
            self.size = CGSizeMake(titleWidth, self.imageView.height+titleSize.height+spacing);
            inset += self.height / 2;
            self.imageEdgeInsets = UIEdgeInsetsMake(-(inset-spacing), imageInset, 0, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(inset+spacing, -imageWidth, 0, 0);
            break;
            
        case SYButtonLayoutStyleVerticalImageDown:
            self.size = CGSizeMake(self.maxWidth, self.imageView.height+titleSize.height+spacing);
            inset = self.imageView.height / 4 + inset;
            self.titleEdgeInsets = UIEdgeInsetsMake(-inset, self.imageView.width/2, inset, -self.imageView.width/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(inset * 2, -self.titleLabel.width/2, -inset, self.titleLabel.width/2);
            break;
    }
}

- (CGFloat)maxWidth
{
    return MAX(self.imageView.width, self.titleLabel.width);
}

- (void)addTarget:(nullable id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Factory method
+ (instancetype)buttonWithType:(UIButtonType)buttonType
                         title:(NSString *)title
                     imageName:(NSString *)imageName
             selectedImageName:(NSString *)selImageName
             disabledImageName:(NSString *)disabledImageName
{
    UIButton *button = [UIButton buttonWithType:buttonType];
    [button setTintColor:[UIColor tintColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor tintColor] forState:UIControlStateNormal];
    
    if (imageName.length) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (selImageName.length) {
        [button setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
    }
    if (disabledImageName.length) {
        [button setImage:[UIImage imageNamed:disabledImageName] forState:UIControlStateDisabled];
    }
    
    [button sizeToFit];
    
    button.KVOController = [FBKVOController controllerWithObserver:button];
    [button.KVOController observe:button keyPaths:@[@"highlighted", @"enabled"] options:0 block:^(id observer, id object, NSDictionary *change) {
        [button setBackgroundColorForState:button.state];
        if (button.isAnimationEnabled) {
            if (UIControlStateHighlighted == button.state) {
                CGFloat scale = 1.5f;
                [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
                    button.imageView.transform = CGAffineTransformMakeScale(scale, scale);
                    button.titleLabel.transform = CGAffineTransformMakeScale(scale, scale);
                }];
            } else {
                [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
                    button.imageView.transform = CGAffineTransformIdentity;
                    button.titleLabel.transform = CGAffineTransformIdentity;
                }];
            }
        }
    }];
    
    return button;
}

- (void)setBackgroundColorForState:(UIControlState)state
{
    CGFloat alpha = 0.8f;
    
    switch (self.style) {
        case SYButonStyleDefault:
            if (UIControlStateHighlighted == state) {
                self.backgroundColor = [[UIColor defaultButtonColor] colorWithAlphaComponent:alpha];
            } else if (UIControlStateDisabled == state) {
                self.backgroundColor = [UIColor disabledButtonColor];
            } else {
                self.backgroundColor = [UIColor defaultButtonColor];
            }
            break;
            
        case SYButonStylePrimary:
            if (UIControlStateHighlighted == state) {
                self.backgroundColor = [[UIColor primaryButtonColor] colorWithAlphaComponent:alpha];
            } else if (UIControlStateDisabled == state) {
                self.backgroundColor = [UIColor disabledButtonColor];
            } else {
                self.backgroundColor = [UIColor primaryButtonColor];
            }
            break;
            
        case SYButonStyleDestructive:
            if (UIControlStateHighlighted == state) {
                self.backgroundColor = [[UIColor destructiveButtonColor] colorWithAlphaComponent:alpha];
            } else if (UIControlStateDisabled == state) {
                self.backgroundColor = [UIColor disabledButtonColor];
            } else {
                self.backgroundColor = [UIColor destructiveButtonColor];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - System button
+ (instancetype)buttonWithTitle:(NSString *)title
{
    return [UIButton buttonWithTitle:title imageName:nil selectedImageName:nil];
}

+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    return [UIButton buttonWithTitle:title imageName:imageName selectedImageName:nil];
}

+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selImageName
{
    return [UIButton buttonWithType:UIButtonTypeCustom title:title imageName:imageName selectedImageName:selImageName disabledImageName:nil];
}

+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName disabledImageName:(NSString *)disabledImageName
{
    return [UIButton buttonWithType:UIButtonTypeCustom title:title imageName:imageName selectedImageName:nil disabledImageName:disabledImageName];
}

+ (instancetype)buttonWithImageName:(NSString *)imageName
{
    return [UIButton buttonWithTitle:nil imageName:imageName selectedImageName:nil];
}

+ (instancetype)buttonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selImageName
{
    return [UIButton buttonWithTitle:nil imageName:imageName selectedImageName:selImageName];
}

+ (instancetype)buttonWithImageName:(NSString *)imageName disabledImageName:(NSString *)disabledImageName
{
    return [UIButton buttonWithTitle:nil imageName:imageName disabledImageName:disabledImageName];
}

+ (instancetype)linkButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithTitle:title];
    [button setTintColor:[UIColor linkButtonColor]];
    return button;
}

#pragma mark - Default, primary, destructive buttons
+ (instancetype)customButtonWithTitle:(NSString *)title
{
    return [UIButton buttonWithType:UIButtonTypeCustom title:title imageName:nil selectedImageName:nil disabledImageName:nil];
}

+ (instancetype)defaultButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton customButtonWithTitle:title];
    [button setStyle:SYButonStyleDefault];
    [button setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
    return button;
}

+ (instancetype)primaryButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton customButtonWithTitle:title];
    [button setStyle:SYButonStylePrimary];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor titleColor] forState:UIControlStateDisabled];
    return button;
}

+ (instancetype)destructiveButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton customButtonWithTitle:title];
    [button setStyle:SYButonStyleDestructive];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor titleColor] forState:UIControlStateDisabled];
    return button;
}

@end
