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

@end
