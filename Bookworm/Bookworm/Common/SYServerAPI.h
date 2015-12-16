//
//  SYServerAPI.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SYServerAPI : JSONModel

+ (instancetype)sharedServerAPI;
+ (void)writeAPIFile;

@property (nonatomic, copy) NSString *imAddress;
@property (nonatomic, copy) NSString *device;
@property (nonatomic, copy) NSString *user;

@end
