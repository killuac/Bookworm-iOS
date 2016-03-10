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
    CGFloat totalWidth = [[subviews valueForKeyPath:@"@sum.width"] floatValue];
    CGFloat spacing = (self.width - totalWidth) / (subviews.count + 1);
    
    [subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat baseX = (idx > 0) ? ((UIView *)subviews[idx-1]).right : 0.0f;
        view.left = baseX + spacing;
        view.centerY = self.height / 2;
    }];
}

@end
