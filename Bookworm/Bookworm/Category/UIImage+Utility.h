//
//  UIImage+Utility.h
//  Bookworm
//
//  Created by Bing Liu on 12/31/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;

- (UIImage *)roundedImageWithCornerRadius:(CGFloat)radius;
- (UIImage *)roundedimageWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
