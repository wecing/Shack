//
//  SKPlaylistManager.m
//  Shack
//
//  Created by Chenguang Wang on 10/29/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKPlaylistManager.h"
#import "SKSongTableController.h"
#import "SKAudioPlayer.h"

static NSMutableDictionary *playlistsDict = nil;

// FIXME: set *BOTH* to the correct value when program have finished launching.
//        if the user changed the default name.
static NSString *defaultPlaylist = @"default";
static NSString *currentPlaylist = @"default";

@implementation SKPlaylistManager

+ (void)initialize {
    playlistsDict = [NSMutableDictionary new];
}

+ (void)appendSongs:(NSArray *)songs {
    [self appendSongs:songs toPlaylist:defaultPlaylist];
}

+ (void)appendSongs:(NSArray *)songs toPlaylist:(NSString *)playlist {
    NSMutableArray *list = [playlistsDict objectForKey:playlist];
    if (list == nil) {
        list = [NSMutableArray new];
        [playlistsDict setObject:list forKey:playlist];
    }
    
    for (NSDictionary *d in songs) {
        [list addObject:d];
    }

    // reload data iff we are adding songs to the current list.
    if ([currentPlaylist isEqualToString:playlist]) {
        [SKSongTableController tableReloadData];
    }
    
    [SKAudioPlayer reloadStreamerList];
}

+ (void)removeSongAtIndex:(int)s_idx {
    [self removeSongAtIndex:s_idx inPlaylist:defaultPlaylist];
}

+ (void)removeSongAtIndex:(int)s_idx inPlaylist:(NSString *)playlist {
    NSMutableArray *list = [playlistsDict objectForKey:playlist];
    if (list == nil || s_idx < 0 || s_idx >= [list count]) {
        return;
    }
    [list removeObjectAtIndex:s_idx];
}

+ (NSArray *)playlist {
    return [self playlist:currentPlaylist];
}

+ (NSArray *)playlist:(NSString *)name {
    NSArray *playlist = [playlistsDict objectForKey:name];
    if (playlist == nil) {
        // well, we should not create new playlists here, because
        // this method may be called before program finished launching --
        // i.e., called by controller of the track list ("song table"?)
        //       before applicationDidFinishLaunching is called to set
        //       defaultPlaylist and currentPlaylist to the currect value.
        // for the same reason, don't dump the log if playlist == nil.

        // NSLog(@"Playlist %@ not defined", name);
    }
    return playlist;
}

+ (NSString *)currentPlaylistName {
    return currentPlaylist;
}

@end
