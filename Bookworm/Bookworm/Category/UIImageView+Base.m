//
//  UIImageView+Base.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "UIImageView+Base.h"

@implementation UIImageView (Base)

#pragma mark - Image process
- (void)setCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    UIImage *image = self.image;
    image = (image.width == image.height) ? image : [image resizableCroppedImage];
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGSize cornerRadii = CGSizeMake(radius, radius);
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    [roundedPath addClip];
    roundedPath.lineWidth = width;
    roundedPath.lineJoinStyle = kCGLineJoinRound;
    if (color) {
        [color setStroke];
        [roundedPath stroke];
    }
    [roundedPath closePath];
    
    [image drawInRect:self.bounds];
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - Image locading
- (void)sy_setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url progress:nil completion:nil];
}

- (void)sy_setImageWithURL:(NSURL *)url completion:(SDWebImageCompletionBlock)completion
{
    [self setImageWithURL:url progress:nil completion:completion];
}

- (void)sy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completion:(SDWebImageCompletionBlock)completion
{
    [self setImageWithURL:url placeholderImage:placeholder progress:nil completion:completion];
}

- (void)sy_setImageProgressBarWithURL:(NSURL *)url completion:(SDWebImageCompletionBlock)completion
{
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.width = self.width;
    [self addSubview:progressView];
    
    [self setImageWithURL:url
                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                     progressView.progress = (receivedSize * 1.0 / expectedSize);
                 }
               completion:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   [progressView removeFromSuperview];
                   if (completion) completion(image, error, cacheType, imageURL);
               }];
}

- (void)sy_setImageProgressRingWithURL:(NSURL *)url completion:(SDWebImageCompletionBlock)completion
{
    [self setImageWithURL:url
                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                     [SVProgressHUD showProgress:(receivedSize * 1.0 / expectedSize)];
                 }
               completion:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   [SVProgressHUD dismiss];
                   if (completion) completion(image, error, cacheType, imageURL);
               }];
}

- (void)setImageWithURL:(NSURL *)url progress:(SDWebImageDownloaderProgressBlock)progress completion:(SDWebImageCompletionBlock)completion
{
    [self setImageWithURL:url placeholderImage:SYImagePlaceholder() progress:progress completion:completion];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder progress:(SDWebImageDownloaderProgressBlock)progress completion:(SDWebImageCompletionBlock)completion
{
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed
                    progress:progress
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (error) self.image = SYImageLoadFailed();
                       if (completion) completion(image, error, cacheType, imageURL);
                   }];
}

@end
