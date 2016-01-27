//
//  SYMessageService.m
//  Bookworm
//
//  Created by Killua Liu on 12/21/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYMessageService.h"

@implementation SYMessageService

- (SYMessageModel *)lastInboxMessage
{
    return nil;
}

- (SYMessageModel *)lastOutboxMessage
{
    return nil;
}

- (void)saveWithModels:(NSArray *)models result:(SYServiceBlockType)result
{
    
}

- (void)updateIsReadStatusForReceiver:(NSString *)userID
{
    
}

- (void)updateIsSentStatusWithModel:(SYMessageModel *)messageModel
{
    
}

@end
