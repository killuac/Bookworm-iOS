//
//  AppDelegate+Analytics.m
//  Bookworm
//
//  Created by Killua Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "AppDelegate+Analytics.h"
#import "SYScrollViewController.h"

NSString *const SYLogPageViewName = @"SYLogPageViewName";
NSString *const SYLogTrackedEvents = @"SYLogTrackedEvents";
NSString *const SYLogEventName = @"SYLogEventName";
NSString *const SYLogEventSelectorName = @"SYLogEventSelectorName";
NSString *const SYLogEventHandlerBlock = @"SYLogEventHandlerBlock";

typedef void (^SYAspectHandlerBlock)(id<AspectInfo> aspectInfo);


@interface AppDelegate ()

@property (nonatomic, strong) NSDictionary *configs;

@end

@implementation AppDelegate (Analytics)

- (void)setupAppAnalytics
{
    [self setupUMeng];
    [self loadConfiguration];
    [self setupWithConfiguration];
}

- (void)setupUMeng
{
    NSString *appKey = [SYAppSetting defaultAppSetting].umengAppKey;
#if DEBUG
    [MobClick startWithAppkey:appKey reportPolicy:REALTIME channelId:@"Development"];
#else
    [MobClick startWithAppkey:appKey reportPolicy:BATCH channelId:@"App Store"];
#endif
    [MobClick setAppVersion:XcodeAppVersion];
    
    if ([GVUserDefaults standardUserDefaults].isSignedIn) {
        [MobClick profileSignInWithPUID:[GVUserDefaults standardUserDefaults].userId];
    }
}

- (void)loadConfiguration
{
    self.configs = @{
            @"SYMainViewController": @{
                    SYLogTrackedEvents: @[
                            @{ SYLogEventName: @"button one clicked", SYLogEventSelectorName: @"buttonOneClicked:",
                               SYLogEventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                                   NSLog(@"button one clicked");
                               },
                               },
                            @{ SYLogEventName: @"button two clicked", SYLogEventSelectorName: @"buttonTwoClicked:" } ]
                    },
            @"SYDetailViewController": @{ SYLogPageViewName: @"Detail page view" }
            };
}

- (void)setConfigs:(NSDictionary *)configs
{
    objc_setAssociatedObject(self, @selector(configs), configs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)configs
{
    return objc_getAssociatedObject(self, @selector(configs));
}

// aspectInfo.instance is not thread safe, so only call this method in main thread.
- (NSString *)pageViewNameForAspectInfo:(id<AspectInfo>)aspectInfo
{
    NSString *className = NSStringFromClass([aspectInfo.instance class]);
    NSString *pageViewName = self.configs[className][SYLogPageViewName];
    
    return (pageViewName ? pageViewName : className);
}

- (void)setupWithConfiguration
{
//  Hook view controllers
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        if ([self isNeedLoggingForAspectInfo:aspectInfo]) {
            NSString *pageViewName = [self pageViewNameForAspectInfo:aspectInfo];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [MobClick beginLogPageView:pageViewName];
            });
        }
    } error:NULL];
    
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        if ([self isNeedLoggingForAspectInfo:aspectInfo]) {
            NSString *pageViewName = [self pageViewNameForAspectInfo:aspectInfo];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [MobClick endLogPageView:pageViewName];
            });
        }
    } error:NULL];
    
//  Hook events
    for (NSString *className in self.configs.allKeys) {
        Class clazz = NSClassFromString(className);
        NSDictionary *config = self.configs[className];
        
        for (NSDictionary *event in config[SYLogTrackedEvents]) {
            SEL selector = NSSelectorFromString(event[SYLogEventSelectorName]);
            SYAspectHandlerBlock block = event[SYLogEventHandlerBlock];
            
            [clazz aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if (block) {
                        block(aspectInfo);
                    } else {
                        [MobClick event:event[SYLogEventName]];
                    }
                });
            } error:NULL];
        }
    }
}

- (BOOL)isNeedLoggingForAspectInfo:(id<AspectInfo>)aspectInfo
{
    return ([NSStringFromClass([aspectInfo.instance class]) hasPrefix:@"SY"] &&
            ![aspectInfo.instance isMemberOfClass:[SYScrollViewController class]]);
}

@end
