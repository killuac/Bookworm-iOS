//
//  SYSocketManager.m
//  Bookworm
//
//  Created by Killua Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYSocketManager.h"
#import "SYMessageService.h"

#define HEART_BEAT_INTERVAL     25.0
#define RECONNECT_DELAY         2.0
#define RECONNNECT_MAX_COUNT    15

NSString *const SYSocketMethodChat = @"CHAT";
NSString *const SYSocketMethodSync = @"SYNC";
NSString *const SYSocketMethodRead = @"READ";
NSString *const SYSocketMethodDelete = @"DELETE";

NSString *const SYSocketDidSendMessageNotification = @"SYSocketDidSendMessageNotification";
NSString *const SYSocketDidReadMessageNotification = @"SYSocketDidReadMessageNotification";
NSString *const SYSocketDidReceiveReceiptNotification = @"SYSocketDidReceiveReceiptNotification";
NSString *const SYSocketDidReceiveMessageNotification = @"SYSocketDidReceiveMessageNotification";


@interface SYSocketManager () <SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *webSocket;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger reconnectCount;

@end

@implementation SYSocketManager

+ (instancetype)manager
{
    static dispatch_once_t predicate;
    static SYSocketManager *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _messageService = [SYMessageService service];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(disconnect)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)instantiateWebSocket
{
    NSURL *serverURL = [NSURL URLWithString:[SYServerAPI sharedServerAPI].imServerAddress];
    if (serverURL) {
        _webSocket = [[SRWebSocket alloc] initWithURL:serverURL];
        self.webSocket.delegate = self;
        [self.webSocket setDelegateOperationQueue:[[NSOperationQueue alloc] init]];
    }
}

+ (BOOL)automaticallyNotifiesObserversOfReadyState
{
    return NO;
}

- (void)setReadyState:(SRReadyState)readyState
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self willChangeValueForKey:@"readyState"];
        _readyState = readyState;
        [self didChangeValueForKey:@"readyState"];
    });
}

- (void)dealloc
{
    [self invalidateHeartBeat];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Connection
- (BOOL)isConnecting
{
    return (self.webSocket.readyState == SR_CONNECTING);
}

- (BOOL)isConnected
{
    return (self.webSocket.readyState == SR_OPEN);
}

- (void)connect
{
    [self instantiateWebSocket];
    self.readyState = self.webSocket.readyState;
    [self.webSocket open];
}

- (void)reconnect
{
    self.reconnectCount++;
    [self invalidateHeartBeat];
    
    [[SYServerAPI sharedServerAPI] fetchIMServerAddressCompletion:^{
        [self performSelector:@selector(connect) withObject:nil afterDelay:RECONNECT_DELAY];
    }];
}

- (void)disconnect
{
    [self invalidateHeartBeat];
    [self.webSocket close];
}

- (void)scheduleHeartBeat
{
    [self invalidateHeartBeat];
    _timer = [NSTimer scheduledRepeatTimerWithTimeInterval:HEART_BEAT_INTERVAL target:self selector:@selector(heartBeat)];
}

- (void)heartBeat
{
    if (!self.isConnected) {
        [self invalidateHeartBeat]; return;
    }
    
    NSString *random = [NSString stringWithFormat:@"%05tu", arc4random_uniform(100000)];
    [self.webSocket sendPing:[random dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)invalidateHeartBeat
{
    [self.timer invalidate];
}

#pragma mark - Message
- (void)sendMessage:(id)model withMethod:(NSString *)socketMethod
{
    if (!self.isConnected) return;
    
    SYSocketRequestModel *requestModel = [SYSocketRequestModel model];
    requestModel.socketMethod = socketMethod;
    requestModel.messageData = [model toJSONString];
    [self.webSocket send:[requestModel toJSONString]];
    
//  Reschedule timer for save network resource (Heart beat is only sent at idle time)
    [self scheduleHeartBeat];
}

- (void)sendMessageWithModel:(id)model
{
    [self sendMessage:@[model] withMethod:SYSocketMethodChat];
    [self postNotificationName:SYSocketDidSendMessageNotification object:model];
}

// Don't need post notification again while sending outgoing messages
- (void)sendOutgoingMessages
{
    [self.messageService findAllOutgoingMessages:^(NSArray *result) {
        [self sendMessage:result withMethod:SYSocketMethodChat];
    }];
}

- (void)readMessagesFromSenderWithModel:(id)model
{
    [self sendMessage:model withMethod:SYSocketMethodRead];
    [self postNotificationName:SYSocketDidReadMessageNotification object:model];
}

- (void)deleteSingleMessageWithModel:(id)model
{
    [self sendMessage:model withMethod:SYSocketMethodDelete];
}

- (void)deleteMessagesFromContactWithModel:(id)model
{
    [self sendMessage:model withMethod:SYSocketMethodDelete];
}

- (void)synchronizeMessages
{
    NSArray *messageModels = @[self.messageService.lastInboxMessage, self.messageService.lastOutboxMessage];
    [self sendMessage:messageModels withMethod:SYSocketMethodSync];
}

- (void)postNotificationName:(NSString *)name object:(nullable id)object
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    });
}

#pragma mark - WebSocket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
#ifdef DEBUG
    NSLog(@"Websocket connected");
#endif

    [self scheduleHeartBeat];
    self.readyState = self.webSocket.readyState;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
#ifdef DEBUG
    NSLog(@"Received message: \"%@\"", message);
#endif
    
    self.reconnectCount = 0;
    if (![message hasPrefix:@"{"]) return;  // Must be JSON format
    
    SYSocketResponseModel *responseModel = [SYSocketResponseModel modelWithString:message];
    switch (responseModel.statusCode) {
        case SYSocketStatusCodeConnected:
            [self synchronizeMessages];
            [self sendOutgoingMessages];
            break;
            
        case SYSocketStatusCodeReceipt: {
            SYMessageModel *messageModel = [SYMessageModel modelWithString:responseModel.messageData];
            [self.messageService updateOutboxWithModel:messageModel];
            [self postNotificationName:SYSocketDidReceiveReceiptNotification object:messageModel];
            break;
        }
            
        case SYSocketStatusCodeMessage: {
            NSMutableArray<SYMessageModel*> *messageModels = [JSONModel arrayOfModelsFromString:responseModel.messageData error:nil];
            [messageModels sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]]];
            [self.messageService saveWithModels:messageModels result:^(id result) {
                [self postNotificationName:SYSocketDidReceiveMessageNotification object:messageModels];
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
#ifdef DEBUG
    NSLog(@"Websocket failed with error: %@" , error);
#endif
    
    if (self.reconnectCount < RECONNNECT_MAX_COUNT) {
        [self reconnect];
    } else {
        self.readyState = self.webSocket.readyState;
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
#ifdef DEBUG
    NSLog(@"WebSocket closed: Code: %zd and Reason: %@", code, reason);
#endif
    
    [self invalidateHeartBeat];
    self.readyState = self.webSocket.readyState;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
#ifdef DEBUG
    NSLog(@"Websocket received pong: %@", [NSString stringWithUTF8String:pongPayload.bytes]);
#endif
}

@end
