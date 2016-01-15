//
//  SYServerAPI.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "SYServerAPI.h"
#import "SYAppSetting.h"
#import "SYSessionManager.h"

#define JSON_SERVER_API     @"server-api.json"

@implementation SYServerAPI

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@ {
        @"_links.devices.href": @"devicesURLString",
        @"_links.signIn.href": @"signInURLString",
        @"_links.users.href": @"usersURLString",
        @"_links.IMServerURL.href": @"IMServerURLString"
    }];
}

static SYServerAPI *sharedInstance = nil;
+ (instancetype)sharedServerAPI
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [self modelWithData:[NSData dataWithContentsOfFile:ApplicationSupportFilePath(JSON_SERVER_API)]];
    });
    
    return sharedInstance;
}

+ (void)fetchAndSave
{
    NSString *urlString = [[SYAppSetting defaultAppSetting].baseURL absoluteString];
    
    [[SYSessionManager sharedSessionManager] GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        id serverAPI = [self modelWithDictionary:responseObject];
        
//      Protecting Data Using On-Disk Encryption
        [[serverAPI toJSONData] writeToFile:ApplicationSupportFilePath(JSON_SERVER_API)
                                    options:NSDataWritingAtomic | NSDataWritingFileProtectionComplete
                                      error:nil];
        
//      If App is updated, need fetch API again and reset the sharedInstance with new API file.
        sharedInstance = [self modelWithData:[NSData dataWithContentsOfFile:DocumentFilePath(JSON_SERVER_API)]];
    }];
}

@end
