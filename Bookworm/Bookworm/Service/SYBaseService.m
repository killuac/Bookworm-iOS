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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:SVProgressHUDDidTouchDownInsideNotification object:nil];
    }
    
    return self;
}

- (NSString *)userID
{
    return [GVUserDefaults standardUserDefaults].userID;
}

- (NSString *)valueForURLString:(NSString *)URLString
{
    __block NSString *value;
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        value = [db stringForQuery:@"SELECT value FROM KeyValue WHERE key = ?" , [URLString toSHA1String]];
//    }];
    return value;
}

- (void)setValue:(NSString *)value forURLString:(NSString *)URLString
{
//    if (value.length == 0 || URLString.length == 0) return;
//    
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:@"INSERT OR REPLACE INTO KeyValue VALUES (?, ?)" , [URLString toSHA1String], value];
//    }];
}

- (void)cancelRequest
{
    [self.sessionDataTask cancel];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
