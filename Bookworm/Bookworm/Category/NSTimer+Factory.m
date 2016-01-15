//
//  NSTimer+Factory.m
//  Bookworm
//
//  Created by Killua Liu on 1/15/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "NSTimer+Factory.h"

@implementation NSTimer (Factory)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:timeInterval target:target selector:selector userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];   // Make timer contine while draggning or scrolling
    [timer fire];
    
    return timer;
}

@end
