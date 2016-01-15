//
//  NSTimer+Factory.h
//  Bookworm
//
//  Created by Killua Liu on 1/15/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Factory)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector;

@end
