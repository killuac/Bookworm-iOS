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
- (void)createWithModel:(id)model result:(SYServiceBlockType)result
{
//  TODO: Create entry
}

- (void)sendMessageWithContent:(NSString *)content toReceiverID:(NSString *)userID
{
    SYMessageModel *messageModel = [SYMessageModel modelWithContent:content contactID:userID];
    [self createWithModel:messageModel result:nil];
    [[SYSocketManager manager] sendMessageWithModel:messageModel];
}

- (void)saveWithModels:(NSArray<SYMessageModel *> *)models result:(SYServiceBlockType)result
{
//  TODO: Save data to database
    
    self.totalUnreadMessageCount = [self countForUnreadMessage];
}

// READ: the message content is sender's userID
- (void)updateInboxWithSenderID:(NSString *)userID
{
//  TODO: Update isRead status
    self.totalUnreadMessageCount = [self countForUnreadMessage];
    [[SYSocketManager manager] readMessagesFromSenderWithModel:[SYMessageModel modelWithContent:userID contactID:nil]];
}

- (void)updateOutboxWithModel:(SYMessageModel *)messageModel
{
//  TODO: Update isPending status and timestamp
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
- (void)findAllOutgoingMessages:(SYServiceBlockType)result
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
