//
//  SYNotificationModel.h
//  Bookworm
//
//  Created by Killua Liu on 2/26/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSUInteger, SYNotificationType) {
    SYNotificationTypeDefault = 0,
    SYNotificationTypeChat = 1,
    SYNotificationTypeExchange = 2
};

@interface SYAlertModel : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;

@end

@interface SYAPSModel : JSONModel

@property (nonatomic, copy) SYAlertModel *alert;
@property (nonatomic, copy) NSString<Optional> *sound;
@property (nonatomic, copy) NSString<Optional> *category;
@property (nonatomic, assign) NSUInteger badge;

@end

@interface SYNotificationModel : JSONModel

@property (nonatomic, strong) SYAPSModel *aps;
@property (nonatomic, assign) SYNotificationType type;
@property (nonatomic, copy) NSString<Optional> *sender;

@end
