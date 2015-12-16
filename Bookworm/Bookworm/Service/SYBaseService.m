//
//  SYBaseService.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYBaseService.h"
#import "FMDatabaseQueue.h"

@implementation SYBaseService

+ (instancetype)service
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_FILE_PATH];
        #if DEBUG
            NSLog(@"%@", DATABASE_FILE_PATH);
        #endif
    }
    
    return self;
}

- (NSInteger)statusCode
{
    return self.response.statusCode;
}

- (NSString *)userId
{
    return [GVUserDefaults standardUserDefaults].userId;
}

- (void)cancelRequest
{
    [self.sessionDataTask cancel];
}

@end
