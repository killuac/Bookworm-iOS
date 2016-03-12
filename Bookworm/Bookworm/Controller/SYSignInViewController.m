//
//  SYSignInViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYSignInViewController.h"

@interface SYSignInViewController ()

@end

@implementation SYSignInViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateNavigationBar];
    [self loadData];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.scrollEnabled = NO;
    self.tableView.allowsSelection = NO;
}

- (void)updateNavigationBar
{
    self.navigationBar.translucent = YES;
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"button_close" target:self action:@selector(close:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:BUTTON_TITLE_SIGNUP target:self action:@selector(flipToSignUpView:)];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldTitleFont], NSForegroundColorAttributeName:[UIColor tintColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

- (void)loadData
{
    
}

#pragma mark - Event handling
- (void)close:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)flipToSignUpView:(UIBarButtonItem *)barButtonItem
{
    
}

@end
