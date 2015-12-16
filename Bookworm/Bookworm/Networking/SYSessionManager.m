//
//  SYSessionManager.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "SYSessionManager.h"
#import "SYAppSetting.h"
#import "SYDeviceModel.h"

#define REQUEST_TIMEOUT_INTERVAL    30

NSString *const SYSessionManagerRequestFailedNotification = @"SYSessionManagerRequestFailedNotification";

@implementation SYSessionManager

+ (instancetype)sharedSessionManager
{
    static dispatch_once_t predicate;
    static SYSessionManager *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[SYAppSetting defaultAppSetting].baseURL];
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
    if ([GVUserDefaults standardUserDefaults].isSignedIn && ![accessToken isEmpty]) {
        [self.requestSerializer setValue:accessToken forHTTPHeaderField:@"X-Access-Token"];
    }
    
    #if DEBUG
        NSLog(@"%@", self.requestSerializer.HTTPRequestHeaders);
    #endif
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
{
    [self setHTTPHeaderFields];
    
    return [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self checkResponseStatus:responseObject]) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showErrorTip:error];
    }];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success
{
    [self setHTTPHeaderFields];
    
    return [self PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self checkResponseStatus:responseObject]) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showErrorTip:error];
    }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
{
    [self setHTTPHeaderFields];
    
    return [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self checkResponseStatus:responseObject]) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showErrorTip:error];
    }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
{
    [self setHTTPHeaderFields];
    
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self checkResponseStatus:responseObject]) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showErrorTip:error];
    }];
}

- (BOOL)checkResponseStatus:(id)responseObject
{
    return YES;
}

- (void)showErrorTip:(NSError *)error
{
    #if DEBUG
        NSLog(@"HTTP ERROR: %@", error);
    #endif
    
    [SVProgressHUD dismiss];
    
    switch (error.code) {
        case -1003:
            [SVProgressHUD showErrorWithStatus:TIP_NETWORK_UNSTABLE];
            break;
            
        default:
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SYSessionManagerRequestFailedNotification object:self];
}

@end
