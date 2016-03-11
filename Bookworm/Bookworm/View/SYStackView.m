//
//  SYStackView.m
//  Bookworm
//
//  Created by Bing Liu on 3/10/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYStackView.h"

@implementation SYStackView

- (void)addSubviews:(NSArray *)subviews
{
    [subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:view];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSArray *subviews = self.subviews;
    CGFloat width = self.width / subviews.count;
    
    [subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.centerX = width * idx + width / 2;
        view.centerY = self.height / 2;
    }];
}

@end
