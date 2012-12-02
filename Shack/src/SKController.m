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

- (void)awakeFromNib {
    [[self songTable] setTarget:self];
    [[self songTable] setDoubleAction:@selector(doubleClickSongItem:)];
}

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

- (void)doubleClickSongItem:(id)sender {
    NSInteger clickedRowNumber = [[self songTable] clickedRow];
    NSLog(@"\n-> clicked row: %ld\n", clickedRowNumber);
    
    NSButton *button = [self playPauseButton];
    if ([SKAudioPlayer startPlayingSongAtIndex:clickedRowNumber]) {
        [button setTitle:@"Pause"];
    } else {
        [button setTitle:@"Play"];
    }
}

@end
