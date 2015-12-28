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
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
    SwizzleMethod([self class], @selector(showWithStatus:), @selector(swizzle_showWithStatus:), YES);
}

+ (void)swizzle_showWithStatus:(NSString *)status
{
    if (status.length > 0) {
        [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
    } else {
        [self setDefaultStyle:SVProgressHUDStyleCustom];
    }
    
    [self swizzle_showWithStatus:status];
    
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setDefaultMaskType:SVProgressHUDMaskTypeNone];
}

@end
