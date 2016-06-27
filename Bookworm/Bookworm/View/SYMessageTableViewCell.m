//
//  SYMessageTableViewCell.m
//  Bookworm
//
//  Created by Killua Liu on 1/22/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYMessageTableViewCell.h"

@interface SYMessageTableViewCell ()

@property (nonatomic, strong) NSLayoutConstraint *sendingMarkConstraint;
@property (nonatomic, assign) CGFloat badgeLabelHeight;

@end

@implementation SYMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
        [self addConstraints];
    }
    return self;
}

- (void)addSubviews
{
    _avatarImageView = [UIImageView newAutoLayoutView];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_avatarImageView];
    
    _titleLabel = [UILabel newAutoLayoutView];
    _titleLabel.font = [UIFont titleFont];
    _titleLabel.textColor = [UIColor titleColor];
    _titleLabel.backgroundColor = self.backgroundColor;
    _titleLabel.clipsToBounds = YES;
    [self.contentView addSubview:_titleLabel];
    
    _genderIconView = [UIImageView newAutoLayoutView];
    _genderIconView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_genderIconView];
    
    _sendingMark = [UIImageView newAutoLayoutView];
    _sendingMark.hidden = YES;
    _sendingMark.image = [UIImage imageNamed:@"icon_sending_mark"];
    _sendingMark.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:_sendingMark];
    
    _subtitleLabel = [UILabel newAutoLayoutView];
    _subtitleLabel.font = [UIFont subtitleFont];
    _subtitleLabel.textColor = [UIColor subtitleColor];
    _subtitleLabel.backgroundColor = self.backgroundColor;
    _subtitleLabel.clipsToBounds = YES;
    [self.contentView addSubview:_subtitleLabel];
    
    _timeLabel = [UILabel newAutoLayoutView];
    _timeLabel.textColor = [UIColor subtitleColor];
    _timeLabel.font = [UIFont defaultFont];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.backgroundColor = self.backgroundColor;
    _timeLabel.clipsToBounds = YES;
    [self.contentView addSubview:_timeLabel];
    
    _badgeLabel = [UILabel newAutoLayoutView];
    _badgeLabel.text = @""; // For get font height
    _badgeLabel.font = [UIFont defaultFont];
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    _badgeLabelHeight = _badgeLabel.fontHeight + 5;
    _badgeLabel.layer.cornerRadius = _badgeLabelHeight / 2;
    _badgeLabel.layer.backgroundColor = [UIColor redColor].CGColor;
    [self.contentView addSubview:_badgeLabel];
}

- (void)addConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_avatarImageView, _titleLabel, _genderIconView, _sendingMark, _subtitleLabel, _timeLabel, _badgeLabel);
    NSDictionary *metrics = @{ @"margin": @(10.0), @"badgeWidth": @(_badgeLabelHeight) };
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_avatarImageView]" options:0 metrics:metrics views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_avatarImageView]-margin-|" options:0 metrics:metrics views:views]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_avatarImageView]-margin-[_titleLabel]-0-[_genderIconView]-margin-[_timeLabel]-margin-|" options:NSLayoutFormatAlignAllTop metrics:metrics views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_titleLabel]" options:0 metrics:metrics views:views]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_avatarImageView]-margin-[_sendingMark(20@900)]-0-[_subtitleLabel]-margin-[_badgeLabel(badgeWidth)]-margin-|" options:0 metrics:metrics views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]->=2-[_subtitleLabel]-margin-|" options:0 metrics:metrics views:views]];
    
    _sendingMarkConstraint = [NSLayoutConstraint constraintWidthWithItem:_sendingMark constant:0];
    self.sendingMarkConstraint.priority = 999;
    [NSLayoutConstraint activateConstraints:@[_sendingMarkConstraint]];
    
    [_avatarImageView constraintsEqualWidthAndHeight];
    [_genderIconView constraintsEqualWidthAndHeight];
    [_badgeLabel constraintsEqualWidthAndHeight];
    [_genderIconView constraintsCenterYWithView:_titleLabel];
    [_sendingMark constraintsCenterYWithView:_subtitleLabel];
    [_badgeLabel constraintsCenterYWithView:_subtitleLabel];
    
    [_titleLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [_genderIconView setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    [_timeLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)showSendingMark
{
    self.sendingMark.hidden = NO;
    self.sendingMarkConstraint.priority = UILayoutPriorityDefaultLow;
}

- (void)hideSendingMark
{
    self.sendingMark.hidden = YES;
    self.sendingMarkConstraint.priority = 999;
}

@end
