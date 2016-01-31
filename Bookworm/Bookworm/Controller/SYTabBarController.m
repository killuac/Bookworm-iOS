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

@property (nonatomic, strong) NSMutableArray *tabBarButtons;

@end

@implementation SYTabBarController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addViewControllers];
}

- (void)addViewControllers
{
    self.homeVC = [[SYHomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:self.homeVC];
    self.homeVC.navigationItem.title = TAB_TITLE_HOME;
    self.homeVC.navigationItem.backBarButtonItem = [UIBarButtonItem backBarButtonItem];
    UIImage *image = [UIImage imageNamed:@"button_qq_selected"];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:TAB_TITLE_HOME image:image tag:10];
    
    self.wishVC = [[SYWishViewController alloc] init];
    UINavigationController *wishNav = [[UINavigationController alloc] initWithRootViewController:self.wishVC];
    self.wishVC.navigationItem.title = TAB_TITLE_WISH;
    self.wishVC.navigationItem.backBarButtonItem = [UIBarButtonItem backBarButtonItem];
    image = [UIImage imageNamed:@"tab_wish_normal"];
    wishNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:TAB_TITLE_WISH image:image tag:2];
    
    self.messageVC = [[SYMessageViewController alloc] init];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:self.messageVC];
    self.messageVC.navigationItem.title = TAB_TITLE_MESSAGE;
    self.messageVC.navigationItem.backBarButtonItem = [UIBarButtonItem backBarButtonItem];
    image = [UIImage imageNamed:@"tab_message_normal"];
    messageNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:TAB_TITLE_MESSAGE image:image tag:3];
    
    self.meVC = [[SYMeViewController alloc] init];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:self.meVC];
    self.meVC.navigationItem.title = TAB_TITLE_ME;
    self.meVC.navigationItem.backBarButtonItem = [UIBarButtonItem backBarButtonItem];
    image = [UIImage imageNamed:@"tab_user_normal"];
    meNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:TAB_TITLE_ME image:image tag:4];
    
    [self setViewControllers:@[homeNav, wishNav, messageNav, meNav] animated:NO];
    
//  Add tab bar buttons to buffer for animation
    self.tabBarButtons = [NSMutableArray array];
    [self.tabBarButtons addObjectsFromArray:self.tabBar.subviews];
    
    NSLog(@"%@", [self.tabBarButtons.firstObject subviews]);
}



@end
