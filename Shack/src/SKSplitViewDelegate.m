//
//  SKSplitViewDelegate.m
//  Shack
//
//  Created by Chenguang Wang on 10/25/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKSplitViewDelegate.h"

@implementation SKSplitViewDelegate

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin
                                                         ofSubviewAt:(NSInteger)dividerIndex {
    // return 150.0;
    return 0;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax
         ofSubviewAt:(NSInteger)dividerIndex {
    return 250.0;
}

- (void)splitView:(NSSplitView *)splitView resizeSubviewsWithOldSize:(NSSize)oldSize {
    if ([splitView inLiveResize]) {
        NSRect tmpRect = [splitView bounds];
        NSArray *subviews = [splitView subviews];
        NSView *collectionsSide = [subviews objectAtIndex:0];
        NSView *tableSide = [subviews objectAtIndex:1];
        float collectionWidth = [collectionsSide bounds].size.width;
        
        // FIXME: divider thickness *hard coded* as 1 here.
        tmpRect.size.width = tmpRect.size.width - collectionWidth - 1;
        tmpRect.origin.x = tmpRect.origin.x + collectionWidth + 1;
        [tableSide setFrame:tmpRect];
        
        //collection frame stays the same
        tmpRect.size.width = collectionWidth;
        tmpRect.origin.x = 0;
        [collectionsSide setFrame:tmpRect];
    } else {
        [splitView adjustSubviews];
    }
}
@end
