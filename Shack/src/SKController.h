//
//  SKController.h
//  Shack
//
//  Created by Chenguang Wang on 10/22/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKController : NSObject

@property (readonly) IBOutlet NSTableHeaderView *songTableHeader;
@property (readonly) IBOutlet NSTableView *songTable;

- (IBAction)problem:(id)sender;

@end
