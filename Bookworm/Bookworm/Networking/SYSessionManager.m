//
//  SYSessionManager.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "SYSessionManager.h"
#import "HTTPStatusCodes.h"
#import "SYDeviceModel.h"
#import "SYBaseService.h"

#define REQUEST_TIMEOUT_INTERVAL    30

NSString *const SYSessionManagerRequestFailedNotification = @"SYSessionManagerRequestFailedNotification";

@interface SYSessionManager ()

@property (nonatomic, strong) SYBaseService *service;

@end

@implementation SYSessionManager

+ (instancetype)sharedSessionManager
{
    static dispatch_once_t predicate;
    static SYSessionManager *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:nil];
        sharedInstance.requestSerializer = [AFHTTPRequestSerializer serializer];
        sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
        sharedInstance.service = [SYBaseService service];
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
    
//  Pass eTag header for checking if cached response is valid
    __block NSString *eTag = [self.service valueForURLString:URLString];
    if (eTag.length) {
        [self.requestSerializer setValue:eTag forHTTPHeaderField:@"If-None-Match"];
    }
    
    return [self GET:URLString
          parameters:parameters
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 if (success) success(task, responseObject);
                 
                 eTag = ((NSHTTPURLResponse *)task.response).allHeaderFields[@"Etag"];
                 if (eTag.length) [self.service setValue:eTag forURLString:URLString];
             }
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
    if (error) NSLog(@"HTTP ERROR: %@", error);
    NSLog(@"RESPONSE STATUS: %@", response);
#endif
    
    if (error) {
        switch (error.code) {
            case NSURLErrorCannotFindHost:
            case NSURLErrorDNSLookupFailed:
                [SVProgressHUD showErrorWithStatus:HUD_NETWORK_UNSTABLE];
                break;
                
            case NSURLErrorCannotConnectToHost:
                [SVProgressHUD showErrorWithStatus:HUD_CANNOT_CONNECT_TO_HOST];
                break;
                
            default:
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                break;
        }
        
        if (completion) completion();
    }
    else {
        switch (response.statusCode) {
            case kHTTPStatusCodeNotModified:    // Load cache data from NSURLCache
                if (completion) completion();
                break;
                
            case kHTTPStatusCodeUnauthorized:   // Access token invalid
                // TODO: Access token invalid, show alert message
                break;
                
            case kHTTPStatusCodeNotFound:
            case kHTTPStatusCodeNotAcceptable: {
                NSString *tipMessage = response.allHeaderFields[@"X-HUD-Message"];
                if (tipMessage.length) [SVProgressHUD showErrorWithStatus:tipMessage];
                break;
            }
                
            default:
                break;
        }
    }
    
    [UIApplication sharedApplication].keyWindow.rootViewController.visibleViewController.isLoadingData = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:SYSessionManagerRequestFailedNotification object:self];
}

- (id)cachedResponseObject:(NSURLSessionDataTask *)task
{
    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:task.originalRequest];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    return [responseSerializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:nil];
}

@end
