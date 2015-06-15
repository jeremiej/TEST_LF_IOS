//
//  LFOCoreDataManager.h
//  TestTechnique
//
//  Created by Jeremie Janoir on 14/06/15.
//  Copyright (c) 2015 Jeremie Janoir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LFOCoreDataManager : NSObject

+ (id)sharedInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
