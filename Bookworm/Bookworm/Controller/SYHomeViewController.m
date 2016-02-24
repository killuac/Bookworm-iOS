//
//  SYHomeViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYHomeViewController.h"

@interface SYHomeViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *books;

@end

@implementation SYHomeViewController

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
    
    [self updateNavigationBar];
    [self addSubviews];
    [self loadData];
//    [self addTapGesture];
    
    UIButton *button = [UIButton primaryButtonWithTitle:@"登录"];
    button.left = 15;
    button.centerY = self.view.centerY;
    button.width = self.view.width - 30;
    [self.view addSubview:button];
}

- (void)updateNavigationBar
{
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"button_category_list" target:self action:@selector(showBookCategoryList:)];
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"button_search" target:self action:@selector(searchInHomeViewController:)];
}

- (void)addSubviews
{
    CGFloat lineSpaing = SMALL_MARGIN;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat WH = (self.view.width - lineSpaing * 2) / 3;
    flowLayout.itemSize = CGSizeMake(WH, WH);
    flowLayout.minimumLineSpacing = lineSpaing;
    flowLayout.minimumInteritemSpacing = lineSpaing;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.scrollView = self.collectionView;
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    UIBarButtonItem *buttonItem = [UIBarButtonItem barButtonItemWithTitle:@"Test" target:nil action:nil];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    toolbar.size = CGSizeMake(SCREEN_WIDTH, 70);
    toolbar.items = @[buttonItem];
    UIAlertController *ac = [UIAlertController actionSheetControllerWithToolbar:toolbar];
    [ac show];
}

- (void)loadData
{
    
}

- (void)reloadData
{
    
}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.books.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UICollectionViewCell alloc] initWithFrame:CGRectZero];
}

#pragma mark - Event handling
- (void)showBookCategoryList:(UIBarButtonItem *)barButtonItem
{
    
}

- (void)searchInHomeViewController:(UIBarButtonItem *)barButtonItem
{
    
}

- (void)exchangeBook:(UIButton *)button
{
    
}

@end
