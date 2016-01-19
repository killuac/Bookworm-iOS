//
//  SYAppSetting.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYAppSetting.h"

#define APP_SETTING     @"app-setting"

@implementation SYServer

- (NSString *)URLString
{
    return [NSString stringWithFormat:@"%@://%@:%tu/api", self.protocol, self.host, self.port];
}

@end

@implementation SYAppSetting

+ (instancetype)defaultAppSetting
{
    static dispatch_once_t predicate;
    static SYAppSetting *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [self modelWithDictionary:[NSDictionary dictionaryWithContentsOfFile:PlistFilePath(APP_SETTING)]];
        
        sharedInstance.KVOController = [FBKVOController controllerWithObserver:sharedInstance];
        [sharedInstance.KVOController observe:sharedInstance
                                     keyPaths:@[@"isAppUpdated", @"isShowUserGuide"]
                                      options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                                       action:@selector(save)];
    });
    
    return sharedInstance;
}

- (void)save
{
    [[self toDictionary] writeToFile:PlistFilePath(APP_SETTING) atomically:YES];
}

- (NSURL *)baseURL
{
    return [NSURL URLWithString:self.server.URLString];
}

@end
