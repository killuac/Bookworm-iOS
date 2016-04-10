//
//  CLLocationManager+Factory.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void (^LocationBlockType)(CLLocationManager *manager);

@interface CLLocationManager (Factory)

+ (instancetype)managerWithBlock:(LocationBlockType)block;  // Must use "weakSelf" in block

@end
