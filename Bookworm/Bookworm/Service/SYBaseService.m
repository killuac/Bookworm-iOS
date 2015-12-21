//
//  SYBaseService.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYBaseService.h"

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

- (NSString *)userId
{
    return [GVUserDefaults standardUserDefaults].userId;
}

- (NSString *)keyForURLString:(NSString *)URLString
{
    return (URLString.length) ? [URLString MD5String] : @"";
}

- (void)setValue:(NSString *)value forURLString:(NSString *)URLString
{
    if (value.length && URLString.length) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            [db stringForQuery:@"INSERT OR REPLACE INTO KeyValue VALUES (?, ?)" , [self keyForURLString:URLString], value];
        }];
    }
}

- (id)valueForURLString:(NSString *)URLString
{
    __block NSString *value;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        value = [db stringForQuery:@"SELECT value FROM KeyValue WHERE key = ?" , [self keyForURLString:URLString]];
    }];
    return value;
}

- (void)cancelRequest
{
    [self.sessionDataTask cancel];
}

@end
