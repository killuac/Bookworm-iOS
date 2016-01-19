//
//  AppDelegate+Logging.m
//  Bookworm
//
//  Created by Bing Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "AppDelegate+Logging.h"
#import "MobClick.h"
@import Aspects;

NSString *const SYLoggingPageImpression = @"SYLoggingPageImpression";
NSString *const SYLoggingTrackedEvents = @"SYLoggingTrackedEvents";
NSString *const SYLoggingEventName = @"SYLoggingEventName";
NSString *const SYLoggingEventSelectorName = @"SYLoggingEventSelectorName";
NSString *const SYLoggingEventHandlerBlock = @"SYLoggingEventHandlerBlock";

typedef void (^SYAspectHandlerBlock)(id<AspectInfo> aspectInfo);

@implementation AppDelegate (Logging)

- (void)setupAppLogging
{
    [self setupUMeng];
    [self setupWithConfiguration];
}

- (void)setupUMeng
{
    NSString *appKey = @"";
#if DEBUG
    [MobClick startWithAppkey:appKey reportPolicy:REALTIME channelId:@"Development"];
#else
    [MobClick startWithAppkey:appKey reportPolicy:BATCH channelId:@"App Store"];
#endif
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick setEncryptEnabled:YES];
}

- (NSDictionary *)loadConfiguration
{
    return @{
             @"MainViewController": @{
                     SYLoggingTrackedEvents: @[
                             @{ SYLoggingEventName: @"button one clicked", SYLoggingEventSelectorName: @"buttonOneClicked:",
                                SYLoggingEventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                                    NSLog(@"button one clicked");
                                },
                                },
                             @{ SYLoggingEventName: @"button two clicked", SYLoggingEventSelectorName: @"buttonTwoClicked:" } ]
                     },
             @"DetailViewController": @{ SYLoggingPageImpression: @"Detail page view" }
            };
}

- (void)setupWithConfiguration
{
    NSDictionary *configs = [self loadConfiguration];
    
//  Hook page views
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *className = NSStringFromClass([[aspectInfo instance] class]);
            NSString *pageImp = configs[className][SYLoggingPageImpression];
            if (pageImp) [MobClick beginLogPageView:pageImp];
        });
    } error:NULL];
    
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *className = NSStringFromClass([[aspectInfo instance] class]);
            NSString *pageImp = configs[className][SYLoggingPageImpression];
            if (pageImp) [MobClick beginLogPageView:pageImp];
        });
    } error:NULL];
    
// Hook events
    for (NSString *className in configs) {
        Class clazz = NSClassFromString(className);
        NSDictionary *config = configs[className];
        
        for (NSDictionary *event in config[SYLoggingTrackedEvents]) {
            SEL selector = NSSelectorFromString(event[SYLoggingEventSelectorName]);
            SYAspectHandlerBlock block = event[SYLoggingEventHandlerBlock];
            
            [clazz aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [MobClick beginEvent:event[SYLoggingEventName]];
                    if (block) block(aspectInfo);
                });
            } error:NULL];
        }
    }
}

@end
