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

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        NSMutableArray *selfKeys = [[self toDictionary].allKeys mutableCopy];
        [selfKeys removeObject:@"bgImageData"];
        NSData *selfData = [self toJSONDataWithKeys:selfKeys];
        
        NSMutableArray *objectKeys = [[other toDictionary].allKeys mutableCopy];
        [objectKeys removeObject:@"bgImageData"];
        NSData *otherData = [self toJSONDataWithKeys:selfKeys];
        
        return [[selfData toMD5String] isEqualToString:[otherData toMD5String]];
    }
}

@end
