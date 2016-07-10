//
//  UIView+Base.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN const CGFloat SYViewDefaultMargin;
UIKIT_EXTERN const CGFloat SYViewDefaultHeight;
UIKIT_EXTERN const CGFloat SYViewDefaultButtonHeight;
UIKIT_EXTERN const CGFloat SYViewDefaultCornerRadius;
UIKIT_EXTERN const NSTimeInterval SYViewDefaultAnimationDuration;


@protocol SYViewProtocol <NSObject>

@optional
- (void)addSubviews;
- (void)addSubviews:(NSArray *)subviews;
- (void)addConstraints;

- (void)addTapGesture;
- (void)removeTapGesture;
- (void)singleTap:(UITapGestureRecognizer *)recognizer;

- (void)addObservers;

@end


@interface UIView (Base) <SYViewProtocol>

+ (instancetype)newAutoLayoutView;
- (void)constraintsEqualWithSuperView;
- (void)constraintsEqualWidthAndHeight;
- (void)constraintsCenterInSuperview;
- (void)constraintsCenterXWithView:(UIView *)view;
- (void)constraintsCenterYWithView:(UIView *)view;

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign, readonly) CGFloat statusBarHeight;
@property (nonatomic, strong, readonly) UIViewController *viewController;

@property (nonatomic, strong, readonly) UITableView *superTableView;
@property (nonatomic, strong, readonly) UICollectionView *superCollectionView;

@property (nonatomic, strong, readonly) UITableViewCell *superTableViewCell;
@property (nonatomic, strong, readonly) UICollectionViewCell *superCollectionViewCell;

@property (nonatomic, strong, readonly) UITableView *subTableView;
@property (nonatomic, strong, readonly) UICollectionView *subCollectionView;

// Avoid off-screen rendered
- (void)setCornerRadius:(CGFloat)radius;  // by UIRectCornerAllCorners
- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;
- (void)setCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners;
- (void)setCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners borderWidth:(CGFloat)width borderColor:(UIColor *)color;

- (void)findAndResignFirstResponder;

- (void)addBlurBackground;
- (void)removeBlurBackground;

+ (void)animateWithDefaultDuration:(SYVoidBlockType)animations;
+ (void)animateWithDefaultDuration:(SYVoidBlockType)animations completion:(void (^)(BOOL finished))completion;
+ (void)animateSpringWithDefaultDuration:(SYVoidBlockType)animations;
+ (void)animateSpringWithDefaultDuration:(SYVoidBlockType)animations completion:(void (^)(BOOL finished))completion;
- (void)animateSpringScale;

@end
