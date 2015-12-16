//
//  UIButton+Factory.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "UIButton+Factory.h"

@implementation UIButton (Factory)

- (void)setStyle:(BZButonStyle)style
{
    objc_setAssociatedObject(self, @selector(style), @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BZButonStyle)style
{
    return [objc_getAssociatedObject(self, @selector(style)) unsignedIntegerValue];
}

- (void)setLayoutStyle:(BZLayoutStyle)layoutStyle
{
    CGFloat inset = 5.0f;
    
    switch (layoutStyle) {
        case BZLayoutStyleHorizontalImageLeft:
            self.titleEdgeInsets = UIEdgeInsetsMake(0, inset, 0, -inset);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -inset, 0, inset);
            break;
            
        case BZLayoutStyleHorizontalImageRight:
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.imageView.width+inset), 0, self.imageView.width+inset);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.width+inset, 0, -(self.titleLabel.width+inset));
            break;
            
        case BZLayoutStyleVerticalImageUp:
            inset = self.imageView.height / 4 + inset;
            self.imageEdgeInsets = UIEdgeInsetsMake(-inset, self.titleLabel.width/2, inset, -self.titleLabel.width/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(inset * 2, -self.imageView.width/2, -inset, self.imageView.width/2);
            break;
            
        case BZLayoutStyleVerticalImageDown:
            inset = self.imageView.height / 4 + inset;
            self.titleEdgeInsets = UIEdgeInsetsMake(-inset, self.imageView.width/2, inset, -self.imageView.width/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(inset * 2, -self.titleLabel.width/2, -inset, self.titleLabel.width/2);
            break;
    }
}

- (void)addTarget:(nullable id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Default, primary, destructive buttons
+ (instancetype)buttonWithStyle:(BZButonStyle)style title:(NSString *)title imageName:(NSString *)imageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    [button setStyle:style];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColorForStyle:style forState:button.state];
    [button setBackgroundColorForStyle:style forState:button.state];
    ![imageName isEmpty] ? [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal] : nil;
    
    button.KVOController = [FBKVOController controllerWithObserver:button];
    [button.KVOController observe:button keyPaths:@[@"highlighted", @"enabled"] options:0 block:^(id observer, id object, NSDictionary *change) {
        [button setTitleColorForStyle:style forState:button.state];
        [button setBackgroundColorForStyle:style forState:button.state];
    }];
    
    return button;
}

- (void)setTitleColorForStyle:(BZButonStyle)style forState:(UIControlState)state
{
    switch (style) {
        case BZButonStyleDefault:
            [self setTitleColor:[UIColor defaultTitleColor] forState:state];
            break;
            
        default:
            if (UIControlStateDisabled == state) {
                [self setTitleColor:[UIColor defaultTitleColor] forState:state];
            } else {
                [self setTitleColor:[UIColor whiteColor] forState:state];
            }
            break;
    }
}

- (void)setBackgroundColorForStyle:(BZButonStyle)style forState:(UIControlState)state
{
    switch (style) {
        case BZButonStyleDefault:
            if (UIControlStateHighlighted == state) {
                self.backgroundColor = [UIColor defaultButtonHighlightedColor];
            } else if (UIControlStateDisabled == state) {
                self.backgroundColor = [UIColor buttonDisabledColor];
            } else {
                self.backgroundColor = [UIColor defaultButtonNormalColor];
            }
            break;
            
        case BZButonStylePrimary:
            if (UIControlStateHighlighted == state) {
                self.backgroundColor = [UIColor primaryButtonHighlightedColor];
            } else if (UIControlStateDisabled == state) {
                self.backgroundColor = [UIColor buttonDisabledColor];
            } else {
                self.backgroundColor = [UIColor primaryButtonNormalColor];
            }
            break;
            
        case BZButonStyleDestructive:
            if (UIControlStateHighlighted == state) {
                self.backgroundColor = [UIColor destructiveButtonHighlightedColor];
            } else if (UIControlStateDisabled == state) {
                self.backgroundColor = [UIColor buttonDisabledColor];
            } else {
                self.backgroundColor = [UIColor destructiveButtonNormalColor];
            }
            break;
    }
}

+ (instancetype)defaultButtonWithTitle:(NSString *)title
{
    return [self buttonWithStyle:BZButonStyleDefault title:title imageName:@""];
}

+ (instancetype)defaultButtonWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    return [self buttonWithStyle:BZButonStyleDefault title:title imageName:imageName];
}

+ (instancetype)primaryButtonWithTitle:(NSString *)title
{
    return [self buttonWithStyle:BZButonStylePrimary title:title imageName:@""];
}

+ (instancetype)primaryButtonWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    return [self buttonWithStyle:BZButonStylePrimary title:title imageName:imageName];
}

+ (instancetype)destructiveButtonWithTitle:(NSString *)title
{
    return [self buttonWithStyle:BZButonStyleDestructive title:title imageName:@""];
}

+ (instancetype)destructiveButtonWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    return [self buttonWithStyle:BZButonStyleDestructive title:title imageName:imageName];
}

#pragma mark - Custom button with title and image
+ (instancetype)customButtonWithImageName:(NSString *)imageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    
    return button;
}

+ (instancetype)customButtonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selImageName
{
    UIButton *button = [self customButtonWithImageName:imageName];
    [button setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
    
    return button;
}

+ (instancetype)customButtonWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    UIButton *button = [self customButtonWithImageName:imageName];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor defaultTitleColor] forState:UIControlStateNormal];
    [button sizeToFit];
    [button setLayoutStyle:BZLayoutStyleHorizontalImageLeft];
    
    return button;
}

+ (instancetype)customButtonWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selImageName
{
    UIButton *button = [self customButtonWithTitle:title imageName:imageName];
    [button setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
    
    return button;
}

+ (instancetype)customButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor defaultTitleColor] forState:UIControlStateNormal];
    [button sizeToFit];
    
    return button;
}

#pragma mark - System button with title
+ (instancetype)systemButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    
    return button;
}

@end
