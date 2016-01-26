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

@end
