//
//  UIViewController+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYTabBarController.h"

@protocol SYViewControllerProtocol <SYViewProtocol>

@optional
- (void)loadData;
- (void)loadData:(SYNoParameterBlockType)completion;
- (void)reloadData;
- (void)refreshUI;

@end


@interface UIViewController (Utility) <SYViewControllerProtocol, UITextFieldDelegate>

@property (nonatomic, assign) BOOL isLoadingData;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong ,readonly) NSString *userID;
@property (nonatomic, strong, readonly) SYUserService *userService;
@property (nonatomic, strong, readonly) SYMessageService *messageService;
@property (nonatomic, strong, readonly) SYContactService *contactService;

@property (nonatomic, strong, readonly) UITabBar *tabBar;
@property (nonatomic, strong, readonly) UINavigationBar *navigationBar;
@property (nonatomic, strong, readonly) UIViewController *rootViewController;
@property (nonatomic, strong, readonly) UIViewController *visibleViewController;

@property (nonatomic, assign, readonly) CGFloat statusBarHeight;
@property (nonatomic, assign, readonly) CGFloat navigationBarHeight;
@property (nonatomic, assign, readonly) CGFloat tabBarHeight;

- (void)showInitialViewController;
- (void)showMainViewController;
- (void)showMainViewControllerWithUserInfo:(NSDictionary *)userInfo;

- (void)HTTPRequestDidComplete:(NSNotification *)notification;

@end
