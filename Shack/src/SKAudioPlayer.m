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
#import "SKController.h"
#import "SKSongTableController.h"

// save data of no more than 3 songs at once.
#define MAX_SONGS_SAVED 3

@interface SKAudioPlayer () <WKAudioStreamerDelegate>
@end

// map location to WKAudioStreamer instances.
static NSMutableDictionary *streamer_dict = nil;
// static NSMutableArray *cur_streamed_locs = nil;
static WKAudioStreamer *streamer = nil;
static int cur_idx = -1;
static BOOL cur_playing = NO;
// static NSString *cur_loc = nil;

@implementation SKAudioPlayer

+ (void)initialize {
    streamer_dict = [NSMutableDictionary new];
    // cur_streamed_locs = [NSMutableArray new];
}

+ (int)curIdx {
    return cur_idx;
}

+ (BOOL)curPlaying {
    return cur_playing;
}

+ (BOOL)play {
    BOOL ret;
    if (streamer == nil && [[SKPlaylistManager playlist] count] > 0) {
        ret = [self startPlayingSongAtIndex:0];
    } else {
        ret = [streamer play];
    }
    if (cur_playing != ret) {
        cur_playing = ret;
        [SKSongTableController tableReloadData];
    }
    return ret;
}

+ (BOOL)pause {
    BOOL ret;
    if (streamer != nil) {
        ret = [streamer pause];
    } else {
        ret = NO;
    }
    
    if (cur_playing == ret) {
        cur_playing = !ret;
        [SKSongTableController tableReloadData];
    }
    return ret;
}

+ (id)sharedInstance {
    // it returns exactly the same singleton object which init returns.
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    self = [super init];
    
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = self;
    });
    return shared;
}

// force re-streaming songs iff the song requested is exactly the currently playing one.
+ (BOOL)startPlayingSongAtIndex:(NSInteger)idx {
    BOOL ret;
    NSLog(@"\n-> startPlayingSongAtIndex:%ld called", idx);
    
    NSArray *song_list = [SKPlaylistManager playlist];
    if (idx >= [song_list count] || idx < 0) {
        NSLog(@"\n-> huh?");
        cur_idx = -1;
        cur_playing = NO;
        if (streamer != nil) {
            [streamer pause];
            streamer = nil;
        }
        [SKSongTableController tableReloadData];
        [[[self sharedInstance] progressLabel] setStringValue:@""];
        return NO;
    }
    
    // select the idx-th item.
    // [[[self sharedInstance] songTable] selectRowIndexes:[NSIndexSet indexSetWithIndex:idx] byExtendingSelection:NO];
    
    NSString *loc = [(NSDictionary *)[song_list objectAtIndex:idx] objectForKey:@"location"];
    
    if (streamer == nil) {
        NSLog(@"Hi? 2"); // DEBUG
        // no active streamer
        streamer = [WKAudioStreamer streamerWithURLString:loc delegate:[self sharedInstance]];
        [streamer_dict setObject:streamer forKey:loc];
        // cur_loc = loc;
        ret = [streamer play];
    } else if ([[streamer requestedURL] isEqualToString:loc]) {
        NSLog(@"Hi? 3"); // DEBUG
        // exactly the currently playing one
        [streamer restartStreaming]; // re-stream!
        ret = [streamer play];
    } else {
        NSLog(@"Hi? 4"); // DEBUG
        
        // the requested url is not the same as the currently playing one (streamer != nil)
        
        [streamer pause];
        [streamer pauseStreaming];
        
        streamer_dict = [self buildStreamerDict:(int)idx songList:song_list];
        
        BOOL old_streamer_blocked = [streamer isPlayerBlocking];
        streamer = [streamer_dict objectForKey:loc];
        
        if (old_streamer_blocked) {
            [SKController busyDone];
        }
        if ([streamer isPlayerBlocking]) {
            [SKController busy];
        }
        ret = [streamer play];
    }
    
    if (ret) {
        cur_idx = (int)idx;
        cur_playing = YES;
    }
    
    [SKSongTableController tableReloadData];
    
    return ret;
}

- (void)onStreamingFinished:(WKAudioStreamer *)_streamer {
    @synchronized(self) {
        NSLog(@"\n-> streaming finished."); // DEBUG
        
        NSArray *song_list = [SKPlaylistManager playlist];
        // int idx = [SKAudioPlayer findIdxInSongList:[_streamer requestedURL] songList:song_list];
        int idx = [SKAudioPlayer findLoc:[streamer requestedURL] inSongList:song_list];
        streamer_dict = [SKAudioPlayer buildStreamerDict:idx songList:song_list];
    }
}

- (void)onPlayingFinished:(WKAudioStreamer *)_streamer {
    @synchronized(self) {
        NSLog(@"\n-> playing finished."); // DEBUG
        
        NSArray *song_list = [SKPlaylistManager playlist];
        // int idx = [SKAudioPlayer findIdxInSongList:[_streamer requestedURL] songList:song_list];
        int idx = [SKAudioPlayer findLoc:[_streamer requestedURL] inSongList:song_list];
        idx = (idx + 1) % [song_list count];
        [SKAudioPlayer startPlayingSongAtIndex:idx];
        /*
        NSLog(@"\n-> new idx: %d", idx); // DEBUG
        NSString *next_url = [(NSDictionary *)[song_list objectAtIndex:idx] objectForKey:@"location"];
        streamer_dict = [SKAudioPlayer buildStreamerDict:idx songList:song_list];
        
        [streamer pause]; // is it possible that streamer != _streamer?
        streamer = [streamer_dict objectForKey:next_url];
        NSLog(@"%@", streamer); // DEBUG
        [streamer play];
        NSLog(@"hmm..."); // DEBUG
         */
    }
}

