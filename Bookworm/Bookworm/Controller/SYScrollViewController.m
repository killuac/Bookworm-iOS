//
//  SYScrollViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/6/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYScrollViewController.h"
#import "SYSessionManager.h"

@interface SYScrollViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation SYScrollViewController

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(HTTPRequestFailed:)
                                                     name:SYSessionManagerRequestFailedNotification
                                                   object:nil];
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
    
    self.view = self.scrollView;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center = self.view.center;
    [self.scrollView addSubview:self.activityIndicator];
}

- (void)startLoadingData:(SYNoParameterBlockType)completion
{
    if (!self.isLoadingData) {
        self.isLoadingData = YES;
        
        [self loadData:^{
            self.isLoadingData = NO;
            if (completion) completion();
        }];
    }
}

- (void)loadNewData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startLoadingData:^{
            [self.refreshControl endRefreshing];
        }];
    });
}

- (void)loadEarlierData
{
    if (self.scrollView.contentSize.height <= self.view.height) {
        return;
    }
    
    self.activityIndicator.bottom = self.scrollView.contentSize.height + DEFAULT_MARGIN * 2;
    [self.activityIndicator startAnimating];
    
    [self startLoadingData:^{
        [self.activityIndicator stopAnimating];
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat yVelocity = [scrollView.panGestureRecognizer velocityInView:scrollView].y;
    CGFloat yOffset = MAX(scrollView.height, scrollView.contentSize.height - scrollView.height);
    
    if (scrollView.contentSize.height < scrollView.height * 2.0f) {
        yOffset = targetContentOffset->y;
    }
    
    if (yVelocity < 0 && targetContentOffset->y >= yOffset && yOffset && !self.isLoadingData) {
        [self loadEarlierData];
    }
}

- (void)scrollToTop
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)HTTPRequestFailed:(NSNotification *)notification
{
    self.isLoadingData = NO;
    [self.activityIndicator stopAnimating];
}

@end
