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

+ (void)play;
+ (void)pause;

+ (void)startPlayingSongAtIndex:(NSInteger)idx;

// singleton is for the delegate only.
+ (id)sharedInstance;

@end
