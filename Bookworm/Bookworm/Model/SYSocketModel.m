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
        self.messageID = ++[GVUserDefaults standardUserDefaults].maxOutboxMessageID;
        self.sender = [GVUserDefaults standardUserDefaults].userID;
        self.receiver = userID;
        self.content = content;
        self.isPending = YES;
        _dateTime = [NSDate date];
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return ([propertyName isEqualToString:@"isPending"] || [propertyName isEqualToString:@"isRead"]);
}

- (NSComparisonResult)compare:(SYMessageModel *)object
{
    return [@(self.timestamp) compare:@(object.timestamp)];
}

- (void)setTimestamp:(NSUInteger)timestamp
{
    _timestamp = timestamp;
    _dateTime = [NSDate dateWithTimeIntervalSince1970:timestamp];
}

- (BOOL)isInboxMessage
{
    return [self.receiver isEqualToString:[GVUserDefaults standardUserDefaults].userID];
}

@end
