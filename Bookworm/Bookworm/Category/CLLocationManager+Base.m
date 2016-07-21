//
//  CLLocationManager+Base.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "CLLocationManager+Base.h"

@interface CLLocationManager (Private) <CLLocationManagerDelegate>

@property (nonatomic, copy) SYLocationBlockType block;

@end

@implementation CLLocationManager (Base)

static void *kLocationManagerKey = &kLocationManagerKey;

- (void)setBlock:(SYLocationBlockType)block
{
    objc_setAssociatedObject(self, @selector(block), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SYLocationBlockType)block
{
    return objc_getAssociatedObject(self, @selector(block));
}

+ (void)updateLocationsCompletion:(SYLocationBlockType)completion
{
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    manager.distanceFilter = 100;
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    manager.delegate = manager;
    manager.block = completion;
    objc_setAssociatedObject([UIApplication sharedApplication], kLocationManagerKey, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if ([CLLocationManager locationServicesEnabled]) {
        if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [manager requestWhenInUseAuthorization];
        } else {
            [manager startUpdatingLocation];
        }
    }
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
    objc_setAssociatedObject([UIApplication sharedApplication], kLocationManagerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
