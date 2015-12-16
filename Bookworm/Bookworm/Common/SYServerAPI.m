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

+ (instancetype)sharedServerAPI
{
    static dispatch_once_t predicate;
    static SYServerAPI *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [self modelWithData:[NSData dataWithContentsOfFile:DocumentFilePath(JSON_SERVER_API)]];
    });
    
    return sharedInstance;
}

+ (void)writeAPIFile
{
    NSString *urlString = [[SYAppSetting defaultAppSetting].baseURL absoluteString];
    
    [[SYSessionManager sharedSessionManager] POST:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        id serverAPI = [self modelWithDictionary:responseObject];
        [[serverAPI toJSONData] writeToFile:DocumentFilePath(JSON_SERVER_API) atomically:YES];
    }];
}

@end
