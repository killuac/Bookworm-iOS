//
//  SYSessionManager.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "SYSessionManager.h"
#import "SYDeviceModel.h"
#import "SYBaseService.h"

#define REQUEST_TIMEOUT_INTERVAL    30

@interface SYSessionManager ()

@property (nonatomic, strong) SYBaseService *service;

@end

@implementation SYSessionManager

+ (instancetype)manager
{
    static dispatch_once_t predicate;
    static SYSessionManager *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:nil];
        
        sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer];
        sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableIndexSet *responseCodes = [NSMutableIndexSet indexSet];
        [responseCodes addIndexes:sharedInstance.responseSerializer.acceptableStatusCodes];
        [responseCodes addIndex:kHTTPStatusCodeNotModified];
        sharedInstance.responseSerializer.acceptableStatusCodes = responseCodes;
        
        sharedInstance.service = [SYBaseService service];
    });
    
    return sharedInstance;
}

- (void)setHTTPHeaderFields
{
    NSString *networkStatus = [[AFNetworkReachabilityManager sharedManager] localizedNetworkReachabilityStatusString];
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; %@) %@", APP_BUNDLE_NAME, APP_VERSION,
                           [SYDeviceModel model].description, [GVUserDefaults standardUserDefaults].language, networkStatus];
    [self.requestSerializer setValue:userAgent forHTTPHeaderField:kHTTPHeaderFieldUserAgent];
    
    NSString *accessToken = [GVUserDefaults standardUserDefaults].accessToken;
    if ([GVUserDefaults standardUserDefaults].isSignedIn && accessToken.length) {
        [self.requestSerializer setValue:accessToken forHTTPHeaderField:kHTTPHeaderFieldAccessToken];
    }
    
#if DEBUG
    NSLog(@"%@", self.requestSerializer.HTTPRequestHeaders);
