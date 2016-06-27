//
//  UIAlertController+Base.m
//  Bookworm
//
//  Created by Killua Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "UIAlertController+Base.h"

@implementation UIAlertController (Base)

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertAction *okay = [UIAlertAction actionWithTitle:BUTTON_TITLE_OKAY style:UIAlertActionStyleCancel handler:nil];
    return [self alertControllerWithTitle:title message:message actions:@[okay]];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray<UIAlertAction *> *)actions
{
    UIAlertController *AC = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        [AC addAction:action];
    }];
    return AC;
}

+ (instancetype)actionSheetControllerWithActions:(NSArray<UIAlertAction *> *)actions
{
    UIAlertController *AC = [self alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        [AC addAction:action];
    }];
    return AC;
}

+ (instancetype)actionSheetControllerWithButtons:(NSArray<UIButton *> *)buttons
{
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *empty = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];
    UIAlertController *AC = [UIAlertController actionSheetControllerWithActions:@[empty, cancel]];
    [AC.view.subviews setValue:@(YES) forKey:@"hidden"];
//    [AC.view.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:(__bridge id)((void *)YES)];
    
    UIView *stackView = [UIView newAutoLayoutView];
    stackView.backgroundColor = [UIColor whiteColor];
    [stackView addSubviews:buttons];
    [AC.view addSubview:stackView];
    
    CGSize buttonSize = [buttons.firstObject size];
    NSDictionary *views = @{ @"stackView": stackView, @"button1": buttons.firstObject, @"button2":buttons.lastObject };
    NSDictionary *metrics = @{ @"margin": @(-10.0), @"buttonHeight": @(buttonSize.height) };
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[stackView]-margin-|" options:0 metrics:metrics views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[stackView(70)]-margin-|" options:0 metrics:metrics views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button1(button2)]-[button2]-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button1(buttonHeight)]" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
    [buttons.firstObject constraintsCenterYWithView:stackView];
    
    return AC;
}

- (void)show
{
    [self.visibleViewController presentViewController:self animated:YES completion:nil];
}

@end
