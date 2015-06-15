//
//  LFOCollectionViewController.h
//  TestTechnique
//
//  Created by Jeremie Janoir on 14/06/15.
//  Copyright (c) 2015 Jeremie Janoir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LFORestaurant.h"
#import "LFOPicture.h"

@interface LFOCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate>

@property (strong, nonatomic) LFORestaurant *restaurant;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
