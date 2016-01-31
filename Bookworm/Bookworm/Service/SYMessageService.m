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
        self.totalUnreadMessageCount = [self getUnreadMessageCount];
    }
    return self;
}

- (NSUInteger)getUnreadMessageCount
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

- (void)saveWithModels:(NSArray<SYMessageModel*> *)models result:(SYServiceBlockType)result
{
    // TODO: Save data to database
    
    NSIndexSet *indexSet = [models indexesOfObjectsPassingTest:^BOOL(SYMessageModel *messageModel, NSUInteger idx, BOOL *stop) {
        return ([messageModel.receiver isEqualToString:self.userID] && !messageModel.isRead);
    }];
    self.totalUnreadMessageCount += indexSet.count;
}

- (void)updateIsReadStatusFromReceiver:(NSString *)userID
{
    
}

- (void)updateIsSentStatusWithModel:(SYMessageModel *)messageModel
{
    
}

- (void)deleteByKey:(NSString *)key
{
    
}

- (SYMessageModel *)findLastMessageWithContact:(NSString *)contactID
{
    return nil;
}

@end
