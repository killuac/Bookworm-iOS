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

- (void)setImageWithURLString:(NSString *)urlString completion:(SDWebImageCompletionBlock)completion
{
    [self sd_setImageWithURL:[NSURL URLWithString:urlString]
            placeholderImage:IMG_DEFAULT_PLACEHOLDER
                     options:SDWebImageRetryFailed
                   completed:completion];
}

@end
