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
    [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
    SwizzleMethod([self class], @selector(show), @selector(swizzle_show));
}

+ (void)swizzle_show
{
    [self setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [self swizzle_show];
    [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

@end
