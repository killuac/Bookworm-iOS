//
//  SYGuideViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYGuideViewController.h"

@implementation SYGuideViewController

+ (instancetype)guideViewControllerWithPageIndex:(NSUInteger)index
{
    return [[self alloc] initWithPageIndex:index];
}

- (instancetype)initWithPageIndex:(NSUInteger)index
{
    if (self = [super init]) {
        _pageIndex = index;
        
        _bgImageView = [UIImageView newAutoLayoutView];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_bgImageView];
        [self.bgImageView constraintsEqualWithSuperView];
    }
    
    return self;
}

@end
