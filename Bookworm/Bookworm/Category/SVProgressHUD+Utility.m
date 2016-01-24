//
//  SVProgressHUD+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/21/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SVProgressHUD+Utility.h"

@implementation SVProgressHUD (Utility)

+ (void)load
{
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
    SwizzleMethod([self class], @selector(showWithStatus:), @selector(swizzle_showWithStatus:), YES);
    SwizzleMethod([self class], @selector(showImage:status:), @selector(swizzle_showImage:status:), YES);
    SwizzleMethod([self class], @selector(dismiss), @selector(swizzle_dismiss), NO);
}

+ (void)swizzle_showWithStatus:(NSString *)status
{
    if (status.length > 0) {
        [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
    } else {
        [self setDefaultStyle:SVProgressHUDStyleCustom];
    }
    
    [self swizzle_showWithStatus:status];
}

- (void)swizzle_showImage:(UIImage *)image status:(NSString *)status
{
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [self swizzle_showImage:image status:status];
}

- (void)swizzle_dismiss
{
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [self swizzle_dismiss];
}

@end
