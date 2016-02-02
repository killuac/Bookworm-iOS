//
//  JSONModel+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "JSONModel+Utility.h"

@implementation JSONModel (Utility)

+ (void)load
{
    SwizzleMethod(self, @selector(toDictionary), @selector(swizzle_toDictionary), NO);
}

- (NSDictionary *)swizzle_toDictionary
{
    NSMutableDictionary *dictionary = [[self swizzle_toDictionary] mutableCopy];
    NSArray *sortedKeys = [dictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableArray *keyValuePairs = [NSMutableArray array];
    [sortedKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *kvPair = [NSString stringWithFormat:@"%@=%@", key, dictionary[key]];
        [keyValuePairs addObject:kvPair];
    }];
    
    NSString *paramString = [keyValuePairs componentsJoinedByString:@","];
    dictionary[@"signature"] = [[NSString stringWithFormat:@"%@%@", paramString, [SYAppSetting defaultAppSetting].signatureSalt] toSHA1String];
    return dictionary;
}

- (void)setIsSelected:(BOOL)isSelected
{
    objc_setAssociatedObject(self, @selector(isSelected), @(isSelected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSelected
{
    return [objc_getAssociatedObject(self, @selector(isSelected)) boolValue];
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
