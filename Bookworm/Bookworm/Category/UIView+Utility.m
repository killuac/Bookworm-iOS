//
//  UIView+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Utility)

- (CGFloat)statusBarHeight
{
    return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

- (id)viewController
{
    for (UIView *view = self.superview; view; view = view.superview) {
        UIResponder* nextResponder = view.nextResponder;
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return nextResponder;
        }
    }
    
    return nil;
}

#pragma mark - Left/Right/Top/Bottom
- (CGFloat)left
{
    return CGRectGetMinX(self.frame);
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.left + self.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.width;
    self.frame = frame;
}

- (CGFloat)top
{
    return CGRectGetMinY(self.frame);
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.top + self.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.height;
    self.frame = frame;
}

#pragma mark - Center
- (CGFloat)centerX
{
    return CGRectGetMidX(self.frame);
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return CGRectGetMidY(self.frame);
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

#pragma mark - Width/Height
- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark - Orgin/Size
- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

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

#pragma mark - Animation
- (void)animateSpringScale
{
    CGFloat duration = [CATransaction animationDuration];
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }];
    
    [UIView animateWithDuration:duration delay:duration usingSpringWithDamping:0.5 initialSpringVelocity:10 options:0 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
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
