//
//  UIToolbar+Factory.m
//  Bookworm
//
//  Created by Killua Liu on 3/16/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "UIToolbar+Factory.h"

@interface UIToolbar ()

@property (nonatomic, strong) NSArray *barButtonItems;      // Exclude flexible space bar button
@property (nonatomic, strong) NSMutableArray *seperators;

@end

@implementation UIToolbar (Factory)

+ (void)load
{
    SYSwizzleMethod([self class], @selector(layoutSubviews), @selector(swizzle_layoutSubviews), NO);
}

+ (instancetype)toolbarWithItems:(NSArray<UIBarButtonItem *> *)items
{
    return [[UIToolbar alloc] initWithItems:items];
}

- (instancetype)initWithItems:(NSArray<UIBarButtonItem *> *)items
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.seperators = [NSMutableArray array];
        self.barButtonItems = items;
        NSMutableArray *barItems = [NSMutableArray arrayWithObject:[UIBarButtonItem flexibleSpaceBarButtonItem]];
        
        [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [barItems addObject:obj];
            [barItems addObject:[UIBarButtonItem flexibleSpaceBarButtonItem]];
            
            if (idx > 0) {
                UIView *separator = [[UIView alloc] initWithFrame:CGRectZero];
                separator.backgroundColor = [UIColor separatorColor];
                [self addSubview:separator];
                [self.seperators addObject:separator];
            }
        }];
        self.items = barItems;
    }
    
    return self;
}

- (void)setBarButtonItems:(NSMutableArray<UIBarButtonItem *> *)barButtonItems
{
    objc_setAssociatedObject(self, @selector(barButtonItems), barButtonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<UIBarButtonItem *> *)barButtonItems
{
    return objc_getAssociatedObject(self, @selector(barButtonItems));
}

- (void)setSeperators:(NSMutableArray<UIView *> *)seperators
{
    objc_setAssociatedObject(self, @selector(seperators), seperators, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<UIView *> *)seperators
{
    return objc_getAssociatedObject(self, @selector(seperators));
}

- (void)swizzle_layoutSubviews
{
    [self swizzle_layoutSubviews];
    
    CGFloat width = self.width / self.barButtonItems.count;
    [self.barButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.width = width;
        
        if (idx > 0) {
            CGFloat margin = MEDIUM_MARGIN;
            [self.seperators[idx-1] setFrame:CGRectMake(width * idx, margin, 0.5, self.height-margin*2)];
        }
    }];
}

@end
