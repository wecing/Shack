//
//  SKApplication.m
//  Shack
//
//  Created by Chenguang Wang on 12/5/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <IOKit/hidsystem/ev_keymap.h>
#import "SKApplication.h"

#import "SPMediaKeyTap.h"
#import "SKAppDelegate.h"

@interface SKApplication ()
// - (BOOL)mediaKeyEvent:(int)key state:(BOOL)state repeat:(BOOL)repeat;
@end

@implementation SKApplication

- (void)sendEvent:(NSEvent*)event
{
//	if( [event type] == NSSystemDefined && [event subtype] == 8 )
//	{
//		int keyCode = (([event data1] & 0xFFFF0000) >> 16);
//		int keyFlags = ([event data1] & 0x0000FFFF);
//		int keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA;
//		int keyRepeat = (keyFlags & 0x1);
//		
//		if ([self mediaKeyEvent: keyCode state: keyState repeat: keyRepeat]) {
//            return; // key event handled
//        }
//	}
    // If event tap is not installed, handle events that reach the app instead
	BOOL shouldHandleMediaKeyEventLocally = ![SPMediaKeyTap usesGlobalMediaKeyTap];
    
	if(shouldHandleMediaKeyEventLocally && [event type] == NSSystemDefined && [event subtype] == SPSystemDefinedEventMediaKeys) {
		[(id)[self delegate] mediaKeyTap:nil receivedMediaKeyEvent:event];
	}
	[super sendEvent:event];
    
	// [super sendEvent:event];
}

//- (BOOL)mediaKeyEvent: (int)key state: (BOOL)state repeat: (BOOL)repeat
//{
//	switch( key )
//	{
//		case NX_KEYTYPE_PLAY:
//			if( state == 0 )
//				NSLog(@"\n-> *** play clicked ***"); //Play pressed and released
//            return YES;
//            break;
//            
//		case NX_KEYTYPE_FAST:
//			if( state == 0 )
//				NSLog(@"\n-> *** fast clicked ***"); //Next pressed and released
//            return YES;
//            break;
//            
//		case NX_KEYTYPE_REWIND:
//			if( state == 0 )
//				NSLog(@"\n-> *** rewind clicked ***"); //Previous pressed and released
//            return YES;
//            break;
//	}
//    return NO;
//}
@end
