//
//  LFOMapCollectionViewCell.h
//  TestTechnique
//
//  Created by Jeremie Janoir on 15/06/15.
//  Copyright (c) 2015 Jeremie Janoir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LFOMapCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
