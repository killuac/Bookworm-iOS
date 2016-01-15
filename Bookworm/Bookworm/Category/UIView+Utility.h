//
//  UIView+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)

@property (nonatomic, strong, readonly) id superTableView;
@property (nonatomic, strong, readonly) id superCollectionView;
@property (nonatomic, strong, readonly) id superTableViewCell;
@property (nonatomic, strong, readonly) id superCollectionViewCell;

@property (nonatomic, strong, readonly) id subTableView;
@property (nonatomic, strong, readonly) id subCollectionView;

- (void)findAndResignFirstResponder;

- (void)addBlurBackground;
- (void)removeBlurBackground;

- (void)addEmptyImageViewWithTitle:(NSString *)title;
- (void)removeEmptyImageView;

@end
