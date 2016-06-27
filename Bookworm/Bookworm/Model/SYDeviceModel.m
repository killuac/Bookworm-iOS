//
//  SYDeviceModel.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYDeviceModel.h"
#import <sys/utsname.h>

@implementation SYDeviceModel

- (NSString *)deviceID
{
    return UUID_STRING;
}

- (NSString *)deviceBrand
{
    return @"Apple";
}

- (NSString *)deviceModel
{
//    return [UIDevice currentDevice].localizedModel;
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
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
    return [NSString stringWithFormat:@"%@: %@ %@ %@", self.deviceBrand, self.deviceModel, self.systemName, self.systemVersion];
}

- (NSString *)languageID
{
    return [GVUserDefaults standardUserDefaults].languageID;
}

@end
