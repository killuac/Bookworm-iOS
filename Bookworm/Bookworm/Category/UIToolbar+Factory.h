//
//  UIToolbar+Factory.h
//  Bookworm
//
//  Created by Killua Liu on 3/16/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar (Factory)

+ (instancetype)toolbarWithItems:(NSArray<UIBarButtonItem *> *)items;

@end
