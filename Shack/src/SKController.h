//
//  SKController.h
//  Shack
//
//  Created by Chenguang Wang on 10/22/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKController : NSObject

@property IBOutlet NSTableHeaderView *songTableHeader;
@property IBOutlet NSTableView *songTable;
@property IBOutlet NSProgressIndicator *busyIndicator;

@property IBOutlet NSButton *playPauseButton;

+ (id)sharedInstance;

- (IBAction)togglePlayPause:(id)sender;

- (void)doubleClickSongItem:(id)sender;

// toggle animation of the progress bar...
// I'm terribly bad on naming variables.
+ (void)busy;
+ (void)busyDone;

@end
