//
//  UIBarButtonItem+Factory.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "UIBarButtonItem+Factory.h"

@implementation UIBarButtonItem (Factory)

+ (instancetype)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    return [[self alloc] initWithTitle:title
                                 style:UIBarButtonItemStylePlain
                                target:target
                                action:action];
}

+ (instancetype)barButtonItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    return [[self alloc] initWithImage:[UIImage imageNamed:imageName]
                                 style:UIBarButtonItemStylePlain
                                target:target
                                action:action];
}

+ (instancetype)backBarButtonItem
{
    return [UIBarButtonItem barButtonItemWithTitle:@"" target:nil action:nil];
}

+ (instancetype)flexibleSpaceBarButtonItem
{
    return [[self alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

@end
