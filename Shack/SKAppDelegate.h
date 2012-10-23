//
//  SKAppDelegate.h
//  Shack
//
//  Created by Chenguang Wang on 10/22/12.
//  Copyright (c) 2012 Chenguang Wang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SKAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
