//
//  SKSongTableController.m
//  Shack
//
//  Created by Chenguang Wang on 10/29/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKSongTableController.h"
#import "SKPlaylistManager.h"
#import "SKAudioPlayer.h"

@interface SKSongTableController ()
// @property NSMutableArray *tracksInfoDictArray;
@property IBOutlet NSTableView *tableView;
@end

static NSImage *g_playImage = nil;
static NSImage *g_pauseImage = nil;
// static NSImageCell *g_playCell = nil;
// static NSImageCell *g_pauseCell = nil;

@implementation SKSongTableController

+ (void)initialize {
    g_playImage = [NSImage imageNamed:@"play"];
    g_pauseImage = [NSImage imageNamed:@"pause"];
    
    // g_playCell = [NSImageCell new];
    // g_pauseCell = [NSImageCell new];
    // [g_playCell setObjectValue:[NSImage imageNamed:@"play"]];
    // [g_pauseCell setObjectValue:[NSImage imageNamed:@"pause"]];
}

+ (id)sharedInstance {
    static id singleton = nil;
    if (singleton == nil) {
        singleton = [[self alloc] init];
    }
    return singleton;
}

+ (void)tableReloadData {
    [[[self sharedInstance] tableView] reloadData];
}

// init is also singleton-ized.
// FIXME: use dispatch_once to create the singleton, maybe?
- (id)init {
    static id singleton = nil;
    if (singleton != nil) {
        return singleton;
    }
    self = [super init];
    singleton = self;
    return self;
}

////////////////////////////////////////////////
///////////////// the delegate /////////////////
////////////////////////////////////////////////

- (BOOL)tableView:(NSTableView *)aTableView
        shouldEditTableColumn:(NSTableColumn *)aTableColumn
                          row:(NSInteger)rowIndex {
    return NO;
}

////////////////////////////////////////////////
//////////////// the data source ///////////////
////////////////////////////////////////////////

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    // NSArray *a = [self tracksInfoDictArray];
    NSArray *a = [SKPlaylistManager playlist];
    if (a != nil) {
        return [a count];
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView
      objectValueForTableColumn:(NSTableColumn *)tableColumn
                            row:(NSInteger)rowIndex {
    NSString *columnIdentifier = [tableColumn identifier];
    NSDictionary *d = [[SKPlaylistManager playlist] objectAtIndex:rowIndex];
    if ([columnIdentifier isEqualToString:@"player_status"]) {
        // return @"p";
        // return g_playCell;
        /*
        if (rowIndex % 3 == 0) {
            return nil;
        } else if (rowIndex % 3 == 1) {
            return g_playImage;
        } else {
            return g_pauseImage;
        }
         */
        if (rowIndex != [SKAudioPlayer curIdx]) {
            return nil;
        } else {
            if ([SKAudioPlayer curPlaying]) {
                return g_playImage;
            } else {
                return g_pauseImage;
            }
        }
    } else {
        return [d objectForKey:columnIdentifier];
    }
}

@end
