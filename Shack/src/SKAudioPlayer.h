//
//  SKAudioPlayer.h
//  Shack
//
//  Created by Chenguang Wang on 10/29/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SKAudioPlayer : NSObject <AVAudioPlayerDelegate>

// play the "next" song in playlist.
// initially, or when SKAudioPlayer is reset, the current song index is -1.
+ (void)play;
// + (void)playSongAtIndex:(int)index;
+ (void)pause;

// singleton is for the delegate only.
+ (id)sharedInstance;

@end
