//
//  SYScrollViewController.h
//  Bookworm
//
//  Created by Killua Liu on 1/6/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYScrollViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)loadNewData;
- (void)loadEarlierData;

- (void)scrollToTop;

@end
