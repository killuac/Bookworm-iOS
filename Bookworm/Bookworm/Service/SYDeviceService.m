//
//  SYDeviceService.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYDeviceService.h"

@implementation SYDeviceService

- (NSString *)URLString
{
    return [SYServerAPI sharedServerAPI].devices;
}

- (void)createWithModel:(id)model result:(SYServiceBlockType)result
{
//    [[SYSessionManager manager] POST:self.URLString parameters:model success:^void(NSURLSessionDataTask *task, id responseObject) {
//        if (result) result(self, nil);
//    }];
}

- (void)updateWithModel:(id)model result:(SYServiceBlockType)result
{
//    [[SYSessionManager manager] PATCH:self.URLString parameters:model success:^void(NSURLSessionDataTask *task, id responseObject) {
//        if (result) result(self, nil);
//    }];
}

@end
