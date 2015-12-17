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
+ (void)fetchAndSave;

@property (nonatomic, copy) NSString *IMServerURLString;

@property (nonatomic, copy) NSString *devicesURLString;
@property (nonatomic, copy) NSString *signInURLString;
@property (nonatomic, copy) NSString *usersURLString;

@end
