//
//  UIAlertController+Factory.h
//  Bookworm
//
//  Created by Killua Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Factory)

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray<UIAlertAction *> *)actions;

+ (instancetype)actionSheetControllerWithActions:(NSArray<UIAlertAction *> *)actions;
+ (instancetype)actionSheetControllerWithTitle:(NSString *)title actions:(NSArray<UIAlertAction *> *)actions;

+ (instancetype)actionSheetControllerWithToolbar:(UIToolbar *)toolbar;
+ (instancetype)actionSheetControllerWithTitle:(NSString *)title toolbar:(UIToolbar *)toolbar;

- (void)show;

@end
