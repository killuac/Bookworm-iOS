//
//  UIView+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYViewProtocol <NSObject>

@optional
- (void)addSubviews;
- (void)addSubviews:(NSArray *)subviews;

- (void)addTapGesture;
- (void)removeTapGesture;
- (void)singleTap:(UITapGestureRecognizer *)recognizer;

- (void)addObservers;

@end


@interface UIView (Utility) <SYViewProtocol>

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign, readonly) CGFloat statusBarHeight;
@property (nonatomic, strong, readonly) UIViewController *viewController;

@property (nonatomic, strong, readonly) UITableView *superTableView;
@property (nonatomic, strong, readonly) UICollectionView *superCollectionView;

@property (nonatomic, strong, readonly) UITableViewCell *superTableViewCell;
@property (nonatomic, strong, readonly) UICollectionViewCell *superCollectionViewCell;

@property (nonatomic, strong, readonly) UITableView *subTableView;
@property (nonatomic, strong, readonly) UICollectionView *subCollectionView;

- (void)findAndResignFirstResponder;
- (void)animateSpringScale;

- (void)addBlurBackground;
- (void)removeBlurBackground;

- (void)addEmptyImageViewWithTitle:(NSString *)title;
- (void)removeEmptyImageView;

@end
