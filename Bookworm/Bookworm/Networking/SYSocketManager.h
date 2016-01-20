//
//  SYSocketManager.h
//  Bookworm
//
//  Created by Killua Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const SYSocketDidSendMessageNotification;
FOUNDATION_EXPORT NSString *const SYSocketDidReceiveMessageNotification;
FOUNDATION_EXPORT NSString *const SYSocketDidReadMessageNotification;
FOUNDATION_EXPORT NSString *const SYSocketReconnectingNotification;

@interface SYSocketManager : NSObject

+ (instancetype)manager;

- (void)connect;
- (void)disconnect;

- (void)sendMessage:(NSString *)content toReceiver:(NSString *)userID;

@end
