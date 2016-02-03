//
//  SYSoundPlayer.h
//  Bookworm
//
//  Created by Killua Liu on 1/31/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYSoundPlayer : NSObject

+ (void)playMessageSentSound;
+ (void)playMessageSentAlert;
+ (void)playMessageReceivedSound;
+ (void)playMessageReceivedAlert;

+ (void)playMessageReceivedVibrate;

@end
