//
//  UIAlertController+Factory.m
//  Bookworm
//
//  Created by Bing Liu on 1/19/16.
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

+ (instancetype)actionSheetControllerWithMessage:(NSString *)message actions:(NSArray<UIAlertAction *> *)actions
{
    UIAlertController *AC = [self alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (UIAlertAction *action in actions) {
        [AC addAction:action];
    }
    return AC;
}

- (void)show
{
    [self.visibleViewController showViewController:self sender:self.visibleViewController];
}

@end
