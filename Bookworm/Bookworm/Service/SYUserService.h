//
//  SYUserService.h
//  Bookworm
//
//  Created by Killua Liu on 12/21/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYBaseService.h"
#import "SYUserModel.h"

@interface SYUserService : SYBaseService

@property (nonatomic, strong, readonly) SYUserModel *userModel;

@end
