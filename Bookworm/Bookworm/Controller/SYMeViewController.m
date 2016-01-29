//
//  SYMeViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYMeViewController.h"

@interface SYMeViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYMeViewController

#pragma mark - Life cycle
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

// If use Interface Builder to create views and initialize the view controller, must not override this method.
- (void)loadView
{
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.allowsSelection = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.scrollView = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
}

- (void)loadData
{
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_COMMON_CELL];
}

@end
