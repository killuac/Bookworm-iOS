//
//  SYAppSetting.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SYServer : JSONModel

@property (nonatomic, copy) NSString *protocol;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, assign) NSUInteger port;

@property (nonatomic, copy, readonly) NSString *URLString;

@end

@interface SYAppSetting : JSONModel

+ (instancetype)defaultAppSetting;

@property (nonatomic, strong) SYServer *server;
@property (nonatomic, copy, readonly) NSURL *baseURL;

@property (nonatomic, assign) BOOL isAppUpdated;
@property (nonatomic, assign) BOOL isShowUserGuide;

@end
