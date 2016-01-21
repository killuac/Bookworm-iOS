//
//  SYDeviceModel.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SYDeviceModel : JSONModel

@property (nonatomic, copy, readonly) NSString *deviceID;
@property (nonatomic, copy, readonly) NSString *deviceBrand;
@property (nonatomic, copy, readonly) NSString *deviceModel;
@property (nonatomic, copy, readonly) NSString *systemName;
@property (nonatomic, copy, readonly) NSString *systemVersion;
@property (nonatomic, copy, readonly) NSString *resolution;

@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, assign) BOOL allowPush;

@end
