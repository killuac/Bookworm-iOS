//
//  SYAppSetting.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SYAppSetting : JSONModel

+ (instancetype)defaultAppSetting;

@property (nonatomic, assign) BOOL isAppUpdated;
@property (nonatomic, assign) BOOL isShowUserGuide;

@property (nonatomic, copy) NSString *signatureSalt;
@property (nonatomic, copy) NSString *umengAppKey;

@property (nonatomic, copy) NSString *httpServer;
@property (nonatomic, copy, readonly) NSString *referer;

@property (nonatomic, strong) NSURL *featureURL;
@property (nonatomic, strong) NSURL *faqURL;
@property (nonatomic, strong) NSURL *termsURL;
@property (nonatomic, strong) NSURL *privacyURL;

@property (nonatomic, copy) NSString *appAddress;
@property (nonatomic, strong, readonly) NSURL *appStoreURL;

@end
