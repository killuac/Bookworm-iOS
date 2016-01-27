//
//  UILabel+Factory.m
//  Bookworm
//
//  Created by Killua Liu on 1/27/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "UILabel+Factory.h"

@implementation UILabel (Factory)

+ (instancetype)labelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.text = text;
    label.font = [UIFont subtitleFont];
    label.textColor = [UIColor subtitleColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [label sizeToFit];
    
    return label;
}

+ (instancetype)labelWithText:(NSString *)text attributes:(NSDictionary<NSString *, id> *)attributes
{
    UILabel *label = [UILabel labelWithText:text];
    label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    return label;
}

@end
