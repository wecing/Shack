//
//  SKPlaylistController.m
//  Shack
//
//  Created by Chenguang Wang on 10/26/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import "SKPlaylistController.h"
#import "SKBoolean.h"

static SKPlaylistController *shared = nil;

@interface SKPlaylistController ()
- (void)addChild:(id)child parent:(id)parent;
@end

@implementation SKPlaylistController

+ (SKPlaylistController *)sharedInstance {
    // because the IBOutlet outlineView is bounded,
    // init will be called once before sharedInstance.
    // so shared should always be non-nil here.
    return shared;
    /*
    NSLog(@"in sharedInstance!");
    static dispatch_once_t pred;
    static SKPlaylistController *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SKPlaylistController alloc] init];
    });
    return shared;
     */
}

- (void)expandNodes {
    // FIXME: rewrite this to give a better control on which item
    //        will be expanded initially.
    [[self outlineView] expandItem:nil expandChildren:YES];
}

- (id)init {
    if (shared != nil) {
        // ****************** FIXME ******************
        // extract the delegate into a seperate class.
        // or, use tree controller, maybe?
        // ****************** FIXME ******************
        return shared; // Well... this is stupid, I guess.
    }
    
    self = [super init];
    if (self) {
        // NSCell *rootItemDemoOne = [[NSCell alloc] initTextCell:@"Hello"];
        // NSCell *rootItemDemoTwo = [[NSCell alloc] initTextCell:@"Wow"];
        NSString *rootItemDemoOne = @"Hello";
        NSString *rootItemDemoTwo = @"Wow";
        rootItems = [[NSArray alloc] initWithObjects:rootItemDemoOne, rootItemDemoTwo, nil];
        itemsDict = [[NSMutableDictionary alloc] init];
        itemsExpandable = [[NSMutableDictionary alloc] init];
        
        [self addChild:rootItemDemoOne parent:nil expansible:YES];
        [self addChild:rootItemDemoTwo parent:nil expansible:YES];
        
        // [self addChild:[[NSCell alloc] initTextCell:@"Hello 1"] parent:rootItemDemoOne];
        // [self addChild:[[NSCell alloc] initTextCell:@"Hello 2"] parent:rootItemDemoOne];
        [self addChild:@"Hello 1" parent:rootItemDemoOne];
        [self addChild:@"Hello 2" parent:rootItemDemoOne];
        
        // [self addChild:[[NSCell alloc] initTextCell:@"Wow Again!"] parent:rootItemDemoTwo];
        [self addChild:@"Wow Again!" parent:rootItemDemoTwo];
    }
    shared = self;
    return self;
}

// (1) add <child> to the array <parent> maps to;
// (2) then map <child> to a new empty array. it all happens in <itemsDict>;
// (3) finally set <child> as inexpandable (NO) in <itemsExpandable>.
//
// <parent> is supposed to be an existing key in <itemsDict> or nil.
//     if <parent> is nil, this method will not try to do (1).
// <child> should be a completely new item.
- (void)addChild:(id)child parent:(id)parent {
    [self addChild:child parent:parent expansible:NO];
}

- (void)addChild:(id)child parent:(id)parent expansible:(BOOL)expa {
    if (parent != nil) {
        NSMutableArray *array = [itemsDict objectForKey:parent];
        [array addObject:child];
    }
    [itemsDict setObject:[NSMutableArray array] forKey:child];
    [itemsExpandable setObject:[SKBoolean objWithValue:expa] forKey:child];
}

- (id)outlineView:(NSOutlineView *)outlineView
            child:(NSInteger)index
           ofItem:(id)item {
    if (item != nil) {
        return [[itemsDict objectForKey:item] objectAtIndex:index];
    }
    return [rootItems objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   isItemExpandable:(id)item {
    return [[itemsExpandable objectForKey:item] isTrue];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView
  numberOfChildrenOfItem:(id)item {
    if (item != nil) {
        return [[itemsDict objectForKey:item] count];
    }
    return [rootItems count];
}

// So if we don't use NSView for the cells then
// we have no need to implement this at all?
//
- (id)outlineView:(NSOutlineView *)outlineView
      objectValueForTableColumn:(NSTableColumn *)tableColumn
                         byItem:(id)item {
    // Well... we have only one column here right?
    return item;
    // return [item stringValue];
    // NSTableCellView *result = [outlineView makeVi]
}

// - (void)outlineView:(NSOutlineView *)outlineView
//      setObjectValue:(id)object
//      forTableColumn:(NSTableColumn *)tableColumn
//              byItem:(id)item {
// }

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    for (int i = 0; i < [rootItems count]; i++) {
        if (item == [rootItems objectAtIndex:i]) {
            return YES;
        }
    }
    return NO;
}

@end
