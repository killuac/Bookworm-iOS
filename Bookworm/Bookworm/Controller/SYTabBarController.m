//
//  SYTabBarController.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYTabBarController.h"
#import "SYHomeViewController.h"
#import "SYWishViewController.h"
#import "SYMessageViewController.h"
#import "SYMeViewController.h"

@interface SYTabBarController ()

@property (nonatomic, strong) SYHomeViewController *homeVC;
@property (nonatomic, strong) SYWishViewController *wishVC;
@property (nonatomic, strong) SYMessageViewController *messageVC;
@property (nonatomic, strong) SYMeViewController *meVC;

@property (nonatomic, assign) NSUInteger previousSelectedIndex;
@property (nonatomic, strong) NSArray<__kindof UIView *> *tabBarButtons;  // For animation

@end

@implementation SYTabBarController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    [self instantiateServices];
    [self addViewControllers];
    
    [self.tabBar addTapGesture];
    [self.tabBar.gestureRecognizers.lastObject setDelegate:self];
}

- (void)instantiateServices
{
    _userService = [SYUserService service];
    _contactService = [SYContactService service];
}

- (void)addViewControllers
{
    self.homeVC = [[SYHomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:self.homeVC];
    self.homeVC.navigationItem.title = TAB_TITLE_HOME;
    self.homeVC.navigationItem.backBarButtonItem = [UIBarButtonItem backBarButtonItem];
    UIImage *image = [UIImage imageNamed:@"tab_home"];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:TAB_TITLE_HOME image:[image originalImage] selectedImage:image];
    
    self.wishVC = [[SYWishViewController alloc] init];
    UINavigationController *wishNav = [[UINavigationController alloc] initWithRootViewController:self.wishVC];
    self.wishVC.navigationItem.title = TAB_TITLE_WISH;
    self.wishVC.navigationItem.backBarButtonItem = [UIBarButtonItem backBarButtonItem];
    image = [UIImage imageNamed:@"tab_wish"];
    wishNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:TAB_TITLE_WISH image:[image originalImage] selectedImage:image];
    
    self.messageVC = [[SYMessageViewController alloc] init];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:self.messageVC];
    self.messageVC.navigationItem.title = TAB_TITLE_MESSAGE;
    self.messageVC.navigationItem.backBarButtonItem = [UIBarButtonItem backBarButtonItem];
    image = [UIImage imageNamed:@"tab_message"];
    messageNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:TAB_TITLE_MESSAGE image:[image originalImage] selectedImage:image];
    
    self.meVC = [[SYMeViewController alloc] init];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:self.meVC];
    self.meVC.navigationItem.title = TAB_TITLE_ME;
    self.meVC.navigationItem.backBarButtonItem = [UIBarButtonItem backBarButtonItem];
    image = [UIImage imageNamed:@"tab_user"];
    meNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:TAB_TITLE_ME image:[image originalImage] selectedImage:image];
    
    [self setViewControllers:@[homeNav, wishNav, messageNav, meNav] animated:NO];
    
//  Add tab bar buttons to buffer for animation
    if ([NSStringFromClass([self.tabBar.subviews.firstObject class]) isEqualToString:@"UITabBarButton"]) {
        self.tabBarButtons = self.tabBar.subviews;
    }
}

#pragma mark - Gesture recognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *touchedImageView = touch.view.subviews.firstObject;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.8 animations:^{
            touchedImageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:1.0 animations:^{
            touchedImageView.transform = CGAffineTransformIdentity;
        }];
    } completion:nil];
    
    return NO;
}

#pragma mark - Tab bar controller delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([GVUserDefaults standardUserDefaults].isSignedIn) return YES;
    
    if (viewController == self.messageVC || viewController == self.meVC) {
        [self showSignInViewController]; return NO;
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == self.previousSelectedIndex) {
        UIViewController *visibleVC = viewController.visibleViewController;
        if (visibleVC == self.homeVC || visibleVC == self.wishVC) {
            [visibleVC reloadData];
        }
    }
    _previousSelectedIndex = tabBarController.selectedIndex;
}

@end
