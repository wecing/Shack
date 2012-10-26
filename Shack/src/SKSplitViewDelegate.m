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
    return 150.0;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax
         ofSubviewAt:(NSInteger)dividerIndex {
    return 250.0;
}
@end
