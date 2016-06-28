//
//  UIToolbar+Base.m
//  Bookworm
//
//  Created by Killua Liu on 3/16/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "UIToolbar+Base.h"

@interface UIToolbar ()

@property (nonatomic, strong) NSArray *barButtonItems;      // Exclude flexible space bar button
@property (nonatomic, strong) NSMutableArray *seperators;

@end

@implementation UIToolbar (Base)

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
    if (self = [super init]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.seperators = [NSMutableArray array];
        self.barButtonItems = items;
        NSMutableArray *barItems = [NSMutableArray arrayWithObject:[UIBarButtonItem flexibleSpaceBarButtonItem]];
        
        [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [barItems addObject:obj];
            [barItems addObject:[UIBarButtonItem flexibleSpaceBarButtonItem]];
            
            if (idx > 0) {
                UIView *separator = [UIView newAutoLayoutView];
                separator.backgroundColor = [UIColor blackColor];
                [self addSubview:separator];
                [self.seperators addObject:separator];
            }
        }];
        self.items = barItems;
        
//        [self addConstraints];
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

//- (void)addConstraints
//{
//    NSMutableDictionary *views = [NSMutableDictionary dictionary];
//    [self.seperators enumerateObjectsUsingBlock:^(UIView *separator, NSUInteger idx, BOOL *stop) {
//        NSString *key = [NSString stringWithFormat:@"seperator%lu", idx];
//        views[key] = separator;
//    }];
//    
//    __block NSString *visualFormat = @"H:|-";
//    NSArray *allKeys = [views.allKeys sortedArrayUsingSelector:@selector(compare:)];
//    [allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * stop) {
//        NSString *nextKey = (idx+1 < allKeys.count) ? allKeys[idx+1] : nil;
//        if (nextKey) {
//            visualFormat = [visualFormat stringByAppendingFormat:@"[%@(%@)]-", key, nextKey];
//        } else {
//            visualFormat = [visualFormat stringByAppendingFormat:@"[%@(0.5)]-|", key];
//        }
//    }];
//    
//    NSDictionary *metrics = @{ @"margin": @(5) };
//    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
//    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[seperator0]-margin-|" options:0 metrics:metrics views:views]];
//}

- (void)swizzle_layoutSubviews
{
    [self swizzle_layoutSubviews];
    
    CGFloat width = self.width / self.barButtonItems.count;
    [self.barButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.width = width;
        
        if (idx > 0) {
            CGFloat margin = 10.0f;
            [self.seperators[idx-1] setFrame:CGRectMake(width * idx, margin, 0.5, self.height-margin*2)];
        }
    }];
}

@end
