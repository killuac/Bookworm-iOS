//
//  SYSocketManager.h
//  Bookworm
//
//  Created by Killua Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

@import SocketRocket;

FOUNDATION_EXPORT NSString *const SYSocketDidSendMessageNotification;
FOUNDATION_EXPORT NSString *const SYSocketDidReadMessageNotification;
FOUNDATION_EXPORT NSString *const SYSocketDidReceiveReceiptNotification;
FOUNDATION_EXPORT NSString *const SYSocketDidReceiveMessageNotification;

typedef NS_ENUM(NSUInteger, SYSocketStatusCode) {
    SYSocketStatusCodeConnected = 1000,         // Connected IM server
    SYSocketStatusCodeOkay = 1001,              // Delete/Read okay
    SYSocketStatusCodeReceipt = 1002,           // Receive receipt after send successful
    SYSocketStatusCodeMessage = 1003,           // Receive message
    SYSocketStatusCodeNotification = 1004,      // Receive push notification
    SYSocketStatusCodeClosed = 2000             // Close connection
};

@class SYMessageService;

@interface SYSocketManager : NSObject

+ (instancetype)manager;

@property (nonatomic, assign, readonly) SRReadyState readyState;
@property (nonatomic, assign, readonly) BOOL isConnecting;
@property (nonatomic, strong, readonly) SYMessageService *messageService;

- (void)connect;
- (void)disconnect;

- (void)sendMessageWithModel:(id)model;
- (void)readMessagesFromSenderWithModel:(id)model;
- (void)deleteSingleMessageWithModel:(id)model;
- (void)deleteMessagesFromContactWithModel:(id)model;

@end
