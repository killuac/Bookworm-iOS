//
//  UIAlertController+Factory.m
//  Bookworm
//
//  Created by Killua Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "UIAlertController+Factory.h"

@implementation UIAlertController (Factory)

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertAction *okay = [UIAlertAction actionWithTitle:nil style:UIAlertActionStyleDefault handler:nil];
    return [self alertControllerWithTitle:title message:message actions:@[okay]];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray<UIAlertAction*> *)actions
{
    UIAlertController *AC = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        [AC addAction:action];
    }];
    return AC;
}

+ (instancetype)actionSheetControllerWithActions:(NSArray<UIAlertAction*> *)actions
{
    return [self actionSheetControllerWithTitle:nil actions:actions];
}

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title actions:(NSArray<UIAlertAction*> *)actions
{
    UIAlertController *AC = [self alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        [AC addAction:action];
    }];
    return AC;
}

+ (instancetype)actionSheetControllerWithToolbar:(UIToolbar *)toolbar
{
    return [self actionSheetControllerWithTitle:nil toolbar:toolbar];
}

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title toolbar:(UIToolbar *)toolbar
{
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:nil];
    UIAlertController *AC = [UIAlertController actionSheetControllerWithActions:@[cancel]];
    [AC.view.subviews.firstObject setHidden:YES];
    [toolbar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    toolbar.left = -MEDIUM_MARGIN;
    [AC.view addSubview:toolbar];
    return AC;
}

- (void)show
{
    [self.visibleViewController presentViewController:self animated:YES completion:nil];
}

@end
