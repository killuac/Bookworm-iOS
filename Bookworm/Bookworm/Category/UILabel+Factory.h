//
//  UILabel+Factory.h
//  Bookworm
//
//  Created by Killua Liu on 1/27/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Factory)

+ (instancetype)labelWithText:(NSString *)text;
+ (instancetype)labelWithText:(NSString *)text attributes:(NSDictionary<NSString *, id> *)attributes;

@end
