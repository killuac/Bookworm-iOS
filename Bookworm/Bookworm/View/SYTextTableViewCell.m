//
//  SYTextTableViewCell.m
//  Bookworm
//
//  Created by Killua Liu on 1/22/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYTextTableViewCell.h"
#import "SYTipTableViewCell.h"

@interface SYTextTableViewCell ()

@property (nonatomic, strong) UIImageView *tipIconView;

@end

@implementation SYTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.separatorInset = UIEdgeInsetsMake(0, DEFAULT_MARGIN*2+IMAGE_WH, 0, 0);
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
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_textField];
    
    _textView = [[SYTextView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_textView];
    
    _tipIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _tipIconView.alpha = 0;
    self.accessoryView = _tipIconView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x, width, margin = DEFAULT_MARGIN;
    
    if (self.textLabel.text.length) {
        self.separatorInset = UIEdgeInsetsZero;
    }
    
    self.imageView.size = CGSizeMake(24, 24);
    self.imageView.center = CGPointMake(self.imageView.center.x, self.height/2);
    self.imageView.contentMode = UIViewContentModeCenter;
    
    [self.textLabel sizeToFit];
    self.textLabel.center = self.center;
    self.textLabel.left = (self.imageView.image) ? self.imageView.width + margin * 2 : margin;
    
    if (_textField.placeholder.length) {
        x = margin;
        if (self.imageView.image) x += self.imageView.width + margin;
        if (self.textLabel.text.length) x += self.textLabel.width + margin;
        width = self.tipIconView.left - x - margin;
        _textField.frame = CGRectMake(x, 0, width, self.height);
    } else {
        _textView.frame = self.contentView.frame;
    }
    
    self.accessoryView.alpha = 0;
    self.accessoryView.left = self.width;
}

- (void)showSuccess
{
    _tipIconView.image = [UIImage imageNamed:@"icon_success"];
    [self showTip];
}

- (void)showErrorWithText:(NSString *)text
{
    [self setTipWithImageName:@"icon_error" text:text];
    [self showTip];
}

- (void)showWarningWithText:(NSString *)text
{
    [self setTipWithImageName:@"icon_warning" text:text];
    [self showTip];
}

- (void)setTipWithImageName:(NSString *)imageName text:(NSString *)text
{
    NSIndexPath *indexPath = [self.superTableView indexPathForCell:self];
    indexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    SYTipTableViewCell *tipCell = [self.superTableView cellForRowAtIndexPath:indexPath];
    if (!tipCell) [self.superTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    tipCell.textLabel.text = text;
    
    self.transform = CGAffineTransformMakeTranslation(10.0f, 0);
    [UIView animateWithDuration:1.0f
                          delay:0.0f
         usingSpringWithDamping:0.2f
          initialSpringVelocity:10.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}

- (void)showTip
{
    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
        self.accessoryView.transform = CGAffineTransformMakeTranslation(-(_tipIconView.width + DEFAULT_MARGIN), 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
            _tipIconView.alpha = 1;
        }];
    }];
}

- (void)dismissTip
{
    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
        self.accessoryView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        _tipIconView.image = nil;
        _tipIconView.alpha = 0;
    }];
    
    NSIndexPath *indexPath = [self.superTableView indexPathForCell:self];
    indexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    SYTipTableViewCell *tipCell = [self.superTableView cellForRowAtIndexPath:indexPath];
    if (tipCell) [self.superTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
