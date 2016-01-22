//
//  SYSessionManager.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

@import AFNetworking;
#import "HTTPStatusCode.h"
#import "HTTPHeaderField.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYSessionManager : AFHTTPSessionManager

- (nullable NSURLSessionDataTask *)HEAD:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task))success;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success;

- (nullable NSURLSessionDataTask *)PATCH:(NSString *)URLString
                              parameters:(nullable id)parameters
                                 success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success;

- (NSURLSessionDownloadTask *)downloadTaskWithURLString:(NSString *)URLString
                                               progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                            destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                      completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END