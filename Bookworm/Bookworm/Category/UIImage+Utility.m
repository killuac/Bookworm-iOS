//
//  UIImage+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/31/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)

- (CGFloat)width
{
    return self.size.width;
}

- (CGFloat)height
{
    return self.size.height;
}

- (UIImage *)roundedImageWithCornerRadius:(CGFloat)radius
{
    return [self roundedimageWithCornerRadius:radius borderWidth:0 borderColor:nil];
}

- (UIImage *)roundedimageWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    CGRect rect = CGRectMake(0, 0, self.width, self.height);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [bezierPath addClip];
    if (borderWidth > 0 && borderColor) {
        bezierPath.lineWidth = borderWidth;
        bezierPath.lineJoinStyle = kCGLineJoinRound;
        [borderColor setStroke];
        [bezierPath stroke];
    }
    [self drawInRect:rect];
    
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

@end
