//
//  SYDeviceModel.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYDeviceModel.h"

@implementation SYDeviceModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return [propertyName isEqualToString:@"allowPush"];
}

- (NSString *)deviceID
{
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

- (NSString *)deviceBrand
{
    return @"Apple";
}

- (NSString *)deviceModel
{
    return [UIDevice currentDevice].model;
}

- (NSString *)systemName
{
    return [UIDevice currentDevice].systemName;
}

- (NSString *)systemVersion
{
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)resolution
{
    return [NSString stringWithFormat:@"%.fx%.f", RESOLUTION_SIZE.height, RESOLUTION_SIZE.width];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@ %@ %@ %@", self.deviceBrand, self.deviceModel, self.systemName, self.systemVersion, self.resolution];
}

@end
