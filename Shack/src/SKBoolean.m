//
//  SKBoolean.m
//  Shack
//
//  Created by Chenguang Wang on 10/26/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKBoolean.h"

static SKBoolean *trueObj;
static SKBoolean *falseObj;

@interface SKBoolean ()
- (id)initWithValue:(BOOL)value;
@end

@implementation SKBoolean

+ (void)initialize {
    trueObj = [[SKBoolean alloc] initWithValue:YES];
    falseObj = [[SKBoolean alloc] initWithValue:NO];
}

- (id)initWithValue:(BOOL)value {
    self = [super init];
    if (self) {
        v = value;
    }
    return self;
}

+ (SKBoolean *)objWithValue:(BOOL)value {
    if (value) {
        return trueObj;
    }
    return falseObj;
}

+ (SKBoolean *)t {
    return trueObj;
}

+ (SKBoolean *)f {
    return falseObj;
}

- (BOOL)isTrue {
    return v;
}

@end
