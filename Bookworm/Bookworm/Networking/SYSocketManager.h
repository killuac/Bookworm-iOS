//
//  SYSocketManager.h
//  Bookworm
//
//  Created by Killua Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <SocketRocket/SRWebSocket.h>

FOUNDATION_EXPORT NSString *const SYSocketDidReceiveMessageNotification;

typedef NS_ENUM(NSUInteger, SYSocketStatusCode) {
    SYSocketStatusCodeConnected = 1000,         // Connected IM server
    SYSocketStatusCodeOkay = 1001,              // Delete/Read okay
    SYSocketStatusCodeReceipt = 1002,           // Receive receipt after send successful
    SYSocketStatusCodeMessage = 1003,           // Receive message
    SYSocketStatusCodeNotification = 1004,      // Receive push notification
    SYSocketStatusCodeClosed = 2000             // Close connection
};

@class SYMessageModel;

@interface SYSocketManager : NSObject

+ (instancetype)manager;

@property (nonatomic, assign, readonly) SRReadyState readyState;
@property (nonatomic, assign, readonly) BOOL isConnecting;

- (void)connect;
- (void)disconnect;

- (void)sendMessage:(NSString *)content toReceiver:(NSString *)userID;
- (void)readMessagesFromReceiver:(NSString *)userID;
- (void)deleteMessagesFromReceiver:(NSString *)userID;
- (void)deleteSingleMessage:(SYMessageModel *)messageModel;

@end
