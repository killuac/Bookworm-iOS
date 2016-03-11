//
//  UISwitch+Factory.m
//  Bookworm
//
//  Created by Killua Liu on 12/31/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "UISwitch+Factory.h"

@implementation UISwitch (Factory)

+ (instancetype)customSwitch
{
    UISwitch *switchButton = [[UISwitch alloc] init];
    switchButton.onTintColor = [UIColor primaryColor];
    return switchButton;
}

- (void)addTarget:(nullable id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}

@end
