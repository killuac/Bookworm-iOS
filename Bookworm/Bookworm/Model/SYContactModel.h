//
//  SYContactModel.h
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYUserModel.h"
#import "SYSocketModel.h"

typedef NS_ENUM(NSUInteger, SYContactRelationship) {
    SYContactRelationshipStranger = 0,
    SYContactRelationshipFollowing,
    SYContactRelationshipFollower,
    SYContactRelationshipFriend
};

@interface SYContactModel : SYProfileModel

@property (nonatomic, copy) NSString *contactID;
@property (nonatomic, assign) SYContactRelationship relationship;
@property (nonatomic, assign, readonly) BOOL isFollowed;
@property (nonatomic, assign) BOOL isBlocked;
@property (nonatomic, strong) NSData *bgImageData;

@property (nonatomic, assign) NSUInteger unreadMessageCount;
@property (nonatomic, strong) SYMessageModel<Ignore> *lastMessage;
@property (nonatomic, strong) NSArray<SYMessageModel, Ignore> *messages;

@end
