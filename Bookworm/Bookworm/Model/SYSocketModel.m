//
//  SYSocketModel.m
//  Bookworm
//
//  Created by Killua Liu on 1/26/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYSocketModel.h"

@implementation SYSocketRequestModel

@end

@implementation SYSocketResponseModel

@end


@implementation SYMessageModel

+ (instancetype)modelWithContent:(NSString *)content contactID:(NSString *)userID
{
    return [[self alloc] initWithContent:content contactID:userID];
}

- (instancetype)initWithContent:(NSString *)content contactID:(NSString *)userID
{
    if (self = [super init]) {
        self.sender = [GVUserDefaults standardUserDefaults].userID;
        self.receiver = userID;
        self.content = content;
        self.timestamp = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return ([propertyName isEqualToString:@"isSending"] || [propertyName isEqualToString:@"isRead"]);
}

- (NSDate<Ignore> *)dateTime
{
    return [NSDate dateWithTimeIntervalSince1970:self.timestamp];
}

- (BOOL)isInboxMessage
{
    return [self.receiver isEqualToString:[GVUserDefaults standardUserDefaults].userID];
}

@end
