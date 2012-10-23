//
//  SKSocketController.h
//  Shack
//
//  Created by Chenguang Wang on 10/22/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKSocketController : NSObject

+ (BOOL)listenToSocket;
+ (BOOL)listenToSocket:(uint16_t)portNumber;

@end
