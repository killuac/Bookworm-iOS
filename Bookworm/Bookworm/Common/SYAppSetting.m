//
//  SYAppSetting.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYAppSetting.h"

NSString *const SYFileNameAppSetting = @"app-setting";

@implementation SYAppSetting

+ (instancetype)defaultAppSetting
{
    static dispatch_once_t onceToken;
    static SYAppSetting *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self modelWithDictionary:[NSDictionary dictionaryWithContentsOfURL:SYPlistFileURL(SYFileNameAppSetting)]];
        
        NSArray *keyPaths = @[NSStringFromSelector(@selector(isAppUpdated)), NSStringFromSelector(@selector(isShowUserGuide))];
        sharedInstance.KVOController = [FBKVOController controllerWithObserver:sharedInstance];
        [sharedInstance.KVOController observe:sharedInstance keyPaths:keyPaths options:NSKeyValueObservingOptionNew action:@selector(save)];
    });
    
    return sharedInstance;
}

// Protecting Data Using On-Disk Encryption
- (void)save
{
//    [[self toDictionary] writeToURL:SYApplicationSupportFileURL(SYFileNameAppSetting) atomically:YES];
    
    [[self toJSONData] writeToURL:SYApplicationSupportFileURL(SYFileNameAppSetting)
                          options:NSDataWritingAtomic | NSDataWritingFileProtectionComplete
                            error:nil];
}

- (NSString *)signatureSalt
{
    return @"6d7fc1d86e4f0cdf5f3321f393702f89dbecb691";
}

- (NSString *)referer
{
    NSString *prefix = [self.httpServer stringByAppendingPathComponent:[GVUserDefaults standardUserDefaults].userID];
    return [prefix stringByAppendingPathComponent:UUID_STRING];
}

- (NSURL *)appStoreURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:self.appAddress, [GVUserDefaults standardUserDefaults].languageID]];
}

@end
