//
//  LFOPicture.h
//  TestTechnique
//
//  Created by Jeremie Janoir on 15/06/15.
//  Copyright (c) 2015 Jeremie Janoir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LFORestaurant;

@interface LFOPicture : NSManagedObject

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) LFORestaurant *restaurant;

@end
