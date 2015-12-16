//
//  NSDate+Utility.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility)

- (NSString *)toString
{
    return [[self toDateString] stringByAppendingFormat:@" %@", [self toTimeString]];
}

- (NSString *)toDateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    return [formatter stringFromDate:self];
}

- (NSString *)toShortDateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    return [formatter stringFromDate:self];
}

- (NSString *)toTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterMediumStyle;
    return [formatter stringFromDate:self];
}

- (NSString *)toShortTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    return [formatter stringFromDate:self];
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
