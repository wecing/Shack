//
//  SKXiamiLinkHandler.m
//  Shack
//
//  Created by Chenguang Wang on 10/31/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKXiamiLinkHandler.h"
#import "SKPlaylistManager.h"
#import "SKController.h"

// to avoid NSURLConnection objects are released once feedLink finished execution...
static NSMutableArray *connArray = nil;

@implementation SKXiamiLinkHandler

+ (void)initialize {
    connArray = [NSMutableArray new];
}

+ (BOOL)feedLink:(NSString *)link {
    [SKController busy];
    
    // link example:
    //     http://www.xiami.com/song/playlist/id/372166/object_name/default/object_id/0
    NSURL *url = [NSURL URLWithString:link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:[self new]];
    if (conn != nil) {
        @synchronized(connArray) {
            [connArray addObject:conn];
        }
        return YES;
    } else {
        return NO;
        [SKController busyDone];
    }
}

- (id)init {
    self = [super init];
    if (self != nil) {
        fullData = [NSMutableData new];
    }
    return self;
}

////////////////////////////////////////////////
////////////// delegate methods ////////////////
////////////////////////////////////////////////

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // well... I don't think @synchronized is necessary because
    // the manual didn't say that...
    //
    // @synchronized(self) {
    // }
    [fullData appendData:data];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse {
    return request; // just redirect.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    @synchronized(connArray) {
        [connArray removeObject:connection];
    }
    
    NSArray *list = [SKXiamiLinkHandler decodeXML:fullData];
    [SKPlaylistManager appendSongs:list];
    [SKController playIfNotPaused];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed!");
    NSLog(@"connection=%@", connection);
    NSLog(@"Error: %@", error);
    @synchronized(connArray) {
        [connArray removeObject:connection];
    }
}

////////////////////////////////////////////////
/////////////////// THE CORE ///////////////////
////////////////////////////////////////////////

