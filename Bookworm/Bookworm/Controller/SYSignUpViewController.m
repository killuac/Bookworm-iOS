//
//  SYSignUpViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYSignUpViewController.h"

@interface SYSignUpViewController ()

@end

@implementation SYSignUpViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)updateNavigationBar
{
    [super updateNavigationBar];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:BUTTON_TITLE_SIGNIN target:self action:@selector(flipToSignInView:)];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldTitleFont]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

#pragma mark - Event handling
- (void)flipToSignInView:(UIBarButtonItem *)barButtonItem
{
    
}

@end
