//
//  UIViewController+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "UIViewController+Utility.h"

@implementation UIViewController (Utility)

#pragma mark - Properties
- (void)setIsLoadingData:(BOOL)isLoadingData
{
    objc_setAssociatedObject(self, @selector(isLoadingData), @(isLoadingData), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isLoadingData
{
    return [objc_getAssociatedObject(self, @selector(isLoadingData)) boolValue];
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath
{
    objc_setAssociatedObject(self, @selector(selectedIndexPath), selectedIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)selectedIndexPath
{
    return objc_getAssociatedObject(self, @selector(selectedIndexPath));
}

#pragma mark - Service properties
- (id)tabBarController
{
    id tabBarVC = self.tabBarController ? self.tabBarController : self.presentingViewController.tabBarController;
#ifdef DEBUG
    NSLog(@"SERVICE IS NIL ERROR");
#endif
    return tabBarVC;
}

- (NSString *)userID
{
    return self.userService.userID;
}

- (SYUserService *)userService
{
    return [[self tabBarController] userService];
}

- (SYMessageService *)messageService
{
    return [[self tabBarController] messageService];
}

- (SYContactService *)contactService
{
    return [[self tabBarController] contactService];
}

#pragma mark - Readonly properties
- (UITabBar *)tabBar
{
    return self.tabBarController.tabBar;
}

- (UINavigationBar *)navigationBar
{
    return self.navigationController.navigationBar;
}

- (UIViewController *)rootViewController
{
    return [[UIApplication sharedApplication].delegate window].rootViewController;
}

- (UIViewController *)visibleViewController
{
    id rootVC = self.rootViewController;
    
    if ([rootVC presentedViewController]) {
        return [self presentedViewControllerFromViewController:rootVC];
    } else {
        if ([rootVC isKindOfClass:[UITabBarController class]]) {
            rootVC = [rootVC selectedViewController];
        }
        
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            return [rootVC visibleViewController];
        } else {
            return ([rootVC presentedViewController] ? [rootVC presentedViewController] : rootVC);
        }
    }
}

- (UIViewController *)presentedViewControllerFromViewController:(UIViewController *)viewController
{
    UIViewController *presentedViewController = [viewController presentedViewController];
    if ([presentedViewController presentedViewController]) {
        return [self presentedViewControllerFromViewController:presentedViewController];
    } else {
        if ([presentedViewController isKindOfClass:[UINavigationController class]]) {
            return presentedViewController.visibleViewController;
        } else {
            return presentedViewController;
        }
    }
}

- (CGFloat)statusBarHeight
{
    return self.view.statusBarHeight;
}

- (CGFloat)navigationBarHeight
{
    return self.navigationController.navigationBar.height;
}

- (CGFloat)tabBarHeight
{
    return self.tabBarController.tabBar.height;
}

#pragma mark - Gesture
- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)removeTapGesture
{
    [self.view removeGestureRecognizer:self.view.gestureRecognizers.firstObject];
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    [self.view findAndResignFirstResponder];
}

#pragma mark - Text field handling
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSArray *textFieldArray = [self allTextFields];
    NSUInteger idx = [textFieldArray indexOfObject:textField];
    
    if (idx+1 == textFieldArray.count) {
        [textField resignFirstResponder];
    } else {
        UIView *nextTextField = textFieldArray[idx+1];
        [nextTextField becomeFirstResponder];
    }
    
    return YES;
}

- (NSArray *)allTextFields
{
    NSMutableArray *array = [NSMutableArray array];
    [self addTextFieldInView:self.view ToArray:array];
    return array;
}

- (void)addTextFieldInView:(UIView *)view ToArray:(NSMutableArray *)array
{
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView *subView, NSUInteger idx, BOOL *stop) {
        if (![subView isKindOfClass:[UITextField class]]) {
            [self addTextFieldInView:subView ToArray:array];
        } else {
            [array insertObject:subView atIndex:0];
        }
    }];
}

#pragma mark - Show view controller
- (void)showInitialViewController
{
//    UIViewController *VC = [[SYInitialViewController alloc] init];
//    UIWindow *window = [[UIApplication sharedApplication].delegate window];
//    window.rootViewController = VC;
//    [window makeKeyAndVisible];
}

- (void)showMainViewController
{
    [self showMainViewControllerWithUserInfo:nil];
}

- (void)showMainViewControllerWithUserInfo:(NSDictionary *)userInfo
{
//    UITabBarController *VC = [[SYTabBarController alloc] init];
//    if (userInfo) VC.selectedViewController = VC.viewControllers[3];
//    
//    UIWindow *window = [[UIApplication sharedApplication].delegate window];
//    window.rootViewController = VC;
//    [window makeKeyAndVisible];
//    
//    window.transform = CGAffineTransformMakeScale(0.9, 0.9);
//    [UIView animateWithDuration:1.0
//                          delay:0.0
//         usingSpringWithDamping:0.5
//          initialSpringVelocity:10
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         window.transform = CGAffineTransformIdentity;
//                     }
//                     completion:nil];
}

#pragma mark - Utility methods
- (void)loadData
{
    self.isLoadingData = YES;
    [self performSelector:@selector(showLoading) withObject:nil afterDelay:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(HTTPRequestDidComplete:)
                                                 name:AFNetworkingTaskDidCompleteNotification
                                               object:nil];
}

- (void)showLoading
{
    [SVProgressHUD show];
}

- (void)HTTPRequestDidComplete:(NSNotification *)notification
{
    self.isLoadingData = NO;
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(showLoading) object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingTaskDidCompleteNotification object:nil];
}

@end
