//
//  AppDelegate.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Analytics.h"
#import "SYDeviceService.h"
#import "SYNotificationModel.h"
#import "TestViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) SYDeviceService *deviceService;

@end

@implementation AppDelegate

#pragma mark - Setup
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupApplication];
    
#ifdef TEST_MODE
    TestViewController *vc = [[TestViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window makeKeyAndVisible];
#else
    if ([GVUserDefaults standardUserDefaults].isSignedIn) {
        [self.window.rootViewController showMainViewController];
    } else {
        [self.window.rootViewController showInitialViewController];
    }
#endif
    
    return YES;
}

- (void)setupApplication
{
//    [self updateApplication];
    [self setupAppearance];
    [self setupAppAnalytics];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
//  Observe user sign in or sign out
    GVUserDefaults *userDefaults = [GVUserDefaults standardUserDefaults];
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:userDefaults keyPath:@"isSignedIn" options:NSKeyValueObservingOptionNew
                          block:^(id observer, id object, NSDictionary *change) {
                              if (userDefaults.isSignedIn) {
                                  [[SYSocketManager manager] connect];
                                  [MobClick profileSignInWithPUID:[GVUserDefaults standardUserDefaults].userID];
                              } else {
                                  [[SYSocketManager manager] disconnect];
                                  [MobClick profileSignOff];
                              }
                          }];
}

- (void)updateApplication
{
    _deviceService = [SYDeviceService service];
    
    if ([SYAppSetting defaultAppSetting].isAppUpdated) {
        [self updateLocalDatabase];
        [SYServerAPI fetchAndSave];
    }
}

- (void)updateLocalDatabase
{
    FMDatabase *database = [FMDatabase databaseWithPath:DATABASE_FILE_PATH];
    [database open];
    [database setShouldCacheStatements:YES];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bookworm" ofType:@"sql"];
    NSString *sql = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [database executeStatements:sql];
    [database close];
}

- (void)setupAppearance
{
    [UITableView appearance].backgroundColor = [UIColor backgroundColor];
    [UICollectionView appearance].backgroundColor = [UIColor backgroundColor];
    
    [UITabBar appearance].translucent = NO;
    [UITabBar appearance].tintColor = [UIColor tintColor];
    
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].tintColor = [UIColor tintColor];
//    [UINavigationBar appearance].barTintColor = [UIColor primaryColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName:[UIFont boldTitleFont], NSForegroundColorAttributeName:[UIColor titleColor]};
    
    [UIPageControl appearance].pageIndicatorTintColor = [UIColor whiteColor];
    [UIPageControl appearance].currentPageIndicatorTintColor = [UIColor grayColor];
    [UIPageControl appearance].backgroundColor = [UIColor backgroundColor];
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
    NSString *newDeviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:charSet];
    
    if (![[GVUserDefaults standardUserDefaults].deviceToken isEqualToString:newDeviceToken]) {
        [GVUserDefaults standardUserDefaults].deviceToken = newDeviceToken;
        [self updateDeviceToken];
    }
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [self closeRemoteNotification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    if (application.applicationState == UIApplicationStateActive) return;
    
    if ([GVUserDefaults standardUserDefaults].isSignedIn) {
        SYNotificationModel *payload = [SYNotificationModel modelWithDictionary:userInfo];
        switch (payload.type) {
            case SYNotificationTypeChat:
                // TODO: Show chat view controller
                break;
                
            case SYNotificationTypeExchange:
                // TODO: Show exchange book request view controller
                break;
                
            default:
                break;
        }
    } else {
        [self.window.rootViewController showMainViewController];
    }
    
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)updateDeviceToken
{
    SYDeviceModel *deviceModel = [SYDeviceModel model];
    deviceModel.deviceToken = [GVUserDefaults standardUserDefaults].deviceToken;
    deviceModel.allowPush = [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
    [self.deviceService updateWithModel:deviceModel result:nil];
}

- (void)closeRemoteNotification
{
    if ([GVUserDefaults standardUserDefaults].deviceToken.length > 0) {
        [GVUserDefaults standardUserDefaults].deviceToken = @"";
        [self updateDeviceToken];
    }
}

#pragma mark - App Life Cycle
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (AFNetworkReachabilityStatusNotReachable == status) {
            [SVProgressHUD showErrorWithStatus:HUD_NOT_CONNECTED_TO_INTERNET];
        } else {
            [self registerNotification];
            
            if ([GVUserDefaults standardUserDefaults].isFirstLaunch) {
                [self registerDevice];
            }
            
            if ([GVUserDefaults standardUserDefaults].isSignedIn) {
                [[SYSocketManager manager] connect];
            }
        }
    }];
}

// Register device when app is first launch and network is avaiable
- (void)registerDevice
{
    SYDeviceModel *deviceModel = [SYDeviceModel model];
    [self.deviceService createWithModel:deviceModel result:^(id result) {
        [GVUserDefaults standardUserDefaults].isFirstLaunch = NO;
    }];
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