// + (int)findIdxInSongList:(NSString *)loc songList:(NSArray *)song_list {
+ (int)findLoc:(NSString *)loc inSongList:(NSArray *)song_list {
    int i = -1;
    for (NSDictionary *d in song_list) {
        i++;
        if ([loc isEqualToString:[d objectForKey:@"location"]]) {
            return i;
        }
    }
    return -1;
}

+ (NSMutableDictionary *)buildStreamerDict:(int)idx songList:(NSArray *)song_list {
    NSMutableDictionary *td = [NSMutableDictionary new];
    BOOL found_not_finished = NO;
    int t = (int)[song_list count];
    if (MAX_SONGS_SAVED < t) {
        t = MAX_SONGS_SAVED;
    }
    for (int i = 0; i < t; i++) {
        NSDictionary *d = [song_list objectAtIndex:((idx+i) % [song_list count])];
        NSString *url = [d objectForKey:@"location"];
        WKAudioStreamer *st = [streamer_dict objectForKey:url];
        if (st == nil) {
            st = [WKAudioStreamer streamerWithURLString:url delegate:[self sharedInstance]];
        }
        if (![st streamingFinished] && !found_not_finished) {
            [st startStreaming];
            found_not_finished = YES;
        }
        [td setObject:st forKey:url];
    }
    return td;
}

- (void)onDataReceived:(WKAudioStreamer *)_streamer
                  data:(NSData *)newData {
    @synchronized(self) {
    }
}

- (void)onErrorOccured:(WKAudioStreamer *)_streamer
                 error:(NSError *)error {
    // FIXME: next? restream?
    NSLog(@"\n-> Error occured! %@", error);
}

- (void)onPlayerPosChanged:(WKAudioStreamer *)_streamer
                       pos:(double)pos {
    if (_streamer != streamer) {
        return;
    }
    
    NSTextField *progress_label = [self progressLabel];
    
    NSString *(^pos2str)(int) = ^(int pos) {
        if (pos < 60) { // 0:59
            if (pos < 0) { pos = 0; }
            return [NSString stringWithFormat:@"0:%02d", pos];
        } else if (pos < 3600) { // 1:18, 13:07
            return [NSString stringWithFormat:@"%d:%02d", pos/60, pos%60];
        } else { // 35:01:17
            return [NSString stringWithFormat:@"%d:%02d:%02d", pos/3600, (pos%3600)/60, pos%60];
        }
    };
    
    NSString *progress_str = [NSString stringWithFormat:@"%@ / %@",
                              pos2str((int)pos),
                              pos2str((int)[streamer duration])];
    
    [progress_label setStringValue:progress_str];
}

- (void)onPlayerBlocked:(WKAudioStreamer *)_streamer {
    if (_streamer == streamer) {
        [SKController busy];
    }
}

- (void)onPlayerBlockingEnded:(WKAudioStreamer *)_streamer {
    if (_streamer == streamer) {
        [SKController busyDone];
    }
}

+ (void)reloadStreamerList {
    if (cur_idx == -1) {
        streamer_dict = [NSMutableDictionary new];
    } else {
        streamer_dict = [self buildStreamerDict:cur_idx songList:[SKPlaylistManager playlist]];
    }
}

+ (void)removeIndexes:(NSIndexSet *)indexes_set {
    // *** be careful ***
    // if indexes_set doesn't contain cur_idx, it's still playing!
    //
    // cur_idx may be -1!
    // indexes_set may contain all indexes!
    if ([indexes_set containsIndex:cur_idx]) {
        [streamer pause];
        streamer = nil;
    }
    
    int new_idx = 0; // yes, 0, not -1.
    NSArray *playlist = [SKPlaylistManager playlist];
    for (int i = (int)[playlist count] - 1; i >= 0; i--) {
        if ([indexes_set containsIndex:i]) {
            NSString *location = [(NSDictionary *)[playlist objectAtIndex:i] objectForKey:@"location"];
            [SKPlaylistManager removeSongAtIndex:i];
            WKAudioStreamer *as = [streamer_dict objectForKey:location];
            if (as != nil) {
                [as pauseStreaming];
            }
        } else if (i < cur_idx) {
            new_idx++;
        }
    }
    
    if (![indexes_set containsIndex:cur_idx]) {
        [streamer play];
        cur_idx = new_idx;
        streamer_dict = [self buildStreamerDict:cur_idx songList:[SKPlaylistManager playlist]];
        [SKSongTableController tableReloadData];
    } else {
        if (cur_playing) {
            [self startPlayingSongAtIndex:new_idx];
        } else {
            [self startPlayingSongAtIndex:-1];
        }
    }
}

@end
