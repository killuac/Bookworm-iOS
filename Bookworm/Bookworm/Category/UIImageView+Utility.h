//
//  UIImageView+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Utility)

- (void)blurImage;

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url completion:(SDWebImageCompletionBlock)completion;
- (void)setImageProgressBarWithURL:(NSURL *)url completion:(SDWebImageCompletionBlock)completion;
- (void)setImageProgressRingWithURL:(NSString *)url completion:(SDWebImageCompletionBlock)completion;

@end
