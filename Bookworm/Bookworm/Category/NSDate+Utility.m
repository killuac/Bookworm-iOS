//
//  NSDate+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility)

// Creating a date formatter is not a cheap operation.
// If use a formatter frequently, it is typically more efficient to cache a single instance.
static NSDateFormatter *sharedDateFormatter = nil;

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDateFormatter = [[NSDateFormatter alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NSCurrentLocaleDidChangeNotification
                                                          object:nil
                                                           queue:[NSOperationQueue currentQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          [sharedDateFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
                                                      }];
    });
}

+ (instancetype)dateWithString:(NSString *)string
{
    [sharedDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [sharedDateFormatter dateFromString:string];
}

- (NSString *)toString
{
    return [[self toDateString] stringByAppendingFormat:@" %@", [self toTimeString]];
}

- (NSString *)toDateString
{
    [sharedDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [sharedDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [sharedDateFormatter stringFromDate:self];
}

- (NSString *)toShortDateString
{
    [sharedDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [sharedDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [sharedDateFormatter stringFromDate:self];
}

- (NSString *)toTimeString
{
    [sharedDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [sharedDateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    return [sharedDateFormatter stringFromDate:self];
}

- (NSString *)toShortTimeString
{
    [sharedDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [sharedDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [sharedDateFormatter stringFromDate:self];
}

- (BOOL)isToday
{
    NSDate *now = [NSDate date];
    return [[self toDateString] isEqualToString:[now toDateString]];
}

- (BOOL)isYesterday
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [calendar components:unit fromDate:self toDate:now options:0];
    
    return (comps.year == 0 && comps.month == 0 && comps.day == 1);
}

- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowComps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (dateComps.year == nowComps.year);
}

@end
