//
//  SKPlaylistController.h
//  Shack
//
//  Created by Chenguang Wang on 10/26/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

// FIXME: rename the interface as SKSidePanelController.

@interface SKPlaylistController : NSObject <NSOutlineViewDataSource, NSOutlineViewDelegate> {
@private
    NSMutableDictionary *itemsDict;
    NSArray *rootItems;
    NSMutableDictionary *itemsExpandable;
}

@property IBOutlet NSOutlineView *outlineView;

+ (SKPlaylistController *)sharedInstance;
- (void)expandNodes;

@end
