//
//  SVProgressHUD+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/21/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SVProgressHUD+Utility.h"
#import "SYUtility.h"

@implementation SVProgressHUD (Utility)

+ (void)load
{
    [self setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
    SwizzleMethod([self class], @selector(showWithStatus:), @selector(swizzle_showWithStatus:), YES);
    SwizzleMethod([self class], @selector(showImage:status:), @selector(swizzle_showImage:status:), YES);
    SwizzleMethod([self class], @selector(showProgress:status:), @selector(swizzle_showProgress:status:), YES);
}

+ (void)swizzle_showWithStatus:(NSString *)status
{
    if (status.length > 0) {
        [self setDefaultStyle:SVProgressHUDStyleDark];
        [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
    } else {
        [self setDefaultStyle:SVProgressHUDStyleCustom];
        [self setDefaultMaskType:SVProgressHUDMaskTypeNone];
    }
    [self swizzle_showWithStatus:status];
}

+ (void)swizzle_showImage:(UIImage *)image status:(NSString *)status
{
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [self swizzle_showImage:image status:status];
}

+ (void)swizzle_showProgress:(float *)progress status:(NSString *)status
{
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [self swizzle_showProgress:progress status:status];
}

@end
