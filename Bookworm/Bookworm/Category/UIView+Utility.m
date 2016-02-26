//
//  UIView+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Utility)

#pragma mark - Super and sub view
- (id)superTableView
{
    if ([self.superview isKindOfClass:[UITableView class]]) {
        return self.superview;
    } else {
        return [self.superview superTableView];
    }
}

- (id)superCollectionView
{
    if ([self.superview isKindOfClass:[UICollectionView class]]) {
        return self.superview;
    } else {
        return [self.superview superCollectionView];
    }
}

- (id)superTableViewCell
{
    if ([self.superview isKindOfClass:[UITableViewCell class]]) {
        return self.superview;
    } else {
        return [self.superview superTableViewCell];
    }
}

- (id)superCollectionViewCell
{
    if ([self.superview isKindOfClass:[UICollectionViewCell class]]) {
        return self.superview;
    } else {
        return [self.superview superCollectionViewCell];
    }
}

- (id)subTableView
{
    id resultView = nil;
    for (id subview in self.subviews) {
        if ([subview isKindOfClass:[UITableView class]]) {
            resultView = subview;
        } else {
            resultView = [subview subTableView];
        }
    }
    return resultView;
}

- (id)subCollectionView
{
    id resultView = nil;
    for (id subview in self.subviews) {
        if ([subview isKindOfClass:[UICollectionView class]]) {
            resultView = subview;
        } else if ([subview subviews].count > 0) {
            resultView = [subview subCollectionView];
        }
    }
    return resultView;
}

#pragma mark - Gesture
- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap];
}

- (void)removeTapGesture
{
    [self removeGestureRecognizer:self.gestureRecognizers.firstObject];
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    [self findAndResignFirstResponder];
}

- (void)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return;
    }
    
    if (self.subviews.count != 0) {
        for (UIView *subView in self.subviews) {
            [subView findAndResignFirstResponder];
        }
    } else {
        return;
    }
}

#pragma mark - Blur background view
- (void)addBlurBackground
{
    [self removeBlurBackground];
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 1);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *blurBackground = [[UIImageView alloc] initWithImage:[image gaussianBlurWithBias:20]];
    blurBackground.tag = 100;
    blurBackground.userInteractionEnabled = YES;
    [self addSubview:blurBackground];
}

- (void)removeBlurBackground
{
    [[self viewWithTag:100] removeFromSuperview];
}

#pragma mark - Empty image view
- (void)addEmptyImageViewWithTitle:(NSString *)title
{
    [self removeEmptyImageView];
    
    UIImageView *emptyImageView = [[UIImageView alloc] initWithImage:IMG_EMPTY];
    emptyImageView.tag = 200;
    emptyImageView.center = self.center;
    if ([self respondsToSelector:@selector(contentOffset)]) {
        emptyImageView.centerY += [(id)self contentOffset].y;
    }
    emptyImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:emptyImageView];
    
    if (title.length) {
        UILabel *titleLabel = [UILabel labelWithText:title];
        titleLabel.tag = 201;
        titleLabel.width = self.width - DEFAULT_MARGIN * 2;
        titleLabel.center = self.center;
        titleLabel.top = emptyImageView.bottom + DEFAULT_MARGIN;
        [self addSubview:titleLabel];
    }
}

- (void)removeEmptyImageView
{
    [[self viewWithTag:200] removeFromSuperview];
    [[self viewWithTag:201] removeFromSuperview];
}

@end
