//
//  UIAlertController+Factory.m
//  Bookworm
//
//  Created by Bing Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "UIAlertController+Factory.h"

@implementation UIAlertController (Factory)

+ (instancetype)alertControllerWithMessage:(NSString *)message
{
    UIAlertAction *okay = [UIAlertAction actionWithTitle:nil style:UIAlertActionStyleDefault handler:nil];
    return [self alertControllerWithMessage:message actions:@[okay]];
}

+ (instancetype)alertControllerWithMessage:(NSString *)message actions:(NSArray<UIAlertAction *> *)actions
{
    UIAlertController *AC = [self alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
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
