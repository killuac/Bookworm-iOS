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
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray<UIAlertAction*> *)actions;

+ (instancetype)actionSheetControllerWithActions:(NSArray<UIAlertAction*> *)actions;
+ (instancetype)actionSheetControllerWithButtons:(NSArray<UIButton*> *)buttons;
//+ (instancetype)actionSheetControllerWithButtonCollection:(NSArray<UIButton*> *)buttons;    // Add buttons to collection view

- (void)show;

@end
