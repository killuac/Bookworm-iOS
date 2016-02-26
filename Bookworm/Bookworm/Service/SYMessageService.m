//
//  SYMessageService.m
//  Bookworm
//
//  Created by Killua Liu on 12/21/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYMessageService.h"

@implementation SYMessageService

- (instancetype)init
{
    if (self = [super init]) {
        self.totalUnreadMessageCount = [self countForUnreadMessage];
    }
    return self;
}

- (NSUInteger)countForUnreadMessage
{
    return 0;
}

+ (BOOL)automaticallyNotifiesObserversOfTotalUnreadMessageCount
{
    return NO;
}

- (void)setTotalUnreadMessageCount:(NSUInteger)totalUnreadMessageCount
{
    [self willChangeValueForKey:@"totalUnreadMessageCount"];
    _totalUnreadMessageCount = totalUnreadMessageCount;
    [self didChangeValueForKey:@"totalUnreadMessageCount"];
}

- (SYMessageModel *)lastInboxMessage
{
    return nil;
}

- (SYMessageModel *)lastOutboxMessage
{
    return nil;
}

#pragma mark - Update and save
- (void)sendMessageWithContent:(NSString *)content toReceiverID:(NSString *)userID
{
    
    [[SYSocketManager manager] readMessagesFromSenderWithModel:[SYMessageModel modelWithContent:content contactID:userID]];
}

- (void)saveWithModels:(NSArray<SYMessageModel*> *)models result:(SYServiceBlockType)result
{
//  TODO: Save data to database
    
    self.totalUnreadMessageCount = [self countForUnreadMessage];
}

// READ: the message content is sender's userID
- (void)updateIsReadStatusWithSenderID:(NSString *)userID
{
//  TODO: Update isRead status
    self.totalUnreadMessageCount = [self countForUnreadMessage];
    [[SYSocketManager manager] readMessagesFromSenderWithModel:[SYMessageModel modelWithContent:userID contactID:nil]];
}

- (void)updateIsSendingStatusWithModel:(SYMessageModel *)messageModel
{
//  TODO: Update isSending status
}

- (void)deleteWithModel:(SYMessageModel *)model result:(SYServiceBlockType)result
{
    
    [[SYSocketManager manager] deleteMessagesFromContactWithModel:model];
}

// DELETE: the message content is contact's userID
- (void)deleteByKey:(NSString *)userID result:(SYServiceBlockType)result
{
    
    [[SYSocketManager manager] deleteMessagesFromContactWithModel:[SYMessageModel modelWithContent:userID contactID:nil]];
}

#pragma mark - Find
- (void)findAllPendingMessages:(SYServiceBlockType)result
{
//  TODO:
}

- (void)findByParameters:(NSArray *)parameters result:(SYServiceBlockType)result
{
//    NSString *userID = parameters.firstObject;
//    NSDate *date = parameters.lastObject;
}

- (void)findLastOneWithContactID:(NSString *)userID result:(SYServiceBlockType)result
{
    
}

@end
