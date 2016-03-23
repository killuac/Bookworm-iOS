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
    
    SYStackView *stackView = [[SYStackView alloc] initWithFrame:CGRectZero];
    stackView.backgroundColor = [UIColor whiteColor];
    stackView.size = CGSizeMake(AC.view.width, 80);
    stackView.origin = CGPointMake(-MEDIUM_MARGIN, 52);
    [stackView addSubviews:buttons];
    [AC.view addSubview:stackView];
    
    return AC;
}

- (void)show
{
    [self.visibleViewController presentViewController:self animated:YES completion:nil];
}

@end
