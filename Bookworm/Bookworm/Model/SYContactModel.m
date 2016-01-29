//
//  SYContactModel.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYContactModel.h"

@implementation SYContactModel

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    return [propertyName isEqualToString:@"unreadMessageCount"];
}

- (BOOL)isFollowed
{
    return (SYContactRelationshipFollowing == self.relationship || SYContactRelationshipFriend == self.relationship);
}

@end
