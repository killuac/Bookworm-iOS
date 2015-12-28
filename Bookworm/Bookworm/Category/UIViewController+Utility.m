//
//  UIViewController+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "UIViewController+Utility.h"

@implementation UIViewController (Utility)

- (UIViewController *)rootViewController
{
    return [[UIApplication sharedApplication].delegate window].rootViewController;
}

- (UIViewController *)visibleViewController
{
    id rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        rootVC = [rootVC selectedViewController];
    }
    
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return [rootVC visibleViewController];
    } else {
        return [rootVC presentedViewController];
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)removeTapGesture
{
    [self.view removeGestureRecognizer:self.view.gestureRecognizers.firstObject];
}

- (void)tapGesture:(UITapGestureRecognizer *)recognizer
{
	[self.view findAndResignFirstResponder];
}

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
    for (id subView in view.subviews) {
        if (![subView isKindOfClass:[UITextField class]]) {
            [self addTextFieldInView:subView ToArray:array];
        } else {
            [array insertObject:subView atIndex:0];
        }
    }
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

#pragma mark - Blur background view
- (void)addBlurBackground
{
    [self removeBlurBackground];
    
    UIGraphicsBeginImageContextWithOptions(self.view.size, NO, SCREEN_SCALE);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageView *blurBackground = [[UIImageView alloc] initWithImage:image];
    blurBackground.tag = 100;
    blurBackground.userInteractionEnabled = YES;
    [blurBackground blurImage];
    [self.view addSubview:blurBackground];
}

- (void)removeBlurBackground
{
    [[self.view viewWithTag:100] removeFromSuperview];
}

#pragma mark - Empty image view
- (void)addEmptyImageViewWithTitle:(NSString *)title
{
    [self removeEmptyImageView];
    
    UIImageView *emptyImageView = [[UIImageView alloc] initWithImage:IMG_EMPTY];
    emptyImageView.tag = 200;
    emptyImageView.center = self.view.center;
    emptyImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = 201;
    titleLabel.text = title;
    titleLabel.font = [UIFont subtitleFont];
    titleLabel.textColor = [UIColor defaultSubtitleColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    titleLabel.width = self.view.width - DEFAULT_MARGIN * 2;
    titleLabel.top = emptyImageView.bottom + DEFAULT_MARGIN;
    
    if ([self.view subTableView]) {
        [[self.view subTableView] addSubview:emptyImageView];
        [[self.view subTableView] addSubview:titleLabel];
    } else {
        [self.view addSubview:emptyImageView];
        [self.view addSubview:titleLabel];
    }
}

- (void)removeEmptyImageView
{
    [[self.view viewWithTag:200] removeFromSuperview];
    [[self.view viewWithTag:201] removeFromSuperview];
}

#pragma mark - Abstract method
- (void)loadData
{
//  Implemented by subclass
}

- (void)loadData:(SYNoParameterBlockType)completion
{
//  Implemented by subclass
}

- (void)reloadData
{
//  Implemented by subclass
}

- (void)httpRequestFailed:(NSNotification *)notification
{
//  Implemented by subclass
}

@end
