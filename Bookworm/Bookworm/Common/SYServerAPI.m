//
//  SYServerAPI.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "SYServerAPI.h"

NSString *const SYFileNameServerAPI = @"server-api.json";

@implementation SYServerAPI

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@ {
        @"_links.devices.href": @"devices",
        @"_links.signIn.href": @"signIn",
        @"_links.users.href": @"users",
        @"_links.imServers.href": @"imServers"
    }];
}

static SYServerAPI *sharedInstance = nil;
+ (instancetype)sharedServerAPI
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self modelWithData:[NSData dataWithContentsOfURL:SYApplicationSupportFileURL(SYFileNameServerAPI)]];
    });
    
    return sharedInstance;
}

+ (void)fetchAndSave
{
    NSString *urlString = [SYAppSetting defaultAppSetting].httpServer;
    [[SYSessionManager manager] GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self modelWithDictionary:responseObject] save];
        
//      If App is updated, need fetch API again and reset the sharedInstance with new API file.
        sharedInstance = [self modelWithData:[NSData dataWithContentsOfURL:SYApplicationSupportFileURL(SYFileNameServerAPI)]];
    }];
}

// Protecting Data Using On-Disk Encryption
- (void)save
{
    [[self toJSONData] writeToURL:SYApplicationSupportFileURL(SYFileNameServerAPI)
                          options:NSDataWritingAtomic | NSDataWritingFileProtectionComplete
                            error:nil];
}

- (void)fetchIMServerAddressCompletion:(SYVoidBlockType)completion
{
    [[SYSessionManager manager] HEAD:self.imServers parameters:nil success:^(NSURLSessionDataTask * _Nonnull task) {
        NSString *serverAddress = ((NSHTTPURLResponse *)task.response).allHeaderFields[kHTTPHeaderFieldIMServer];
        _imServerURL = [NSURL URLWithString:serverAddress];
        [self save];
        if (completion) completion();
    }];
}

@end
