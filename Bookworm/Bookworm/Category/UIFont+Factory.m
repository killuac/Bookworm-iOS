//
//  UIFont+Factory.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "UIFont+Factory.h"

@implementation UIFont (Factory)

+ (instancetype)defaultFont
{
    return [UIFont systemFontOfSize:12.0f];
}

+ (instancetype)defaultBigFont
{
    return [UIFont systemFontOfSize:20.0f];
}

+ (instancetype)titleFont
{
    return [UIFont systemFontOfSize:17.0f];
}

+ (instancetype)boldTitleFont
{
    return [UIFont boldSystemFontOfSize:[UIFont titleFont].pointSize];
}

+ (instancetype)subtitleFont
{
    return [UIFont systemFontOfSize:14.0f];
}

+ (instancetype)descriptionFont
{
    return [UIFont systemFontOfSize:15.0f];
}

@end