#endif
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *))success
{
    NSParameterAssert(URLString.length > 0);
    [self setHTTPHeaderFields];
    if (!parameters) parameters = [JSONModel model];    // Pass "signature" at least
    
    return [self HEAD:URLString
           parameters:[parameters toDictionary]
              success:success
              failure:^(NSURLSessionDataTask * task, NSError * error) {
                  [self handleFailure:task error:error];
              }];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
{
    NSParameterAssert(URLString.length > 0);
    [self setHTTPHeaderFields];
    
//  Pass eTag header for checking if cached response is valid
    __block NSString *eTag = [self.service valueForURLString:URLString];
    if (eTag.length) {
        [self.requestSerializer setValue:eTag forHTTPHeaderField:kHTTPHeaderFieldIfNoneMatch];
    }
    
    if (!parameters) parameters = [JSONModel model];
    
    return [self GET:URLString
          parameters:[parameters toDictionary]
            progress:nil
             success:^(NSURLSessionDataTask * task, id responseObject) {
                 [self handleSuccess:task responseObject:responseObject completion:^{
                     if (kHTTPStatusCodeNotModified == [(id)task.response statusCode]) {
                         if (success) success(task, [self cachedResponseObject:task]);
                     } else {
                         eTag = ((NSHTTPURLResponse *)task.response).allHeaderFields[kHTTPHeaderFieldETag];
                         if (eTag.length) [self.service setValue:eTag forURLString:URLString];
                         if (success) success(task, responseObject);
                     }
                 }];
             }
             failure:^(NSURLSessionDataTask * task, NSError * error) {
                 [self handleFailure:task error:error];
             }];
}

// Load cache data from NSURLCache
- (id)cachedResponseObject:(NSURLSessionDataTask *)task
{
    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:task.originalRequest];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    return [responseSerializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:nil];
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success
{
    NSParameterAssert(URLString.length > 0);
    [self setHTTPHeaderFields];
    
    return [self PATCH:URLString
            parameters:[parameters toDictionary]
               success:^(NSURLSessionDataTask * task, id responseObject) {
                   [self handleSuccess:task responseObject:responseObject completion:^{
                       if (success) success(task, responseObject);
                   }];
               }
               failure:^(NSURLSessionDataTask * task, NSError * error) {
                   [self handleFailure:task error:error];
               }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
{
    NSParameterAssert(URLString.length > 0);
    [self setHTTPHeaderFields];
    
    return [self POST:URLString
           parameters:[parameters toDictionary]
             progress:nil
              success:^(NSURLSessionDataTask * task, id responseObject) {
                  [self handleSuccess:task responseObject:responseObject completion:^{
                      if (success) success(task, responseObject);
                  }];
              }
              failure:^(NSURLSessionDataTask * task, NSError * error) {
                  [self handleFailure:task error:error];
              }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(void (^)(NSProgress *))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
{
    NSParameterAssert(URLString.length > 0);
    [self setHTTPHeaderFields];
    if (!parameters) parameters = [JSONModel model];
    
    return [self POST:URLString
           parameters:[parameters toDictionary] constructingBodyWithBlock:block
             progress:uploadProgress
              success:^(NSURLSessionDataTask * task, id responseObject) {
                  [self handleSuccess:task responseObject:responseObject completion:^{
                      if (success) success(task, responseObject);
                  }];
              }
              failure:^(NSURLSessionDataTask * task, NSError * error) {
                  [self handleFailure:task error:error];
              }];
}

- (NSURLSessionDownloadTask *)downloadTaskWithURLString:(NSString *)URLString
                                               progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                            destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                      completionHandler:(void (^)(NSURLResponse *response, NSURL * filePath, NSError * error))completionHandler
{
    NSParameterAssert(URLString.length > 0);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    return [self downloadTaskWithRequest:request
                                progress:downloadProgressBlock
                             destination:destination
                       completionHandler:completionHandler];
}

- (void)handleSuccess:(NSURLSessionDataTask *)task responseObject:(id)responseObject completion:(SYNoParameterBlockType)completion
{
    [SVProgressHUD dismiss];
    if (completion) completion();
}

- (void)handleFailure:(NSURLSessionDataTask *)task error:(NSError *)error
{
    [SVProgressHUD dismiss];
    
#if DEBUG
    NSLog(@"HTTP ERROR: %@", error);
    NSLog(@"RESPONSE STATUS: %@", task.response);
#endif
    
    switch (error.code) {
        case NSURLErrorTimedOut:
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            break;
            
        case NSURLErrorDNSLookupFailed:
            [SVProgressHUD showErrorWithStatus:HUD_NETWORK_UNSTABLE];
            break;
            
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
            [SVProgressHUD showErrorWithStatus:HUD_CANNOT_CONNECT_TO_HOST];
            break;
            
        case NSURLErrorNotConnectedToInternet:
            [SVProgressHUD showErrorWithStatus:HUD_NOT_CONNECTED_TO_INTERNET];
            break;
            
        default:
            [self handleResponseResult:(id)task.response];
            break;
    }
}

- (void)handleResponseResult:(NSHTTPURLResponse *)response
{
    switch (response.statusCode) {
        case kHTTPStatusCodeNotAcceptable: {
            SYHTTPErrorCode errorCode = [response.allHeaderFields[kHTTPHeaderFieldErrorCode] unsignedIntegerValue];
            switch (errorCode) {
                case SYHTTPErrorCodeAccessTokenInvalid:
                    if ([GVUserDefaults standardUserDefaults].isSignedIn) {
                        [GVUserDefaults standardUserDefaults].isSignedIn = NO;
                        [[UIAlertController alertControllerWithTitle:TITLE_KICK_OUT message:MSG_SIGNIN_AGAIN] show];
                    }
                    break;
                    
                case SYHTTPErrorCodeAppVersionUnavailable: {
                    UIAlertAction *okay = [UIAlertAction actionWithTitle:BUTTON_TITLE_OKAY style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        [[UIApplication sharedApplication] openURL:[SYAppSetting defaultAppSetting].appStoreURL];
                    }];
                    [[UIAlertController alertControllerWithTitle:TITLE_VERSION_INVALID message:MSG_APP_VERSION_UNAVAILABLE actions:@[okay]] show];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
            
        case kHTTPStatusCodeForbidden:
        case kHTTPStatusCodeNotFound: {
            NSString *tipMessage = response.allHeaderFields[kHTTPHeaderFieldHUDMessage];
            if (tipMessage.length) [SVProgressHUD showErrorWithStatus:tipMessage];
            break;
        }
    }
}

@end
