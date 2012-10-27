//
//  SKBoolean.h
//  Shack
//
//  Created by Chenguang Wang on 10/26/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKBoolean : NSObject {
@private
    BOOL v;
}

+ (SKBoolean *)objWithValue:(BOOL)value;
+ (SKBoolean *)t;
+ (SKBoolean *)f;

- (BOOL) isTrue;

@end
