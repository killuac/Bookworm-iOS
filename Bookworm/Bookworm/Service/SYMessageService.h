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

- (void)updateIsReadStatusFromReceiver:(NSString *)userID;
- (void)updateIsSentStatusWithModel:(SYMessageModel *)messageModel;

- (SYMessageModel *)findLastMessageWithContact:(NSString *)contactID;

@end
