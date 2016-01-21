//
//  SYAppSetting.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYAppSetting.h"
#import "SYDeviceModel.h"

#define APP_SETTING     @"app-setting"

@implementation SYServer

- (NSString *)urlString
{
    return [NSString stringWithFormat:@"%@://%@:%tu", self.protocol, self.host, self.port];
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

// Protecting Data Using On-Disk Encryption
- (void)save
{
//    [[self toDictionary] writeToFile:PlistFilePath(APP_SETTING) atomically:YES];
    
    [[self toJSONData] writeToFile:ApplicationSupportFilePath(APP_SETTING)
                           options:NSDataWritingAtomic | NSDataWritingFileProtectionComplete
                             error:nil];
}

- (NSURL *)baseURL
{
    return [NSURL URLWithString:[self.server.urlString stringByAppendingString:@"/api"]];
}

- (NSString *)referer
{
    return [NSString stringWithFormat:self.refererPrefix, [GVUserDefaults standardUserDefaults].userId, [SYDeviceModel model].deviceID];
}

- (NSURL *)appStoreURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:self.appStoreURLString, [GVUserDefaults standardUserDefaults].language]];
}

@end
