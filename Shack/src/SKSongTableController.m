//
//  SKSongTableController.m
//  Shack
//
//  Created by Chenguang Wang on 10/29/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKSongTableController.h"

@interface SKSongTableController ()
@property NSMutableArray *tracksInfoDictArray;
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

// init is also singleton-ized.
- (id)init {
    static id singleton = nil;
    if (singleton != nil) {
        return singleton;
    }
    self = [super init];
    singleton = self;
    if (self) {
        [self setTracksInfoDictArray:[[NSMutableArray alloc] init]];
    }
    return self;
}

- (void)appendSongs:(NSArray*)songsList {
    NSMutableArray *tracks = [self tracksInfoDictArray];
    for (NSDictionary *d in songsList) {
        [tracks addObject:d];
    }
    [[self tableView] reloadData];
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
    NSArray *a = [self tracksInfoDictArray];
    if (a != nil) {
        return [a count];
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView
      objectValueForTableColumn:(NSTableColumn *)tableColumn
                            row:(NSInteger)rowIndex {
    NSString *columnIdentifier = [tableColumn identifier];
    NSDictionary *d = [[self tracksInfoDictArray] objectAtIndex:rowIndex];
    return [d objectForKey:columnIdentifier];
}

@end
