//
//  SYSessionManager.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "SYSessionManager.h"
#import "SYDeviceModel.h"

#define REQUEST_TIMEOUT_INTERVAL    30

NSString *const SYSessionManagerRequestFailedNotification = @"SYSessionManagerRequestFailedNotification";

@implementation SYSessionManager

+ (instancetype)sharedSessionManager
{
    static dispatch_once_t predicate;
    static SYSessionManager *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:nil];
        sharedInstance.requestSerializer = [AFHTTPRequestSerializer serializer];
        sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return sharedInstance;
}

- (void)setHTTPHeaderFields
{
    NSString *networkStatus = [[AFNetworkReachabilityManager sharedManager] localizedNetworkReachabilityStatusString];
    NSString *userAgent = [NSString stringWithFormat:@"Bookworm/%@ (%@; %@) %@",
                           APP_VERSION, [SYDeviceModel model].description, [GVUserDefaults standardUserDefaults].language, networkStatus];
    [self.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSString *accessToken = [GVUserDefaults standardUserDefaults].accessToken;
    if ([GVUserDefaults standardUserDefaults].isSignedIn && accessToken.length) {
        [self.requestSerializer setValue:accessToken forHTTPHeaderField:@"X-Access-Token"];
    }
    
    #if DEBUG
        NSLog(@"%@", self.requestSerializer.HTTPRequestHeaders);
    #endif
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *))success
{
    [self setHTTPHeaderFields];
    
    return [self HEAD:URLString
           parameters:parameters
              success:success
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:task error:error completion:nil];
    }];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
{
    [self setHTTPHeaderFields];
    
    return [self GET:URLString
          parameters:parameters
            progress:nil
             success:success
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:task error:error completion:^{
            if (success) success(task, [self cachedResponseObject:task]);
        }];
    }];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                     progress:(void (^)(NSProgress *))downloadProgress
                      success:(void (^)(NSURLSessionDataTask *, id responseObject))success
{
    [self setHTTPHeaderFields];
    
    return [self GET:URLString
          parameters:nil
            progress:downloadProgress
             success:success
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:task error:error completion:nil];
    }];
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success
{
    [self setHTTPHeaderFields];
    
    return [self PATCH:URLString
            parameters:parameters
               success:success
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:task error:error completion:nil];
    }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
{
    [self setHTTPHeaderFields];
    
    return [self POST:URLString
           parameters:parameters
             progress:nil success:success
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:task error:error completion:nil];
    }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
{
    [self setHTTPHeaderFields];
    
    return [self POST:URLString
           parameters:parameters constructingBodyWithBlock:block
             progress:nil
              success:success
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:task error:error completion:nil];
    }];
}

- (void)handleFailure:(NSURLSessionDataTask *)task error:(NSError *)error completion:(SYNoParameterBlockType)completion
{
    [SVProgressHUD dismiss];
    NSHTTPURLResponse *response = (id)task.response;
    
#if DEBUG
    NSLog(@"RESPONSE STATUS: %@", response);
    if (error) NSLog(@"HTTP ERROR: %@", error);
#endif
    
    switch (response.statusCode) {
        case 304:   // Not Modified (Load cache data from NSURLCache)
            if (completion) completion();
            break;
            
        case 401:   // Unauthorized (Access denied)
            // TODO: Access token invalid, show alert message
            break;
            
        default: {
            NSString *tipMessage = response.allHeaderFields[@"X-Tip-Message"];
            if (tipMessage.length) [SVProgressHUD showErrorWithStatus:tipMessage];
            break;
        }
    }
    
    if (error) {
        switch (error.code) {
            case -1003:
                [SVProgressHUD showErrorWithStatus:TIP_NETWORK_UNSTABLE];
                break;
                
            default:
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SYSessionManagerRequestFailedNotification object:self];
}

- (id)cachedResponseObject:(NSURLSessionDataTask *)task
{
    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:task.originalRequest];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    return [responseSerializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:nil];
}

@end
