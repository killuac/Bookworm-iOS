//
//  SYUtilities.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UUID_STRING             [UIDevice currentDevice].identifierForVendor.UUIDString
#define IS_IOS_VERSION_9        (TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0)

#define APP_VERSION             [NSBundle mainBundle].localizedInfoDictionary[@"CFBundleShortVersionString"]
#define APP_BUNDLE_NAME         [NSBundle mainBundle].localizedInfoDictionary[@"CFBundleName"]
#define APP_DISPLAY_NAME        [NSBundle mainBundle].localizedInfoDictionary[@"CFBundleDisplayName"]
#define APP_COPYRIGHT           [NSBundle mainBundle].localizedInfoDictionary[@"NSHumanReadableCopyright"]

#define SCREEN_SCALE            [UIScreen mainScreen].scale
#define SCREEN_BOUNDS           [UIScreen mainScreen].bounds
#define SCREEN_SIZE             SCREEN_BOUNDS.size
#define SCREEN_WIDTH            SCREEN_SIZE.width
#define SCREEN_HEIGHT           SCREEN_SIZE.height
#define SCREEN_CENTER           CGPointMake(CGRectGetMidX(SCREEN_BOUNDS), CGRectGetMidY(SCREEN_BOUNDS))
#define RESOLUTION_SIZE         [UIScreen mainScreen].preferredMode.size

#define DECLARE_WEAK_SELF       __weak typeof(self) weakSelf = self

typedef void (^SYVoidBlockType)(void);

NS_INLINE CGFloat SYRadianFromDegree(CGFloat degree) { return (degree * M_PI / 180.0); }

NS_INLINE void SYDispatchMainAsync(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), block);
}
NS_INLINE void SYDispatchGlobalAsync(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
NS_INLINE void SYDispatchMainAfter(NSTimeInterval delay, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), block);
}

FOUNDATION_EXPORT NSURL *SYDocumentFileURL(NSString *fileName);
FOUNDATION_EXPORT NSURL *SYCacheFileURL(NSString *fileName);
FOUNDATION_EXPORT NSURL *SYTemporaryFileURL(NSString *fileName);
FOUNDATION_EXPORT NSURL *SYApplicationSupportFileURL(NSString *fileName);
FOUNDATION_EXPORT NSURL *SYPlistFileURL(NSString *fileName);

FOUNDATION_EXPORT NSArray *SYClassGetSubClasses(Class superClass);
FOUNDATION_EXPORT void SYSwizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector, BOOL isClassMethod);
