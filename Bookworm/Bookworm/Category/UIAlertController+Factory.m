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

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray<UIAlertAction *> *)actions
{
    UIAlertController *AC = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (UIAlertAction *action in actions) {
        [AC addAction:action];
    }
    return AC;
}

+ (instancetype)actionSheetControllerWithActions:(NSArray<UIAlertAction *> *)actions
{
    return [self actionSheetControllerWithTitle:nil actions:actions];
}

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title actions:(NSArray<UIAlertAction *> *)actions
{
    UIAlertController *AC = [self alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (UIAlertAction *action in actions) {
        [AC addAction:action];
    }
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
    [AC.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    toolbar.clipsToBounds = YES;
    toolbar.left = -(toolbar.width / 2);
    toolbar.bottom = MEDIUM_MARGIN;
    [AC.view setNeedsLayout];
    [AC.view addSubview:toolbar];
    return AC;
}

- (void)viewDidLayoutSubviews
{
    
}

- (void)show
{
    [self.visibleViewController showViewController:self sender:self.visibleViewController];
}

@end
