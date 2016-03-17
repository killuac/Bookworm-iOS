//
//  JSONModel+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "NSArray+Model.h"
#import "JSONValueTransformer+Mapper.h"

@interface JSONModel (Utility)

@property (nonatomic, assign) BOOL isSelected;

+ (instancetype)model;
+ (instancetype)modelWithString:(NSString *)string;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithData:(NSData *)data;

- (NSDictionary *)toDictionaryWithSignature;

@end
