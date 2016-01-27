//
//  SYSocketModel.m
//  Bookworm
//
//  Created by Killua Liu on 1/26/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYSocketModel.h"

@implementation SYSocketRequestModel

@end

@implementation SYSocketResponseModel

@end


@implementation SYMessageModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return ([propertyName isEqualToString:@"isSent"] || [propertyName isEqualToString:@"isRead"]);
}

@end
