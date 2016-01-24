//
//  SYMessageTableViewCell.m
//  Bookworm
//
//  Created by Killua Liu on 1/22/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYMessageTableViewCell.h"

@implementation SYMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.size = CGSizeMake(50, 50);
    _avatarImageView.layer.cornerRadius = _avatarImageView.width / 2;
    [self.contentView addSubview:_avatarImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont titleFont];
    _titleLabel.textColor = [UIColor titleColor];
    [self.contentView addSubview:_titleLabel];
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _subtitleLabel.font = [UIFont subtitleFont];
    _subtitleLabel.textColor = [UIColor subtitleColor];
    [self.contentView addSubview:_subtitleLabel];
    
    _genderIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_genderIconView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.textColor = [UIColor subtitleColor];
    _timeLabel.font = [UIFont defaultFont];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    
    _badgeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _badgeLabel.clipsToBounds = YES;
    _badgeLabel.font = [UIFont defaultFont];
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    _badgeLabel.layer.borderWidth = DEFAULT_BORDER_WIDTH;
    _badgeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _badgeLabel.layer.backgroundColor = [UIColor redColor].CGColor;
    _badgeLabel.size = CGSizeMake(24, 24);
    _badgeLabel.layer.cornerRadius = _badgeLabel.width / 2;
    [self.contentView addSubview:_badgeLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width, margin = 10.0f;
    
    _avatarImageView.origin = CGPointMake(margin, margin);
    
    [_timeLabel sizeToFit];
    _timeLabel.top = margin;
    _timeLabel.right = self.width - _avatarImageView.left;
    
    [_titleLabel sizeToFit];
    width = _timeLabel.left - _avatarImageView.right - (_badgeLabel.width + margin/2) - margin * 2;
    _titleLabel.width = MIN(_timeLabel.width, width);
    _titleLabel.origin = CGPointMake(_avatarImageView.right + margin, _avatarImageView.top);
    
    [_subtitleLabel sizeToFit];
    _subtitleLabel.width = self.width - _avatarImageView.right - margin * 2;
    _subtitleLabel.left = _titleLabel.left;
    _subtitleLabel.bottom = self.height - margin;
    
    _genderIconView.size = _genderIconView.image.size;
    _genderIconView.center = _titleLabel.center;
    _genderIconView.left =  _titleLabel.right + margin / 2;
    
    width = _badgeLabel.width / 2;
    _badgeLabel.origin = CGPointMake(_avatarImageView.right - width, margin / 2);
}

@end
