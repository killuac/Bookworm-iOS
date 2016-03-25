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
    SYSwizzleMethod([self class], @selector(layoutSubviews), @selector(swizzle_layoutSubviews), NO);
    SYSwizzleMethod([self class], @selector(initWithStyle:reuseIdentifier:), @selector(swizzle_initWithStyle:reuseIdentifier:), NO);
}

- (instancetype)swizzle_initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    UITableViewCell *cell = [self swizzle_initWithStyle:style reuseIdentifier:reuseIdentifier];
    cell.textLabel.font = [UIFont titleFont];
    cell.textLabel.textColor = [UIColor titleColor];
    cell.detailTextLabel.font = [UIFont titleFont];
    cell.detailTextLabel.textColor = [UIColor subtitleColor];
    
    return cell;
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
