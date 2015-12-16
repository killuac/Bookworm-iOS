//
//  UIViewController+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utility) <UITextFieldDelegate>

@property (nonatomic, strong, readonly) UIViewController *rootViewController;
@property (nonatomic, strong, readonly) UIViewController *visibleViewController;

@property (nonatomic, assign, readonly) CGFloat statusBarHeight;
@property (nonatomic, assign, readonly) CGFloat navigationBarHeight;
@property (nonatomic, assign, readonly) CGFloat tabBarHeight;

- (void)addTapGesture;
- (void)removeTapGesture;
- (void)tapGesture:(UITapGestureRecognizer *)recognizer;

- (void)showInitialViewController;
- (void)showMainViewController;
- (void)showMainViewControllerWithUserInfo:(NSDictionary *)userInfo;

- (void)addBlurBackground;
- (void)removeBlurBackground;

- (void)addEmptyImageViewWithTitle:(NSString *)title;
- (void)removeEmptyImageView;

- (void)loadData;
- (void)loadData:(SYNoParameterBlockType)completion;
- (void)reloadData;

- (void)httpRequestFailed:(NSNotification *)notification;

@end
