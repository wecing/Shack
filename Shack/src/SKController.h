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

@property IBOutlet NSButton *playPauseButton;

- (IBAction)togglePlayPause:(id)sender;

- (void)doubleClickSongItem:(id)sender;

@end
