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
