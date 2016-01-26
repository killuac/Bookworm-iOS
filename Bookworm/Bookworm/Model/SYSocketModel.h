//
//  SYSocketModel.h
//  Bookworm
//
//  Created by Killua Liu on 1/26/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SYSocketRequestModel : JSONModel

@property (nonatomic, copy) NSString *socketMethod;             // CHAT/READ/DELETE
@property (nonatomic, copy) NSString<Optional> *messageData;    // Is a JSON string

@end

@interface SYSocketResponseModel : JSONModel

@property (nonatomic, assign) SYSocketStatusCode statusCode;
@property (nonatomic, copy) NSString<Optional> *messageData;    // Is a JSON string

@end


@interface SYMessageModel : JSONModel

@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *receiver;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, strong) NSDate *dateTime;

@end