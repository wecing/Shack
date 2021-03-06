//
//  SKController.m
//  Shack
//
//  Created by Chenguang Wang on 10/22/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKController.h"
#import "SKAudioPlayer.h"

static id shared = nil;
static int busy_cnt = 0;

@implementation SKController

+ (id)sharedInstance {
    id ret = shared;
    if (ret == nil) {
        ret = [[SKController alloc] init];
    }
    return ret;
}

- (id)init {
    self = [super init];
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared = self;
    });
    return shared;
}

- (void)awakeFromNib {
    [[self songTable] setTarget:self];
    [[self songTable] setDoubleAction:@selector(doubleClickSongItem:)];
    
    [[self busyIndicator] setDisplayedWhenStopped:NO];
}

// why do we need the "stop" button?

// FIXME: disable play button when current playlist is empty?

+ (void)playIfNotPaused {
    SKController *controller = [self sharedInstance];
    NSButton *but = [controller playPauseButton];
    if ([[but title] isEqualToString:@"Play"] && [SKAudioPlayer curIdx] == -1) {
        [but setTitle:@"Pause"];
        [SKAudioPlayer play];
    }
}

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

    // deselect all items.
    [[self songTable] selectRowIndexes:[NSIndexSet new] byExtendingSelection:NO];
}

+ (void)busy {
    busy_cnt++;
    if (busy_cnt > 0) {
        [[[self sharedInstance] busyIndicator] startAnimation:self];
    }
}

+ (void)busyDone {
    busy_cnt--;
    if (busy_cnt == 0) {
        [[[self sharedInstance] busyIndicator] stopAnimation:self];
    }
}

- (IBAction)onDeleteKeyPressed:(id)sender {
    NSLog(@"\n-> delete pressed!"); // DEBUG
    
    [SKAudioPlayer removeIndexes:[[self songTable] selectedRowIndexes]];

    // deselect all items.
    [[self songTable] selectRowIndexes:[NSIndexSet new] byExtendingSelection:NO];
    
    if ([SKAudioPlayer curIdx] == -1) {
        [[self playPauseButton] setTitle:@"Play"];
    }
}

+ (void)fastForward {
    [SKAudioPlayer fastForward];
}

+ (void)rewind {
    [SKAudioPlayer rewind];
}


@end
