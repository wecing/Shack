//
//  SKPlaylistController.h
//  Shack
//
//  Created by Chenguang Wang on 10/26/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

// Well, I used to call this class "SKPlaylistDataSourceAndDelegate",
// but obviously the name is too long...

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
