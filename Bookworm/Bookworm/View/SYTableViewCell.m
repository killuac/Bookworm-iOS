//
//  SYTableViewCell.m
//  Bookworm
//
//  Created by Killua Liu on 6/26/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYTableViewCell.h"

@implementation SYTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addConstraints];
    }
    return self;
}

- (void)addConstraints
{
    NSDictionary *views = @{ @"imageView": self.imageView };
    NSDictionary *metrics = @{ @"hMargin": @(SYViewDefaultMargin), @"vMargin": @(SYViewDefaultMargin/2) };
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hMargin-[imageView]" options:0 metrics:metrics views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vMargin-[imageView]-vMargin-|" options:0 metrics:metrics views:views]];
    [self.imageView constraintsEqualWidthAndHeight];
}

@end
