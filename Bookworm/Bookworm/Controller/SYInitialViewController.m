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

@interface SYInitialViewController ()

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageNames;

@end

@implementation SYInitialViewController

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view findAndResignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.view.layer.cornerRadius = DEFAULT_CORNER_RADIUS;
    self.view.clipsToBounds = YES;
    
    [self loadData];
    [self addPageViewController];
    [self addSubviews];
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
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.enabled = NO;
    self.pageControl.top = self.view.height - 70;
    self.pageControl.size = CGSizeMake(self.view.width, 10);
    self.pageControl.numberOfPages = self.imageNames.count;
    [self.view addSubview:self.pageControl];
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
//  Toolbar
    UIBarButtonItem *signUp = [UIBarButtonItem barButtonItemWithTitle:BUTTON_TITLE_SIGNUP target:self action:@selector(signUp:)];
    UIBarButtonItem *signIn = [UIBarButtonItem barButtonItemWithTitle:BUTTON_TITLE_SIGNIN target:self action:@selector(signIn:)];
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont boldBigFont] };
    [signUp setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [signIn setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    UIToolbar *toolbar = [UIToolbar toolbarWithItems:@[signUp, signIn]];
    toolbar.clipsToBounds = YES;
    toolbar.size = CGSizeMake(self.view.width, 50);
    toolbar.top = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
    
//  Skip button
    UIButton *skipButton = [UIButton systemButtonWithTitle:BUTTON_TITLE_LOOK_AROUND];
    skipButton.tintColor = [UIColor tintColor];
    skipButton.center = self.view.center;
    skipButton.bottom = self.pageControl.top;
    [skipButton addTarget:self action:@selector(lookAround:)];
    [self.view addSubview:skipButton];
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
    [SYAppSetting defaultAppSetting].isShowUserGuide = NO;
}

@end
