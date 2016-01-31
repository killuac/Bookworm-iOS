//
//  SYContactService.h
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYMessageService.h"
#import "SYContactModel.h"

@interface SYContactService : SYBaseService

@property (nonatomic, strong, readonly) NSArray<SYContactModel*> *contacts;

@end
