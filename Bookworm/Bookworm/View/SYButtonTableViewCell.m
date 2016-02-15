//
//  SYButtonTableViewCell.m
//  Bookworm
//
//  Created by Killua Liu on 1/22/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYButtonTableViewCell.h"

@implementation SYButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubviews];
    }
    return self;
}

- (void)addSubview:(UIView *)view
{
    // Don't add separator line
    if (view.height > 0.5) {
        [super addSubview:view];
    }
}

- (void)addSubviews
{
    _normalButton = [UIButton primaryButtonWithTitle:nil];
    [self.contentView addSubview:_normalButton];
    
    _topLinkButton = [UIButton linkButtonWithTitle:nil];
    [self.contentView addSubview:_topLinkButton];
    
    _bottomLinkButton = [UIButton linkButtonWithTitle:nil];
    [self.contentView addSubview:_bottomLinkButton];
    
    _leftLinkButton = [UIButton linkButtonWithTitle:nil];
    [self.contentView addSubview:_leftLinkButton];
    
    _rightLinkButton = [UIButton linkButtonWithTitle:nil];
    [self.contentView addSubview:_rightLinkButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _normalButton.center = self.center;
    _normalButton.size = CGSizeMake(self.width - 2*DEFAULT_MARGIN, DEFAULT_BUTTON_HEIGHT);
    
    _topLinkButton.centerX = self.centerX;
    _topLinkButton.centerY = (self.height - _normalButton.height) / 4;
    
    _bottomLinkButton.centerX = self.centerX;
    _bottomLinkButton.bottom = _normalButton.height + _topLinkButton.centerY;
    
    _leftLinkButton.origin = CGPointMake(_normalButton.left, _normalButton.bottom);
    _rightLinkButton.origin = CGPointMake(_normalButton.left, _normalButton.right - _rightLinkButton.width);
}

@end
