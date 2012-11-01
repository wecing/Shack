//
//  SKController.m
//  Shack
//
//  Created by Chenguang Wang on 10/22/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKController.h"
#import "SKAudioPlayer.h"

@implementation SKController

// why do we need the "stop" button?

// FIXME: disable play button when current playlist is empty?

- (IBAction)togglePlayPause:(id)sender {
    NSButton *button = [self playPauseButton];
    if ([[button title] isEqualToString:@"Play"]) {
        [button setTitle:@"Pause"];
        [SKAudioPlayer play];
    } else {
        [button setTitle:@"Play"];
        [SKAudioPlayer pause];
    }
}

@end
