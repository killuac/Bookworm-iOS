//
//  CLLocationManager+Base.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void (^SYLocationBlockType)(CLLocationManager *manager);

@interface CLLocationManager (Base)

+ (void)updateLocationsCompletion:(SYLocationBlockType)completion;

@end
