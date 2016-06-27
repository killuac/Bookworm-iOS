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

- (void)fetchIMServerAddressCompletion:(SYVoidBlockType)completion;

@property (nonatomic, copy) NSString *imServers;            // Fetch IM server address by HTTP API
@property (nonatomic, copy, readonly) NSURL *imServerURL;   // Available IM server address(use IP to accelerate connect)

@property (nonatomic, copy) NSString *signIn;
@property (nonatomic, copy) NSString *devices;
@property (nonatomic, copy) NSString *users;

@end
