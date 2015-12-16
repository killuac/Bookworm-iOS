//
//  NSDate+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)

- (NSString *)toString;
- (NSString *)toDateString;
- (NSString *)toTimeString;
- (NSString *)toShortDateString;
- (NSString *)toShortTimeString;

- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isThisYear;

@end
