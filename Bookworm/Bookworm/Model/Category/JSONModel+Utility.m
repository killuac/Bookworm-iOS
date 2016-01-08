//
//  JSONModel+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "JSONModel+Utility.h"

@implementation JSONModel (Utility)

- (void)setIsSelected:(BOOL)isSelected
{
    objc_setAssociatedObject(self, @selector(isSelected), @(isSelected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSelected
{
    return objc_getAssociatedObject(self, @selector(isSelected));
}

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
