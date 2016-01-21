//
//  GVUserDefaults+Properties.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <GVUserDefaults/GVUserDefaults.h>

@interface GVUserDefaults (Properties)

@property (nonatomic, assign) BOOL isFirstLaunch;
@property (nonatomic, assign) BOOL isSignedIn;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy, readonly) NSString *language;

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *deviceToken;

@end
