//
//  JSONModel+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "JSONModel+Utility.h"

@implementation JSONModel (Utility)

+ (instancetype)model
{
    return [[self alloc] init];
}

+ (instancetype)modelWithString:(NSString *)string
{
    NSError *error = nil;
    return [[self alloc] initWithString:string error:&error];
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict
{
    NSError *error = nil;
    return [[self alloc] initWithDictionary:dict error:&error];
}

+ (instancetype)modelWithData:(NSData *)data
{
    NSError *error=nil;
    return [[self alloc] initWithData:data error:&error];
}

@end
