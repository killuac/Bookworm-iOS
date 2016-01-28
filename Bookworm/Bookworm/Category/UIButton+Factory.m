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
    [self setBackgroundColorForStyle:style forState:UIControlStateNormal];
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
    [self setLayoutStyle:layoutStyle inset:DEFAULT_INSET * 2];
}

- (void)setLayoutStyle:(SYButtonLayoutStyle)layoutStyle inset:(CGFloat)inset
{
    inset /= 2.0f;
    
    switch (layoutStyle) {
        case SYButtonLayoutStyleHorizontalImageLeft:
            self.titleEdgeInsets = UIEdgeInsetsMake(0, inset, 0, -inset);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -inset, 0, inset);
            break;
            
        case SYButtonLayoutStyleHorizontalImageRight:
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.imageView.width+inset), 0, self.imageView.width+inset);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.width+inset, 0, -(self.titleLabel.width+inset));
            break;
            
        case SYButtonLayoutStyleVerticalImageUp:
            inset = self.imageView.height / 4 + inset;
            self.imageEdgeInsets = UIEdgeInsetsMake(-inset, self.titleLabel.width/2, inset, -self.titleLabel.width/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(inset * 2, -self.imageView.width/2, -inset, self.imageView.width/2);
            self.size = [self fittedSize];
            break;
            
        case SYButtonLayoutStyleVerticalImageDown:
            inset = self.imageView.height / 4 + inset;
            self.titleEdgeInsets = UIEdgeInsetsMake(-inset, self.imageView.width/2, inset, -self.imageView.width/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(inset * 2, -self.titleLabel.width/2, -inset, self.titleLabel.width/2);
            self.size = [self fittedSize];
            break;
    }
}

- (CGSize)fittedSize
{
    return CGSizeMake(MAX(self.imageView.width, self.titleLabel.width), self.imageView.height+self.titleLabel.height+DEFAULT_INSET*2);
}

- (void)addTarget:(nullable id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Factory method
+ (instancetype)buttonWithStyle:(SYButonStyle)style title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selImageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
    if (imageName.length) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setLayoutStyle:SYButtonLayoutStyleHorizontalImageLeft];
    }
    if (selImageName.length) {
        [button setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
    }
    [button sizeToFit];
    
    if (SYButonStyleNone != style) {
        button.style = style;
    }
    
    button.KVOController = [FBKVOController controllerWithObserver:button];
    [button.KVOController observe:button keyPaths:@[@"highlighted", @"enabled"] options:0 block:^(id observer, id object, NSDictionary *change) {
        if (SYButonStyleNone != style) {
            [button setBackgroundColorForStyle:style forState:button.state];
        }
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

- (void)setBackgroundColorForStyle:(SYButonStyle)style forState:(UIControlState)state
{
    switch (style) {
        case SYButonStyleDefault:
            if (UIControlStateHighlighted == state) {
                self.backgroundColor = [UIColor defaultButtonHighlightedColor];
            } else if (UIControlStateDisabled == state) {
                self.backgroundColor = [UIColor buttonDisabledColor];
            } else {
                self.backgroundColor = [UIColor defaultButtonNormalColor];
            }
            break;
            
        case SYButonStylePrimary:
            if (UIControlStateHighlighted == state) {
                self.backgroundColor = [UIColor primaryButtonHighlightedColor];
            } else if (UIControlStateDisabled == state) {
                self.backgroundColor = [UIColor buttonDisabledColor];
            } else {
                self.backgroundColor = [UIColor primaryButtonNormalColor];
            }
            break;
            
        case SYButonStyleDestructive:
            if (UIControlStateHighlighted == state) {
                self.backgroundColor = [UIColor destructiveButtonHighlightedColor];
            } else if (UIControlStateDisabled == state) {
                self.backgroundColor = [UIColor buttonDisabledColor];
            } else {
                self.backgroundColor = [UIColor destructiveButtonNormalColor];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Custom button
+ (instancetype)customButtonWithTitle:(NSString *)title
{
    return [UIButton customButtonWithTitle:title imageName:nil selectedImageName:nil];
}

+ (instancetype)customButtonWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    return [UIButton customButtonWithTitle:title imageName:imageName selectedImageName:nil];
}

+ (instancetype)customButtonWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selImageName
{
    return [UIButton buttonWithStyle:SYButonStyleNone title:title imageName:imageName selectedImageName:selImageName];
}

+ (instancetype)customButtonWithImageName:(NSString *)imageName
{
    return [UIButton customButtonWithTitle:nil imageName:imageName selectedImageName:nil];
}

+ (instancetype)customButtonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selImageName
{
    return [UIButton customButtonWithTitle:nil imageName:imageName selectedImageName:selImageName];
}

#pragma mark - System button
+ (instancetype)systemButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    
    return button;
}

#pragma mark - Default, primary, destructive buttons
+ (instancetype)defaultButtonWithTitle:(NSString *)title
{
    return [self defaultButtonWithTitle:title imageName:nil];
}

+ (instancetype)defaultButtonWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    return [self buttonWithStyle:SYButonStyleDefault title:title imageName:imageName selectedImageName:nil];
}

+ (instancetype)primaryButtonWithTitle:(NSString *)title
{
    return [self primaryButtonWithTitle:title imageName:nil];
}

+ (instancetype)primaryButtonWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    UIButton *button = [self buttonWithStyle:SYButonStylePrimary title:title imageName:imageName selectedImageName:nil];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor titleColor] forState:UIControlStateDisabled];
    return button;
}

+ (instancetype)destructiveButtonWithTitle:(NSString *)title
{
    return [self destructiveButtonWithTitle:title imageName:nil];
}

+ (instancetype)destructiveButtonWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    UIButton *button = [self buttonWithStyle:SYButonStyleDestructive title:title imageName:imageName selectedImageName:nil];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor titleColor] forState:UIControlStateDisabled];
    return button;
}

@end
