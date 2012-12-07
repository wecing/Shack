//
//  SKPlaylistManager.h
//  Shack
//
//  Created by Chenguang Wang on 10/29/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKPlaylistManager : NSObject

// add <songs> to the default playlist.
// the default default playlist is "default".
+ (void)appendSongs:(NSArray *)songs;

// add <songs> to <playlist>.
// if <playlist> doesn't exist, it will be created.
//
// so theoretically we can create new playlists with this command;
// just use an empty array for <songs>.
//
// off topic: maybe I should support creating new playlists by dragging
//            songs to the empty area of side panel...?
// *serious*: remember to update the side panel when new playlists are added...
+ (void)appendSongs:(NSArray *)songs toPlaylist:(NSString *)playlist;

+ (void)removeSongAtIndex:(int)s_idx;
+ (void)removeSongAtIndex:(int)s_idx inPlaylist:(NSString *)playlist;

// return the current playlist. (not the default one)
+ (NSArray *)playlist;

// return the playlist identified by <name>.
+ (NSArray *)playlist:(NSString *)name;

+ (NSString *)currentPlaylistName;

@end
