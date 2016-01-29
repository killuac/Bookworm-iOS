//
//  SYUserModel.h
//  Bookworm
//
//  Created by Killua Liu on 1/28/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SYAccountModel : JSONModel

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *password;

@end


@interface SYProfileModel : JSONModel

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign) BOOL gender;
@property (nonatomic, strong) NSURL *avatarURL;

@end


@interface SYUserModel : SYProfileModel

@property (nonatomic, assign) NSUInteger bookCount;
@property (nonatomic, assign) NSUInteger followerCount;
@property (nonatomic, assign) NSUInteger followingCount;

@end
