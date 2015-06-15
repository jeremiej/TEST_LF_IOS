//
//  LFOCollectionViewController.m
//  TestTechnique
//
//  Created by Jeremie Janoir on 14/06/15.
//  Copyright (c) 2015 Jeremie Janoir. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "LFOCollectionViewController.h"
#import "LFOTopCollectionViewCell.h"
#import "LFOActionCollectionViewCell.h"
#import "LFOInfoCollectionViewCell.h"
#import "LFOMapCollectionViewCell.h"

@interface LFOCollectionViewController ()

@property (strong, nonatomic) MKMapView *cellMapView;

@end

@implementation LFOCollectionViewController

@synthesize collectionView = _collectionView;
@synthesize restaurant = _restaurant;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentRow = indexPath.row;
    
    switch (currentRow) {
        case 0:{ // Cellule Nom + photo
            LFOTopCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"topCell" forIndexPath:indexPath];
            cell.name.text = _restaurant.name;
            cell.address.text = [NSString stringWithFormat:@"%@ %@ %@", _restaurant.address, _restaurant.zipCode, _restaurant.city];
            
            NSArray *mainPictures = [_restaurant.pictures allObjects];
            LFOPicture *nearest = nil;
            int sizeGap = 1000;
            
            for (int i = 0; i < [mainPictures count]; i ++) {
                LFOPicture *picture = mainPictures[i];
                if ([picture.type isEqualToString:@"main"]) {
                    int gap = _collectionView.frame.size.width - [picture.width intValue];
                    if(gap < sizeGap){
                        sizeGap = gap;
                        nearest = picture;
                    }
                }
            }
            
            cell.picture.image = [UIImage imageWithData:nearest.image];
            return cell;
        }
        case 1:{ // Cellule 3 Boutons
            LFOActionCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"actionCell" forIndexPath:indexPath];
            
            NSDictionary *viewPicture = @{@"photoBtn":cell.pictures};
            NSDictionary *viewRate = @{@"rateBtn":cell.rate};
            
            int btnWidth = (int)roundf(_collectionView.frame.size.width / 3);
            
            NSArray *constraintPicture = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[photoBtn(%d)]",btnWidth]
                                                                            options:0
                                                                            metrics:nil
                                                                              views:viewPicture];
            NSArray *constraintRate = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[rateBtn(%d)]",btnWidth]
                                                                            options:0
                                                                            metrics:nil
                                                                              views:viewRate];
            
            [cell.pictures addConstraints:constraintPicture];
            [cell.rate addConstraints:constraintRate];
            
            [cell.pictures setTitle:[NSString stringWithFormat:@"%@ photos", _restaurant.picsNb] forState:UIControlStateNormal];
            
            NSMutableAttributedString *infoPhraseFormated = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/10", _restaurant.rate]];
            
            [infoPhraseFormated addAttribute:NSFontAttributeName
                                       value:[UIFont fontWithName:@"helvetica" size:13.0]
                                       range:NSMakeRange([[NSString stringWithFormat:@"%@", _restaurant.rate] length], 3)];
            
            [cell.rateLabel setAttributedText:infoPhraseFormated];
            cell.rateCountLabel.text = [NSString stringWithFormat:@"selon %@ avis", _restaurant.rateCount];
            
            return cell;
        }
        case 2:{ // Cellule spécialité + prix minimum
            LFOInfoCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"infoCell" forIndexPath:indexPath];
            NSString *infoPhrase = [NSString stringWithFormat:@"Restaurant %@ à partir de %@€", _restaurant.speciality, _restaurant.minPrice];
            NSMutableAttributedString *infoPhraseFormated = [[NSMutableAttributedString alloc] initWithString:infoPhrase];
            
            [infoPhraseFormated addAttribute:NSForegroundColorAttributeName
                                          value:[UIColor blackColor]
                                          range:NSMakeRange(11, [_restaurant.speciality length])];
            
            [infoPhraseFormated addAttribute:NSForegroundColorAttributeName
                                          value:[UIColor blackColor]
                                          range:NSMakeRange([infoPhrase length] - [[NSString stringWithFormat:@"%@", _restaurant.minPrice] length] - 1, [[NSString stringWithFormat:@"%@", _restaurant.minPrice] length])];
            
            [cell.info setAttributedText:infoPhraseFormated];
            
            cell.layer.masksToBounds = NO;
            cell.layer.shadowOffset = CGSizeMake(0, 1);
            cell.layer.shadowRadius = 1.0;
            cell.layer.shadowColor = [UIColor blackColor].CGColor;
            cell.layer.shadowOpacity = 0.5;
            [cell.layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];
            
            return cell;
        }
        case 3:{ // Cellule map
            LFOMapCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"mapCell" forIndexPath:indexPath];
            
            CLLocationCoordinate2D zoomLocation;
            zoomLocation.latitude = [_restaurant.latitude floatValue];
            zoomLocation.longitude= [_restaurant.longitude floatValue];
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 800, 800);
            
            [cell.mapView setRegion:viewRegion animated:YES];
            
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            point.coordinate = zoomLocation;
            point.title = @"restaurant";
            
            [cell.mapView addAnnotation:point];
            _cellMapView = cell.mapView;
            
            cell.layer.masksToBounds = NO;
            cell.layer.shadowOffset = CGSizeMake(0, 1);
            cell.layer.shadowRadius = 1.0;
            cell.layer.shadowColor = [UIColor blackColor].CGColor;
            cell.layer.shadowOpacity = 0.5;
            [cell.layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];
            
            return cell;
        }
    }

    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            return CGSizeMake(_collectionView.frame.size.width, 200);
        }
        case 1:{
            return CGSizeMake(_collectionView.frame.size.width, 50);
        }
        case 2:{
            return CGSizeMake(_collectionView.frame.size.width, 50);
        }
        case 3:{
            return CGSizeMake(_collectionView.frame.size.width, _collectionView.frame.size.height - 300);
        }
    }
    return CGSizeMake(0, 0);
}

#pragma mark <MkMApViewDelegate>

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"restaurant"];
    annView.image = [UIImage imageNamed:@"pin-green.png"];
    return annView;
}

- (IBAction)centerOnRestaurant:(UIButton *)sender
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [_restaurant.latitude floatValue];
    zoomLocation.longitude= [_restaurant.longitude floatValue];
    _cellMapView.region = MKCoordinateRegionMakeWithDistance(zoomLocation, 800, 800);
}
@end
