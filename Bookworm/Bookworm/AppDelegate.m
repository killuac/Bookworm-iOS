//
//  AppDelegate.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDB.h"
#import "MobClick.h"
#import "SYAppSetting.h"
#import "SYServerAPI.h"
#import "SYDeviceService.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "TestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupApplication];
    
#ifdef TEST_MODE
    TestViewController *vc = [[TestViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window makeKeyAndVisible];
#else
    if ([GVUserDefaults standardUserDefaults].isSignedIn) {
        NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        [self.window.rootViewController showMainViewControllerWithUserInfo:userInfo];
    } else {
        [self.window.rootViewController showInitialViewController];
    }
#endif
    
    return YES;
}

- (void)setupApplication
{
    [self updateApplication];
    [self setupAppearance];
    [self setupUMeng];
    [self registerNotification];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

- (void)setupAppearance
{
    [UITableView appearance].backgroundColor = [UIColor backgroundColor];
    [UICollectionView appearance].backgroundColor = [UIColor backgroundColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor defaultTitleColor]} forState:UIControlStateSelected];
    [UINavigationBar appearance].tintColor = [UIColor defaultTitleColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor defaultTitleColor]};
    
    [UIPageControl appearance].pageIndicatorTintColor = [UIColor whiteColor];
    [UIPageControl appearance].currentPageIndicatorTintColor = [UIColor grayColor];
    [UIPageControl appearance].backgroundColor = [UIColor backgroundColor];
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

- (void)updateApplication
{
    if ([SYAppSetting defaultAppSetting].isAppUpdated) {
        [self alterDatabase];
        [SYServerAPI fetchAndSave];
    }
}

- (void)alterDatabase
{
    FMDatabase *database = [FMDatabase databaseWithPath:DATABASE_FILE_PATH];
    [database open];
    [database setShouldCacheStatements:YES];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bookworm" ofType:@"sql"];
    NSString *sql = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [database executeStatements:sql];
    [database close];
}

/**
 *  Register device when app is first launch and network is avaiable
 */
- (void)checkNetworkReachability
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (AFNetworkReachabilityStatusNotReachable == status) {
            [SVProgressHUD showErrorWithStatus:TIP_NO_CONNECTION];
        } else {
            if ([GVUserDefaults standardUserDefaults].isFirstLaunch) {
                [self registerDevice];
            }
        }
    }];
}

- (void)registerDevice
{
    SYDeviceModel *deviceModel = [SYDeviceModel model];
    [[SYDeviceService service] createWithModel:deviceModel result:^(id service, id result) {
        [GVUserDefaults standardUserDefaults].isFirstLaunch = NO;
    }];
}

#pragma mark - Notification
- (void)registerNotification
{
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:charSet];
    
    if (![[GVUserDefaults standardUserDefaults].deviceToken isEqualToString:deviceTokenString]) {
        [GVUserDefaults standardUserDefaults].deviceToken = deviceTokenString;
        [self updateDeviceToken];
    }
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [self closeRemoteNotification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState != UIApplicationStateActive && [GVUserDefaults standardUserDefaults].isSignedIn) {
        [self.window.rootViewController showMainViewControllerWithUserInfo:userInfo];
    }
}

- (void)updateDeviceToken
{
    NSString *deviceToken = [GVUserDefaults standardUserDefaults].deviceToken;
    
    SYDeviceModel *deviceModel = [SYDeviceModel model];
    deviceModel.deviceToken = deviceToken;
    deviceModel.allowPush = (deviceToken.length > 0);
    [[SYDeviceService service] updateWithModel:deviceModel result:nil];
}

- (void)closeRemoteNotification
{
    [GVUserDefaults standardUserDefaults].deviceToken = @"";
    [self updateDeviceToken];
}

#pragma mark - Application activity
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self checkNetworkReachability];
    
    if ([GVUserDefaults standardUserDefaults].isSignedIn) {
//      TODO: Connect IM server
    }
    
    if ([UIApplication sharedApplication].isRegisteredForRemoteNotifications) {
        [self updateDeviceToken];
    } else {
        [self closeRemoteNotification];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

@end
