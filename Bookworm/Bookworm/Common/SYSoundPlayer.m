//
//  SYSoundPlayer.m
//  Bookworm
//
//  Created by Killua Liu on 1/31/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYSoundPlayer.h"
@import AudioToolbox;

@implementation SYSoundPlayer

+ (void)playMessageSentSound
{
    AudioServicesPlaySystemSound(1004);
}

+ (void)playMessageReceivedSound
{
    AudioServicesPlaySystemSound(1003);
}

+ (void)playMessageReceivedVibrate
{
	AudioServicesPlaySystemSound(1011);
}

@end
