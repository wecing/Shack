//
//  SKAudioPlayer.m
//  Shack
//
//  Created by Chenguang Wang on 10/29/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKAudioPlayer.h"
#import "SKPlaylistManager.h"

static int songIndex = -1;
static AVAudioPlayer *audioPlayer = nil;

@implementation SKAudioPlayer

// FIXME: songIndex keeps track of the song we are currently playing.
//
//        when the user deletes songs, we check if the playing song is to be deleted.
//        if so, we will just stop playing and reset audioPlayer and songIndex.

+ (void)play {
    if (audioPlayer != nil) {
        BOOL success = [audioPlayer play];
        if (!success) {
            NSLog(@"failed to start playing song %d", songIndex);
            NSLog(@"AVAudioPlayer object: %@", audioPlayer);
        }
    } else {
        NSArray *list = [SKPlaylistManager playlist];
        if ([list count] != 0) {
            // FIXME: make cycling optional.
            songIndex = (songIndex + 1) % [list count];
            
            NSError *error = nil;
            // NSDictionary *d = [list objectAtIndex:songIndex];
            // NSURL *url = [NSURL URLWithString:[d objectForKey:@"location"]];
            NSURL *url = [NSURL fileURLWithPath:@"/Users/wecing/Music/everything else/Amiina/Puzzle/03 What are we Waiting for?.mp3"];
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            
            [audioPlayer setDelegate:[self sharedInstance]];
            
            if (error != nil) {
                NSLog(@"Error: %@", error);
            } else {
                [audioPlayer play];
            }
        }
    }
}

+ (void)pause {
    if (audioPlayer != nil) {
        [audioPlayer pause];
    }
}

+ (id)sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        audioPlayer = nil; // phew!
        // we will advance songIndex by 1 in play.
        [SKAudioPlayer play];
    } else {
        NSLog(@"failed to play audio: player=%@", player);
    }
}

@end
