//
//  SYHomeViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYHomeViewController.h"
#import "SYSignInViewController.h"

@interface SYHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *books;

@end

@implementation SYHomeViewController

#pragma mark - Life cycle
- (instancetype)init
{
    if (self = [super init]) {
        _books = [NSMutableArray array];
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
    [self prepareForUI];
    [self loadData];
    
    [self addTapGesture];
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    UIButton *wechat = [UIButton buttonWithTitle:BUTTON_TITLE_WECHAT imageName:@"button_wechat" layout:SYButtonLayoutVerticalImageUp];
    UIButton *moments = [UIButton buttonWithTitle:BUTTON_TITLE_WECHAT_MOMENTS imageName:@"button_wechat_moments" layout:SYButtonLayoutVerticalImageUp];
    UIButton *qq = [UIButton buttonWithTitle:BUTTON_TITLE_QQ imageName:@"button_qq" layout:SYButtonLayoutVerticalImageUp];
    UIButton *weibo = [UIButton buttonWithTitle:BUTTON_TITLE_WEIBO imageName:@"button_weibo" layout:SYButtonLayoutVerticalImageUp];
//    UIButton *qzone = [UIButton buttonWithTitle:BUTTON_TITLE_QZONE imageName:@"button_qzone" layout:SYButtonLayoutVerticalImageUp];
//    UIButton *douban = [UIButton buttonWithTitle:BUTTON_TITLE_DOUBAN imageName:@"button_douban" layout:SYButtonLayoutVerticalImageUp];
//    UIButton *camera = [UIButton buttonWithTitle:BUTTON_TITLE_TAKE_PHOTO imageName:@"button_camera" layout:SYButtonLayoutVerticalImageUp];
//    UIButton *photos = [UIButton buttonWithTitle:BUTTON_TITLE_CHOOSE_PHOTO imageName:@"button_photos" layout:SYButtonLayoutVerticalImageUp];
    [[UIAlertController actionSheetControllerWithButtons:@[wechat, moments, qq, weibo]] show];
//    [[UIAlertController actionSheetControllerWithButtons:@[camera, photos]] show];
}

- (void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"button_category_list" target:self action:@selector(showBookCategoryList:)];
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"button_search" target:self action:@selector(searchInHomeViewController:)];
}

- (void)prepareForUI
{
    [self setupNavigationBar];
    
    CGFloat lineSpaing = 5.0;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat WH = (self.view.width - lineSpaing * 2) / 3;
    flowLayout.itemSize = CGSizeMake(WH, WH);
    flowLayout.minimumLineSpacing = lineSpaing;
    flowLayout.minimumInteritemSpacing = lineSpaing;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.scrollView = self.collectionView;
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
    return [[UICollectionViewCell alloc] init];
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
