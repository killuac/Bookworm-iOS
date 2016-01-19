//
//  SYSocketManager.m
//  Bookworm
//
//  Created by Bing Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYSocketManager.h"
#import <SocketRocket/SRWebSocket.h>
#import "SYServerAPI.h"
@import AFNetworking;

#define RECONNNECT_MAX_COUNT    5
#define HEART_BEAT_INTERVAL     25.0
#define RECONNECT_DELAY         10.0

NSString *const BZSocketDidSendMessageNotification = @"BZSocketDidSendMessageNotification";
NSString *const BZSocketDidReceiveMessageNotification = @"BZSocketDidReceiveMessageNotification";
NSString *const BZSocketDidReadMessageNotification = @"BZSocketDidReadMessageNotification";
NSString *const BZSocketReconnectingNotification = @"BZSocketReconnectingNotification";

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
        [self instantiateWebSocket];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(connect)
                                                     name:AFNetworkingReachabilityDidChangeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(disconnect)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)instantiateWebSocket
{
    _webSocket = nil;
    NSURL *serverURL = [NSURL URLWithString:[SYServerAPI sharedServerAPI].IMServerAddress];
    _webSocket = [[SRWebSocket alloc] initWithURL:serverURL];
    self.webSocket.delegate = self;
}

- (void)dealloc
{
    [self invalidateHeartBeat];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Connection
- (BOOL)isOpen
{
    return (self.webSocket.readyState == SR_OPEN);
}

- (BOOL)isConnecting
{
    return (self.webSocket.readyState == SR_CONNECTING);
}

- (void)connect
{
    if (!self.isConnecting) return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.webSocket open];
    });
}

- (void)reconnect
{
    [self invalidateHeartBeat];
    if (self.reconnectCount >= RECONNNECT_MAX_COUNT) return;
    
    self.reconnectCount++;
    [[NSNotificationCenter defaultCenter] postNotificationName:BZSocketReconnectingNotification object:self];
    
    [[SYServerAPI sharedServerAPI] fetchIMServerAddressCompletion:^{
        [self instantiateWebSocket];
        [self performSelector:@selector(connect) withObject:nil afterDelay:RECONNECT_DELAY];
    }];
}

- (void)disconnect
{
    [self invalidateHeartBeat];
    [self sendMessage:@"" withType:@"Offline"];
    [self.webSocket close];
}

- (void)scheduleHeartBeat
{
    [self invalidateHeartBeat];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:HEART_BEAT_INTERVAL
                                                  target:self
                                                selector:@selector(heartBeat)];
}

- (void)heartBeat
{
    if (!self.isOpen) return;
    
    NSString *random = [NSString stringWithFormat:@"%05tu", arc4random_uniform(100000)];
    [self.webSocket sendPing:[random dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)invalidateHeartBeat
{
    [self.timer invalidate];
}

#pragma mark - Message
- (void)sendMessage:(NSString *)content withType:(NSString *)type toReceiver:(NSString *)userId;
{
    if (self.isOpen) return;
    
//  TODO: Send message by JSON format
    [self.webSocket send:content];
}

- (void)sendMessage:(NSString *)content withType:(NSString *)type
{
    [self sendMessage:content withType:type toReceiver:@""];
}

- (void)sendMessage:(NSString *)content toReceiver:(NSString *)userID
{
    
}

- (void)synchronizeInbox
{
    
}

- (void)synchronizeOutbox
{
    
}

#pragma mark - WebSocket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
#ifdef DEBUG
    NSLog(@"Websocket connected");
#endif

    [self scheduleHeartBeat];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
#ifdef DEBUG
    NSLog(@"Received message: \"%@\"", message);
#endif
    
    self.reconnectCount = 0;
    if (![message hasPrefix:@"{"]) return;  // Must be JSON format
    
//  TODO: Handle different type messages
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
#ifdef DEBUG
    NSLog(@"Websocket failed with error: %@" , error);
#endif
    
    [self reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
#ifdef DEBUG
    NSLog(@"WebSocket closed: Code: %zd and Reason: %@", code, reason);
#endif
    
    [self invalidateHeartBeat];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
#ifdef DEBUG
    NSLog(@"Websocket received pong: %@", [NSString stringWithUTF8String:pongPayload.bytes]);
#endif
}

@end
