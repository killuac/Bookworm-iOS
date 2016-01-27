//
//  UIFont+Factory.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Factory)

+ (instancetype)defaultFont;
+ (instancetype)defaultBigFont;
+ (instancetype)titleFont;
+ (instancetype)boldTitleFont;
+ (instancetype)subtitleFont;
+ (instancetype)descriptionFont;

@end
