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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSubviews];
    [self loadData];
}

- (void)addSubviews
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.allowsSelection = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.view = self.tableView;
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
