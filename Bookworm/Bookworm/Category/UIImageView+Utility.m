//
//  UIImageView+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "UIImageView+Utility.h"

@implementation UIImageView (Utility)

- (void)blurImage
{
//    TODO: Blur image
}

- (void)setImageWithURLString:(NSString *)urlString progress:(SDWebImageDownloaderProgressBlock)progress completion:(SDWebImageCompletionBlock)completion
{
    [self sd_setImageWithURL:[NSURL URLWithString:urlString]
            placeholderImage:IMG_DEFAULT_PLACEHOLDER
                     options:SDWebImageRetryFailed
                    progress:progress
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (error) self.image = IMG_LOAD_FAILED;
                       if (completion) completion(image, error, cacheType, imageURL);
                   }];
}

- (void)setImageWithURLString:(NSString *)urlString
{
    [self setImageWithURLString:urlString progress:nil completion:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}

- (void)setImageWithURLString:(NSString *)urlString completion:(SDWebImageCompletionBlock)completion
{
    [self setImageWithURLString:urlString progress:nil completion:completion];
}

- (void)setImageProgressBarWithURLString:(NSString *)urlString completion:(SDWebImageCompletionBlock)completion
{
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.width = self.width;
    [self addSubview:progressView];
    
    [self setImageWithURLString:urlString
                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                           progressView.progress = (receivedSize * 1.0 / expectedSize);
                       }
                     completion:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                         [progressView removeFromSuperview];
                         if (completion) completion(image, error, cacheType, imageURL);
                     }];
}

- (void)setImageProgressRingWithURLString:(NSString *)urlString completion:(SDWebImageCompletionBlock)completion
{
    [self setImageWithURLString:urlString
                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                           [SVProgressHUD showProgress:(receivedSize * 1.0 / expectedSize)];
                       }
                     completion:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                         [SVProgressHUD dismiss];
                         if (completion) completion(image, error, cacheType, imageURL);
                     }];
}

@end
