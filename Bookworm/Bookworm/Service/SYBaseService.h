//
//  SYBaseService.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SYServiceBlockType)(id result);

@class FMDatabaseQueue;

@protocol SYServiceProtocol <NSObject>

@optional
- (void)findAll:(SYServiceBlockType)result;

- (void)findByKey:(NSString *)key result:(SYServiceBlockType)result;

- (void)findByParameters:(NSArray *)parameters result:(SYServiceBlockType)result;

- (void)createWithModel:(id)model result:(SYServiceBlockType)result;

- (void)updateWithModel:(id)model result:(SYServiceBlockType)result;

- (void)saveWithModels:(NSArray *)models result:(SYServiceBlockType)result;

- (void)deleteWithModel:(id)model result:(SYServiceBlockType)result;

- (void)deleteByKey:(NSString *)key result:(SYServiceBlockType)result;

@end

@interface SYBaseService : NSObject <SYServiceProtocol>

+ (instancetype)service;

@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;
@property (nonatomic, copy, readonly) NSString *urlString;

@property (nonatomic, strong, readonly) FMDatabaseQueue *dbQueue;
@property (nonatomic, copy, readonly) NSString *userID;

- (NSString *)valueForURLString:(NSString *)URLString;
- (void)setValue:(NSString *)value forURLString:(NSString *)URLString;

- (void)cancelRequest;

@end
