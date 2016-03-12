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
    if (SYButtonLayoutStyleVerticalImageUp == layoutStyle || SYButtonLayoutStyleVerticalImageDown == layoutStyle) {
        self.titleLabel.font = [UIFont defaultFont];
    }
    
    CGFloat inset = DEFAULT_INSET;
    CGFloat spacing = inset * 2;
    CGFloat imageWidth = self.imageView.width;
    CGFloat titleWidth = self.titleLabelSize.width;
    
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
            self.size = [self fittedSize];
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
            inset = self.height / 2 - inset;
            self.imageEdgeInsets = UIEdgeInsetsMake(0, (self.width-imageWidth)/2, inset, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, 0);
            break;
            
        case SYButtonLayoutStyleVerticalImageDown:
            self.size = [self fittedSize];
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            inset = self.height / 2 - inset;
            self.imageEdgeInsets = UIEdgeInsetsMake(inset, (self.width-imageWidth)/2, 0, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, 0);
            break;
    }
}

- (CGSize)titleLabelSize
{
    return [self.titleLabel.text sizeWithFont:self.titleLabel.font];
}

- (CGSize)fittedSize
{
    CGFloat width = MAX(self.imageView.width, self.titleLabel.width);
    CGFloat height = self.imageView.height + self.titleLabelSize.height + DEFAULT_INSET * 2;
    return CGSizeMake(width, height);
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
    [button setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
    
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
    switch (self.style) {
        case SYButonStyleDefault:
            if (UIControlStateHighlighted == state) {
                self.backgroundColor = [[UIColor defaultButtonColor] darkerColor];
            } else if (UIControlStateDisabled == state) {
                self.backgroundColor = [UIColor disabledButtonColor];
            } else {
                self.backgroundColor = [UIColor defaultButtonColor];
            }
            break;
            
        case SYButonStylePrimary:
            if (UIControlStateHighlighted == state) {
                self.backgroundColor = [[UIColor primaryButtonColor] darkerColor];
            } else if (UIControlStateDisabled == state) {
                self.backgroundColor = [UIColor disabledButtonColor];
            } else {
                self.backgroundColor = [UIColor primaryButtonColor];
            }
            break;
            
        case SYButonStyleDestructive:
            if (UIControlStateHighlighted == state) {
                self.backgroundColor = [[UIColor destructiveButtonColor] darkerColor];
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tintColor = [UIColor linkButtonColor];
    button.titleLabel.font = [UIFont defaultFont];
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    
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
