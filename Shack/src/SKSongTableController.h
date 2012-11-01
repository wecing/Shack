//
//  SKSongTableController.h
//  Shack
//
//  Created by Chenguang Wang on 10/29/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKSongTableController : NSObject <NSTableViewDataSource, NSTableViewDelegate>
+ (id)sharedInstance;
+ (void)tableReloadData;
@end
