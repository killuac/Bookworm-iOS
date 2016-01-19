//
//  UIAlertController+Factory.h
//  Bookworm
//
//  Created by Bing Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Factory)

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;
+ (instancetype)actionSheetControllerWithTitle:(NSString *)title message:(NSString *)message;

- (void)show;

@end
