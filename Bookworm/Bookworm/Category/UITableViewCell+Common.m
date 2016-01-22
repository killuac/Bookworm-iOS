//
//  UITableViewCell+Common.m
//  Bookworm
//
//  Created by Killua Liu on 1/22/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "UITableViewCell+Common.h"

@implementation UITableViewCell (Common)

+ (void)load
{
    SwizzleMethod([self class], @selector(layoutSubviews), @selector(swizzle_layoutSubviews), NO);
}

- (void)swizzle_layoutSubviews
{
    [self swizzle_layoutSubviews];
    
    CGFloat imageWH = self.height - DEFAULT_MARGIN;
    self.imageView.size = CGSizeMake(imageWH, imageWH);
    self.imageView.centerY = self.height / 2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = DEFAULT_CORNER_RADIUS;
}

@end
