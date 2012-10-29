//
//  SKController.m
//  Shack
//
//  Created by Chenguang Wang on 10/22/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKController.h"
#import "SKPlaylistController.h"

@interface SKController ()
@property (readwrite) IBOutlet NSTableHeaderView *songTableHeader;
@property (readwrite) IBOutlet NSTableView *songTable;
@end

@implementation SKController

- (IBAction)problem:(id)sender {
    NSLog(@"Problem?");
}

@end
