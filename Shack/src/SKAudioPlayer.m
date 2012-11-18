//
//  SKAudioPlayer.m
//  Shack
//
//  Created by Chenguang Wang on 10/29/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKAudioPlayer.h"
#import "SKPlaylistManager.h"
#import "WKAudioStreamer.h"

// stream no more than 3 locations at the same time.
#define MAX_PARALLEL_STREAMED 3

@interface SKAudioPlayer () <WKAudioStreamerDelegate>
@end

// map location to WKAudioStreamer instances.
static NSMutableDictionary *streamer_dict = nil;
static WKAudioStreamer *streamer = nil;
static NSMutableArray *cur_streamed_locs = nil;

@implementation SKAudioPlayer

+ (void)initialize {
    streamer_dict = [NSMutableDictionary new];
    cur_streamed_locs = [NSMutableArray new];
}

+ (void)play {
    if (streamer == nil && [[SKPlaylistManager playlist] count] > 0) {
        [self startPlayingSongAtIndex:0];
    } else {
        [streamer play];
    }
}

+ (void)pause {
    if (streamer != nil) {
        [streamer pause];
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

// force re-streaming songs iff the song requested is exactly the currently playing one.
+ (void)startPlayingSongAtIndex:(NSInteger)idx {
    NSLog(@"\n-> startPlayingSongAtIndex:%ld called", idx);
    
    NSArray *song_list = [SKPlaylistManager playlist];
    if (idx >= [song_list count]) {
        return;
    }
    
    NSLog(@"Hi? 1");
    
    NSString *loc = [(NSDictionary *)[song_list objectAtIndex:idx] objectForKey:@"location"];
    
    // FIXME: add stop to WKAudioStreamer!!!!!!!!!!!!!!!!!!!!!!
    
    if (streamer == nil) {
        NSLog(@"Hi? 2");
        // no active streamer
        streamer = [WKAudioStreamer streamerWithURLString:loc delegate:[self sharedInstance]];
        [streamer_dict setObject:streamer forKey:loc];
        [cur_streamed_locs addObject:loc];
        [streamer play];
    } else if ([[streamer requestedURL] isEqualToString:loc]) {
        NSLog(@"Hi? 3");
        // exactly the currently playing one, re-stream
        [streamer pause];
        streamer = [WKAudioStreamer streamerWithURLString:loc delegate:[self sharedInstance]];
        [streamer_dict setObject:streamer forKey:loc];
        [streamer play];
    } else {
        NSLog(@"Hi? 4");
        // the requested url is not the same as the currently playing one (streamer != nil)
        [streamer pause];
        streamer = [streamer_dict objectForKey:loc];
        
        // FIXME: hmm... maybe it's too rude.
        //        it will only keep the streamer wanted.
        [streamer_dict removeAllObjects];
        [cur_streamed_locs removeAllObjects];
        
        if (streamer == nil) {
            // loc is not already streamed
            streamer = [WKAudioStreamer streamerWithURLString:loc delegate:[self sharedInstance]];
        }
        [streamer_dict setObject:streamer forKey:loc];
        [cur_streamed_locs addObject:loc];
        
        [streamer play];
    }
}

- (void)onStreamingFinished:(WKAudioStreamer *)_streamer {
    @synchronized(self) {
        NSLog(@"\n-> streaming finished.");
    }
}

- (void)onPlayingFinished:(WKAudioStreamer *)_streamer {
    @synchronized(self) {
        NSLog(@"\n-> playing finished.");
    }
}

- (void)onDataReceived:(WKAudioStreamer *)_streamer
                  data:(NSData *)newData {
    @synchronized(self) {
    }
}

- (void)onErrorOccured:(WKAudioStreamer *)_streamer
                 error:(NSError *)error {
    NSLog(@"\n-> Error occured! %@", error);
}

@end
