//
//  UIViewController+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utility) <UITextFieldDelegate>

@property (nonatomic, assign) BOOL isLoadingData;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong, readonly) UIViewController *rootViewController;
@property (nonatomic, strong, readonly) UIViewController *visibleViewController;

@property (nonatomic, assign, readonly) CGFloat statusBarHeight;
@property (nonatomic, assign, readonly) CGFloat navigationBarHeight;
@property (nonatomic, assign, readonly) CGFloat tabBarHeight;

- (void)showInitialViewController;
- (void)showMainViewController;
- (void)showMainViewControllerWithUserInfo:(NSDictionary *)userInfo;

- (void)addTapGesture;
- (void)removeTapGesture;
- (void)singleTap:(UITapGestureRecognizer *)recognizer;

- (void)loadData;
- (void)loadData:(SYNoParameterBlockType)completion;
- (void)reloadData;

- (void)HTTPRequestDidComplete:(NSNotification *)notification;

@end
