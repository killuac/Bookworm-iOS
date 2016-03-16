//
//  SYInitialViewController.h
//  Bookworm
//
//  Created by Killua Liu on 3/15/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYInitialViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@end
