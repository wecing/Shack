//
//  SKXiamiLinkHandler.h
//  Shack
//
//  Created by Chenguang Wang on 10/31/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKXiamiLinkHandler : NSObject <NSURLConnectionDelegate> {
@private
    NSMutableData *fullData;
    // NSURLConnection *connection;
}

+ (BOOL)feedLink:(NSString *)link;

// cache? I will not use that.
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse;

// response? why would I need that?
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

// redirect? well, I guess I don't need that... anyway I will do the redirection.
- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end
