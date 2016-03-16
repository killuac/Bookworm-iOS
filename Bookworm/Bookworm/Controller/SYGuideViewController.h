//
//  SYGuideViewController.h
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGuideViewController : UIViewController

@property (nonatomic, assign, readonly) NSUInteger pageIndex;
@property (nonatomic, strong, readonly) UIImageView *bgImageView;

+ (instancetype)guideViewControllerWithPageIndex:(NSUInteger)index;

@end
