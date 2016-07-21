//
//  SYInitialViewController.m
//  Bookworm
//
//  Created by Killua Liu on 3/15/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYInitialViewController.h"
#import "SYGuideViewController.h"
#import "SYSignUpViewController.h"

@interface SYInitialViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageNames;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIButton *skipButton;

@end

@implementation SYInitialViewController

//- (BOOL)shouldAutorotate
//{
//    return NO;
//}

#pragma mark - Life cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view findAndResignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    [self prepareForUI];
}

- (void)prepareForUI
{
    self.view.backgroundColor = [UIColor backgroundColor];
    self.view.layer.cornerRadius = SYViewDefaultCornerRadius;
    self.view.clipsToBounds = YES;
    
    [self addPageViewController];
    [self addSubviews];
    [self addConstraints];
}

- (void)loadData
{
    self.imageNames = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide%tu", i] ofType:@"jpg"];
        [self.imageNames addObject:path];
    }
}

- (void)addPageViewController
{
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    SYGuideViewController *firstVC = [self viewControllerAtIndex:0];
    [self.pageViewController setViewControllers:@[firstVC]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    self.scrollView.delegate = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (UIScrollView *)scrollView
{
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:UIScrollView.class]) {
            return (UIScrollView *)view;
        }
    }
    return nil;
}

- (void)addSubviews
{
//  Page control
    _pageControl = [UIPageControl newAutoLayoutView];
    _pageControl.enabled = NO;
    _pageControl.numberOfPages = self.imageNames.count;
    [self.view addSubview:_pageControl];
    
//  Toolbar
    UIBarButtonItem *signUp = [UIBarButtonItem barButtonItemWithTitle:BUTTON_TITLE_SIGNUP target:self action:@selector(signUp:)];
    UIBarButtonItem *signIn = [UIBarButtonItem barButtonItemWithTitle:BUTTON_TITLE_SIGNIN target:self action:@selector(signIn:)];
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont boldBigFont] };
    [signUp setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [signIn setTitleTextAttributes:attributes forState:UIControlStateNormal];
    _toolbar = [UIToolbar toolbarWithDistributedItems:@[signUp, signIn] separator:YES];
    [self.view addSubview:_toolbar];
    
//  Skip button
    _skipButton = [UIButton systemButtonWithTitle:BUTTON_TITLE_LOOK_AROUND];
    _skipButton.tintColor = [UIColor tintColor];
    _skipButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_skipButton addTarget:self action:@selector(lookAround:)];
    [self.view addSubview:_skipButton];
}

- (void)addConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_pageControl, _toolbar, _skipButton);
    NSDictionary *metrics = @{ @"margin": @(10.0) };
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_skipButton(20)]-margin-[_pageControl(10)]-margin-[_toolbar]|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
}

#pragma mark - Page view controller datasource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(id)viewController pageIndex];
    if (index == 0 || index == NSNotFound) return nil;
    
    return [self viewControllerAtIndex:index-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(id)viewController pageIndex];
    if (index == NSNotFound) return nil;
    
    return [self viewControllerAtIndex:index+1];
}

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return self.imageNames.count;
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}

- (SYGuideViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (self.imageNames.count == 0 || index >= self.imageNames.count) {
        return nil;
    }
    
    SYGuideViewController *VC = [SYGuideViewController guideViewControllerWithPageIndex:index];
    VC.bgImageView.image = [UIImage imageWithContentsOfFile:self.imageNames[index]];
    
    return VC;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        self.pageControl.currentPage = [(id)pageViewController.viewControllers.firstObject pageIndex];
    }
}

#pragma mark - Scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (0 == self.pageControl.currentPage && scrollView.contentOffset.x < scrollView.width) {
        scrollView.contentOffset = CGPointMake(scrollView.width, 0);
    }
    if (self.pageControl.currentPage == self.pageControl.numberOfPages-1 && scrollView.contentOffset.x > scrollView.width) {
        scrollView.contentOffset = CGPointMake(scrollView.width, 0);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (0 == self.pageControl.currentPage && scrollView.contentOffset.x <= scrollView.width) {
        *targetContentOffset = CGPointMake(scrollView.width, 0);
    }
    if (self.pageControl.currentPage == self.pageControl.numberOfPages-1 && scrollView.contentOffset.x >= scrollView.width) {
        *targetContentOffset = CGPointMake(scrollView.width, 0);
    }
}

#pragma mark - Event handling
- (void)signIn:(id)sender
{
    SYSignInViewController *VC = [[SYSignInViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:VC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)signUp:(id)sender
{
    SYSignUpViewController *VC = [[SYSignUpViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:VC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)lookAround:(id)sender
{
    [self showMainViewController];
    [GVUserDefaults standardUserDefaults].isShowInitialView = NO;
}

@end
