//
//  SYMainViewController.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYMainViewController.h"

@interface SYMainViewController ()

@end

@implementation SYMainViewController

#pragma mark - Life cycle
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

// If use Interface Builder to create views and initialize the view controller, must not override this method.
// Should not call [super loadView];
- (void)loadView
{
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.scrollView = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    [self addTapGesture];
}

- (void)loadData
{
    
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    UIBarButtonItem *buttonItem = [UIBarButtonItem barButtonItemWithTitle:@"Test" target:nil action:nil];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    toolbar.size = CGSizeMake(SCREEN_WIDTH, 80);
    toolbar.items = @[buttonItem];
    UIAlertController *ac = [UIAlertController actionSheetControllerWithToolbar:toolbar];
    [ac show];
}

- (void)loadData:(SYNoParameterBlockType)completion
{
    
}

#pragma mark - TableView Datasource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_COMMON_CELL];
}

@end
