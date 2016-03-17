//
//  GVUserDefaults+Properties.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "GVUserDefaults+Properties.h"

@implementation GVUserDefaults (Properties)

@dynamic isFirstLaunch;
@dynamic isShowInitialView;
@dynamic userID;
@dynamic isSignedIn;
@dynamic maxOutboxMessageID;
@dynamic accessToken;
@dynamic deviceToken;

- (NSDictionary *)setupDefaults
{
    return @{
        @"isFirstLaunch": @(YES),
        @"isShowInitialView": @(YES)
    };
}

- (NSString *)language
{
    return [[NSBundle mainBundle] preferredLocalizations].firstObject;
}

@end
