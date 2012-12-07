//
//  SKAudioPlayer.h
//  Shack
//
//  Created by Chenguang Wang on 10/29/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
// #import <AVFoundation/AVFoundation.h>

@interface SKAudioPlayer : NSObject

@property IBOutlet NSTextField *progressLabel;
@property IBOutlet NSTableView *songTable;

+ (BOOL)play;
+ (BOOL)pause;

+ (BOOL)startPlayingSongAtIndex:(NSInteger)idx;

// singleton is for the delegate only.
+ (id)sharedInstance;

+ (int)curIdx;
+ (BOOL)curPlaying;

@end
