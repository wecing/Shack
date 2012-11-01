//
//  SKSongTableController.m
//  Shack
//
//  Created by Chenguang Wang on 10/29/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKSongTableController.h"
#import "SKPlaylistManager.h"

@interface SKSongTableController ()
// @property NSMutableArray *tracksInfoDictArray;
@property IBOutlet NSTableView *tableView;
@end

@implementation SKSongTableController

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
    return [d objectForKey:columnIdentifier];
}

@end
