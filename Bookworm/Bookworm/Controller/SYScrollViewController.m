//
//  SYScrollViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/6/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYScrollViewController.h"

@interface SYScrollViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSLayoutConstraint *activityIndicatorVConstraint;

@end

@implementation SYScrollViewController

#pragma mark - Life cycle

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_scrollView];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(loadNewData) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_refreshControl];
    [_scrollView sendSubviewToBack:_refreshControl];
    
    _activityIndicator = [UIActivityIndicatorView newAutoLayoutView];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_scrollView addSubview:_activityIndicator];
    [_scrollView sendSubviewToBack:_activityIndicator];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.scrollView constraintsEqualWithSuperView];
    
    NSLayoutConstraint *hConstraint = [NSLayoutConstraint constraintCenterXWithItem:_activityIndicator];
    NSLayoutConstraint *vConstraint = [NSLayoutConstraint constraintTopWithItem:_activityIndicator];
    [NSLayoutConstraint activateConstraints:@[hConstraint, vConstraint]];
    _activityIndicatorVConstraint = vConstraint;
}

- (void)startLoadingData:(SYVoidBlockType)completion
{
    if (!self.isLoadingData) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(HTTPRequestDidComplete:)
                                                     name:AFNetworkingTaskDidCompleteNotification
                                                   object:nil];
        
        self.isLoadingData = YES;
        [self loadData:^{
            self.isLoadingData = NO;
            if (completion) completion();
        }];
    }
}

- (void)HTTPRequestDidComplete:(NSNotification *)notification
{
    [super HTTPRequestDidComplete:notification];
    [self.activityIndicator stopAnimating];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Load data
- (void)loadNewData
{
    [self startLoadingData:^{
        [self.refreshControl endRefreshing];
    }];
}

- (void)loadEarlierData
{
    self.activityIndicatorVConstraint.constant = self.scrollView.contentSize.height + SYViewDefaultMargin;
    CGFloat footerSpacing = self.activityIndicator.height + SYViewDefaultMargin * 2;
    CGSize contentSize = self.scrollView.contentSize;
    [UIView animateWithDuration:SYViewDefaultAnimationDuration animations:^{
        self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + footerSpacing);
    }];
    
    [self.activityIndicator startAnimating];
    [self startLoadingData:^{
        [UIView animateWithDuration:SYViewDefaultAnimationDuration animations:^{
            self.scrollView.contentSize = contentSize;
        }];
        [self.activityIndicator stopAnimating];
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentSize.height <= self.view.height) return;
    
    CGFloat yVelocity = [scrollView.panGestureRecognizer velocityInView:scrollView].y;
    if (yVelocity >= 0 ) return;
    
    CGFloat yOffset = MAX(scrollView.contentSize.height - scrollView.height * 2, 0.0f);
    if (scrollView.contentOffset.y >= yOffset && !self.isLoadingData) {
        [self loadEarlierData];
    }
}

- (void)scrollToTop
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

@end