+ (NSArray *)decodeXML:(NSData *)xmlData {
    // NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:infoURL options:0 error:&error];
    NSError *error;
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (xmlDoc == nil) {
        NSLog(@"Error while constructing NSXMLDocument: %@", error);
        return nil; // FIXME: show the user error info (with Gruml)?
    }
    
    // The XML we receive is like:
    //    <playlist xmlns="http://xspf.org/ns/0/" version="1">
    //      <trackList>
    //        <track>
    //          <title>        <![CDATA[ ODDS&ENDS ]]>                                                   </title>
    //          <song_id>      1771257374                                                                </song_id>
    //          <album_id>     537161                                                                    </album_id>
    //          <album_name>   <![CDATA[ ODDS&ENDS/Sky of Beginning ]]>                                  </album_name>
    //          <object_id>    1                                                                         </object_id>
    //          <object_name>  default                                                                   </object_name>
    //          <insert_type>  3                                                                         </insert_type>
    //          <background>   #eeeeee                                                                   </background>
    //          <grade>        -1                                                                        </grade>
    //          <artist>       <![CDATA[ ryo;初音ミク ]]>                                                  </artist>
    //          <location>
    //            5h3%.i%2%8F6%15_5.tA2x.2F24515773Emt%FinF1F53%E7368pp2fae446%72117493%F3mt%5321F_24%7
    //          </location>
    //          <ms>           http://f3.xiami.net                                                       </ms>
    //          <lyric>        http://img.xiami.com/./lyric/upload/74/1771257374_1345874695.lrc          </lyric>
    //          <pic>          http://img.xiami.com/images/album/img45/63845/5371611345616868_1.jpg      </pic>
    //        </track>
    //
    //        <track>
    //          ...
    //        </track>
    //
    //      </trackList>
    //
    //      <uid>1688398</uid>
    //      <type>default</type>
    //      <type_id>1</type_id>
    //      <clearlist/>
    //
    //    </playlist>
    
    // get <trackList>.
    NSXMLElement *rootElement = [xmlDoc rootElement];
    NSArray *trackListArray = [rootElement elementsForName:@"trackList"];
    if ([trackListArray count] != 1) {
        NSLog(@"Number of trackLists in rootElement not 1: %@", rootElement);
        return nil;
    }
    
    // get <track>.
    NSXMLElement *trackList = [trackListArray objectAtIndex:0];
    NSArray *tracks = [trackList elementsForName:@"track"];
    
    // build a list of tracks.
    // the resulting array is an array of dictionaries;
    // each dictionary will map node names of one <track> node to the corresponding values.
    //
    // e.g.:
    //    {
    //        "album_id" = 537161;
    //        "album_name" = "ODDS&ENDS/Sky of Beginning ";
    //        artist = "\U3058\U3093 ;\U521d\U97f3\U30df\U30af";
    //        background = "#eeeeee";
    //        grade = "-1";
    //        "insert_type" = 1;
    //        location = "5h3%.i%2%8F6%15_5.tA2x.2F24515773Emt%FinF1F53%E7368pp2fae446%72117493%F3mt%5321F_24%7";
    //        lyric = "http://www.xiami.com/song/lyrictxt/id/1771257375";
    //        ms = "http://f3.xiami.net";
    //        "object_id" = 537161;
    //        "object_name" = album;
    //        pic = "http://img.xiami.com/images/album/img45/63845/5371611345616868_1.jpg";
    //        "song_id" = 1771257375;
    //        title = "Sky of Beginning";
    //    }
    NSMutableArray *tracksInfoDictArray = [[NSMutableArray alloc] initWithCapacity:[tracks count]];
    for (int i = 0; i < [tracks count]; i++) {
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        NSXMLElement *track = [tracks objectAtIndex:i];
        for (NSUInteger j = 0; j < [track childCount]; j++) {
            NSXMLNode *node = [track childAtIndex:j];
            if ([node childCount] > 0) { // <ms>...</ms> is now replaced with <ms/>.
                NSString *nodeValue = [[node childAtIndex:0] stringValue];
                [d setObject:nodeValue forKey:[node name]];
            }
        }
        [tracksInfoDictArray addObject:d];
    }
    
    
    // Decrypting location:
    //     sample location: 5h3%.i%2%8F6%15_5.tA2x.2F24515773Emt%FinF1F53%E7368pp2fae446%72117493%F3mt%5321F_24%7
    //
    // The first character is always an integer; let's call it w.
    //
    // We want to transform the string into something like:
    //         h  _j
    //    h3%.i%2%8F6%15_5.
    //  w tA2x.2F24515773Em
    //    t%FinF1F53%E7368p
    // _i p2fae446%72117493
    //    %F3mt%5321F_24%7
    //
    // Or, in a more readable form:
    //     http% 3A%2F %2Ff3 .xiam i.net %2F4% 2F143 %2F63 845%2 F5371 61%2F %5E1_ 17712 57375 _364% 5E897 .mp3
    // Concating these sections, and unescape the link, we will get:
    //     http://f3.xiami.net/4/145/63845/537161/^1_1771257375_364^897.mp3
    // Finally, change '^' to '0':
    //     http://f3.xiami.net/4/145/63845/537161/01_1771257374_3640897.mp3
    //
    //
    // example 2:  8h2xt187526.tFi%441E54mt%a255637%pp2mF%%1_353%Fi422%17E3f.%FF2768A3n265F7_9%.eF33%139
    //       h  _j
    //    h2xt187526.
    //    tFi%441E54m
    //  w t%a255637%p
    //    p2mF%%1_353
    //    %Fi422%17E
    // _i 3f.%FF2768
    //    A3n265F7_9
    //    %.eF33%139
    
    for (int i = 0; i < [tracksInfoDictArray count]; i++) {
        NSMutableDictionary *trackInfoDict = [tracksInfoDictArray objectAtIndex:i];
        NSString *location = [trackInfoDict objectForKey:@"location"];
        
        int w = (int)[[location substringToIndex:1] integerValue];
        location = [location substringFromIndex:1];
        int len = (int)[location length];
        
        // Hope that's not very confusing...
        NSMutableString *str = [[NSMutableString alloc] initWithString:location];
        int _i = 0;
        int _j = 0;
        for (int j = 0; j < [location length]; j++) {
            if (len % w != 0) {
                if ((_i >= (len % w) && _j == (int)ceil(len / w)) ||
                    (_i <  (len % w) && _j == (int)ceil(len / w) + 1)) {
                    _i++;
                    _j = 0;
                }
            } else {
                if (_j == len / w) {
                    _i++;
                    _j = 0;
                }
            }
            if (_j * w + _i > len) {
                break;
            }
            
            // basically this line means:
            //     str[_j * w + _i] = location[j];
            [str replaceCharactersInRange:NSMakeRange(_j * w + _i, 1)
                               withString:[location substringWithRange:NSMakeRange(j, 1)]];
            _j++;
        }
        NSString *newLocation = [[NSString alloc] initWithString:str];
        newLocation = [newLocation stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        newLocation = [newLocation stringByReplacingOccurrencesOfString:@"^" withString:@"0"];
        
        // update the link.
        [trackInfoDict setObject:newLocation forKey:@"location"];
    }
    
    // for now... just print it out.
    // NSLog(@"%@", tracksInfoDictArray);
    
    [SKController busyDone];
    return tracksInfoDictArray;
}

@end