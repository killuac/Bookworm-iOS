//
//  SYTipTableViewCell.m
//  Bookworm
//
//  Created by Killua Liu on 1/22/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYTipTableViewCell.h"

@implementation SYTipTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor redColor];
        self.textLabel.font = [UIFont subtitleFont];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.layer.zPosition = 1;
        
        [self addSublayers];
    }
    return self;
}

- (void)addSublayers
{
    //  Add triangle arrow at top
    CGFloat lineWith = 5.0f;
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(SCREEN_CENTER.x - lineWith, 0)];
    [bezier addLineToPoint:CGPointMake(SCREEN_CENTER.x, -lineWith)];
    [bezier addLineToPoint:CGPointMake(SCREEN_CENTER.x + lineWith, 0)];
    [bezier addLineToPoint:CGPointMake(SCREEN_CENTER.x - lineWith, 0)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezier.CGPath;
    layer.fillColor = self.backgroundColor.CGColor;
    [self.contentView.layer addSublayer:layer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = self.contentView.frame;
}

@end
