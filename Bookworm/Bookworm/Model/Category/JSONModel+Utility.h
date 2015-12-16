//
//  JSONModel+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "JSONValueTransformer+Mapper.h"

@interface JSONModel (Utility)

+ (instancetype)model;
+ (instancetype)modelWithString:(NSString *)string;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithData:(NSData *)data;

@end
