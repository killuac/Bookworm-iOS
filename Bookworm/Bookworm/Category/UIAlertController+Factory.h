//
//  UIAlertController+Factory.h
//  Bookworm
//
//  Created by Bing Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Factory)

+ (instancetype)alertControllerWithMessage:(NSString *)message;
+ (instancetype)alertControllerWithMessage:(NSString *)message actions:(NSArray<UIAlertAction *> *)actions;
+ (instancetype)actionSheetControllerWithMessage:(NSString *)message actions:(NSArray<UIAlertAction *> *)actions;

- (void)show;

@end
