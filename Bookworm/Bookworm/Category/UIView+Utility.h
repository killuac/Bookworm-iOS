//
//  UIView+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)

- (void)findAndResignFirstResponder;

- (id)superTableView;
- (id)superCollectionView;
- (id)superTableViewCell;
- (id)superCollectionViewCell;

- (id)subTableView;
- (id)subCollectionView;

@end
