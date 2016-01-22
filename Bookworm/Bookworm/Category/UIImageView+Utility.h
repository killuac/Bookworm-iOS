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

- (void)setImageWithURLString:(NSString *)urlString completion:(SDWebImageCompletionBlock)completion;

@end
