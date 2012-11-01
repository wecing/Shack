//
//  SKSocketController.m
//  Shack
//
//  Created by Chenguang Wang on 10/22/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKSocketController.h"
#import "GCDAsyncSocket.h"
#import "SKXiamiLinkHandler.h"

#define SK_DEFAULT_PORT 6578

@interface SKSocketController ()
+ (void)socket:(id)sender didAcceptNewSocket:(GCDAsyncSocket *)newSocket;
+ (void)socket:(id)sender didReadData:(NSData *)data withTag:(long)tag;
@end

@implementation SKSocketController

+ (BOOL)listenToSocket {
    return [self listenToSocket:SK_DEFAULT_PORT];
}

+ (BOOL)listenToSocket:(uint16_t)portNumber {
    static dispatch_once_t pred;
    static GCDAsyncSocket *listenSocket = nil;
    dispatch_once(&pred, ^{
        listenSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                                  delegateQueue:dispatch_get_main_queue()];
    });
    
    NSError *error = nil;
    if (![listenSocket acceptOnPort:portNumber error:&error]) {
        NSLog(@"Failed accepting: %@", error);
        return NO;
    }

    return YES;
}

+ (void)socket:(id)sender didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSData *separator = [@"\0" dataUsingEncoding:NSUTF8StringEncoding];
    [newSocket readDataToData:separator withTimeout:-1 tag:0];
}

+ (void)socket:(id)sender didReadData:(NSData *)data withTag:(long)tag {
    const char *str = [data bytes];
    NSString *link = [[NSString alloc] initWithBytes:str length:strlen(str) encoding:NSASCIIStringEncoding];
    NSString *fullLink = [@"http://www.xiami.com" stringByAppendingString:link];
    [SKXiamiLinkHandler feedLink:fullLink];

}

@end
