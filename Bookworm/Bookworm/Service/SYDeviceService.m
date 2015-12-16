//
//  SYDeviceService.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYDeviceService.h"

@implementation SYDeviceService

- (NSString *)urlString
{
    return [SYServerAPI sharedServerAPI].device;
}

- (void)createWithModel:(id)model result:(SYServiceBlockType)result
{
    [[SYSessionManager sharedSessionManager] POST:self.urlString parameters:[model toDictionary] success:^void(NSURLSessionDataTask *task, id responseObject) {
        if (result) result(self, nil);
    }];
}

- (void)updateWithModel:(id)model result:(SYServiceBlockType)result
{
    [[SYSessionManager sharedSessionManager] PUT:self.urlString parameters:[model toDictionary] success:^void(NSURLSessionDataTask *task, id responseObject) {
        if (result) result(self, nil);
    }];
}

@end
