//
//  SVProgressHUD+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/21/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SVProgressHUD+Utility.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation SVProgressHUD (Utility)
#pragma clang diagnostic pop

+ (void)load
{
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [self setInfoImage:[UIImage imageNamed:@"icon_hud_info"]];
    [self setErrorImage:[UIImage imageNamed:@"icon_hud_error"]];
    [self setSuccessImage:[UIImage imageNamed:@"icon_hud_success"]];
    
    SYSwizzleMethod([self class], @selector(displayDurationForString:), @selector(swizzle_displayDurationForString:), YES);
    SYSwizzleMethod([self class], @selector(showWithStatus:), @selector(swizzle_showWithStatus:), YES);
    SYSwizzleMethod([self class], @selector(showImage:status:), @selector(swizzle_showImage:status:), YES);
    SYSwizzleMethod([self class], @selector(dismiss), @selector(swizzle_dismiss), NO);
}

+ (NSTimeInterval)swizzle_displayDurationForString:(NSString *)string
{
    NSTimeInterval interval = [self swizzle_displayDurationForString:string];
    double multiplier = [string containsUnicodeCharacter] ? 2.0 : 0.7;
    return (interval - 0.5) * multiplier + 0.5;
}

+ (void)swizzle_showWithStatus:(NSString *)status
{
    if (status.length > 0) {
        [self setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    } else {
        [self setDefaultStyle:SVProgressHUDStyleCustom];
    }
    [self swizzle_showWithStatus:status];
}

- (void)swizzle_showImage:(UIImage *)image status:(NSString *)status
{
    [self setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [self swizzle_showImage:image status:status];
}

- (void)swizzle_dismiss
{
    [self setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [self swizzle_dismiss];
}

@end
