//
//  SYMeViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYMeViewController.h"

@interface SYMeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SYMeViewController

#pragma mark - Life cycle
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateNavigationBar];
    [self addSubviews];
    [self loadData];
}

- (void)updateNavigationBar
{
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"button_setting" target:self action:@selector(settings:)];
}

- (void)addSubviews
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.allowsSelection = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.scrollView = self.tableView;
}

- (void)loadData
{
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL_IDENTIFIER_COMMON];
    cell.imageView.image = [UIImage imageNamed:@"icon_history"];
    cell.textLabel.textColor = [UIColor titleColor];
    cell.textLabel.text = @"昵称";
    cell.detailTextLabel.textColor = [UIColor subtitleColor];
    cell.detailTextLabel.text = @"云中行走";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    cell.imageView.size = cell.imageView.image.size;
    cell.imageView.centerY = cell.contentView.centerY;
}

#pragma mark - Event handling
- (void)settings:(UIBarButtonItem *)barButtonItem
{
    
}

@end
