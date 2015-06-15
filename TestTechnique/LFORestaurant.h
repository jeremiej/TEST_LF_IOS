//
//  LFORestaurant.h
//  TestTechnique
//
//  Created by Jeremie Janoir on 15/06/15.
//  Copyright (c) 2015 Jeremie Janoir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LFOPicture;

@interface LFORestaurant : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * minPrice;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSNumber * rateCount;
@property (nonatomic, retain) NSNumber * restaurantId;
@property (nonatomic, retain) NSString * speciality;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSNumber * picsNb;
@property (nonatomic, retain) NSSet *pictures;
@end

@interface LFORestaurant (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(LFOPicture *)value;
- (void)removePicturesObject:(LFOPicture *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

@end
