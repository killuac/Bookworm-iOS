//
//  SYMessageService.h
//  Bookworm
//
//  Created by Killua Liu on 12/21/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYBaseService.h"
#import "SYSocketModel.h"

@interface SYMessageService : SYBaseService

@property (nonatomic, strong, readonly) SYMessageModel *lastInboxMessage;
@property (nonatomic, strong, readonly) SYMessageModel *lastOutboxMessage;
@property (nonatomic, assign, readonly) NSUInteger totalUnreadMessageCount;

- (void)sendMessageWithContent:(NSString *)content toReceiverID:(NSString *)userID;
- (void)updateInboxWithSenderID:(NSString *)userID;
- (void)updateOutboxWithModel:(SYMessageModel *)messageModel;

- (void)findAllOutgoingMessages:(SYServiceBlockType)result;
- (void)findLastOneWithContactID:(NSString *)userID result:(SYServiceBlockType)result;

@end
