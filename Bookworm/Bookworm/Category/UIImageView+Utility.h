//
//  UIImageView+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Utility)

- (void)sy_setImageWithURL:(NSURL *)url;
- (void)sy_setImageWithURL:(NSURL *)url completion:(SDWebImageCompletionBlock)completion;
- (void)sy_setImageProgressBarWithURL:(NSURL *)url completion:(SDWebImageCompletionBlock)completion;
- (void)sy_setImageProgressRingWithURL:(NSString *)url completion:(SDWebImageCompletionBlock)completion;

@end
