//
//  CLLocationManager+Factory.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "CLLocationManager+Factory.h"
#import "AppDelegate.h"

@interface CLLocationManager (Private) <CLLocationManagerDelegate>

@property (nonatomic, copy) LocationBlockType block;

@end

@implementation CLLocationManager (Factory)

- (void)setBlock:(LocationBlockType)block
{
    objc_setAssociatedObject(self, @selector(block), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (LocationBlockType)block
{
    return objc_getAssociatedObject(self, @selector(block));
}

+ (instancetype)managerWithBlock:(LocationBlockType)block
{
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    manager.distanceFilter = 100;
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    manager.delegate = manager;
    manager.block = block;
    [(id)[UIApplication sharedApplication].delegate setLocationManager:manager];
    
    if ([CLLocationManager locationServicesEnabled]) {
        if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [manager requestWhenInUseAuthorization];
        } else {
            [manager startUpdatingLocation];
        }
    }
    return manager;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (kCLAuthorizationStatusAuthorizedWhenInUse == status) {
        [manager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    if (self.block) self.block(manager);
}

@end
