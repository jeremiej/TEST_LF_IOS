//
//  LFORestaurantViewController.m
//  TestTechnique
//
//  Created by Jeremie Janoir on 13/06/15.
//  Copyright (c) 2015 Jeremie Janoir. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "LFORestaurantViewController.h"
#import "LFOHTTPClient.h"
#import "LFORestaurant.h"
#import "LFOPicture.h"
#import "LFOCoreDataManager.h"
#import "LFOTopCollectionViewCell.h"
#import "LFOCollectionViewController.h"

@interface LFORestaurantViewController ()

@property (strong, nonatomic) LFORestaurant *restaurant;
@property (strong, nonatomic) NSMutableDictionary *mainPicture;
@property (strong, nonatomic) NSArray *diaporamaPictures;

@end

@implementation LFORestaurantViewController

typedef void (^AFSuccessBlock) (NSURLSessionDataTask *task, id responseObject);
typedef void (^AFFailureBlock) (NSURLSessionDataTask *task, NSError *error);

NSInteger const kRestaurantId = 6861;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _activityView.layer.cornerRadius = 8.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateRestaurantView:)
                                                 name:@"downloadDidFinish"
                                               object:nil];
    
    [self getRestaurantWithId:[NSNumber numberWithInteger:kRestaurantId]];
}

// Récupère les informations du restaurant puis les stock dans Core data, ou récupère directement dans Core data si pas de connection

- (void)getRestaurantWithId:(NSNumber*)restaurantId
{
    AFSuccessBlock successBlock;
    successBlock = ^(NSURLSessionDataTask *task, id responseObject)
    {
        NSDictionary *response = [[[NSDictionary alloc] initWithDictionary:responseObject] objectForKey:@"data"];

        // Set Restaurant infos
        _restaurant = [NSEntityDescription insertNewObjectForEntityForName:@"LFORestaurant"
                                                    inManagedObjectContext:[[LFOCoreDataManager sharedInstance] managedObjectContext]];
        _restaurant.address = [response objectForKey:@"address"];
        _restaurant.city = [response objectForKey:@"city"];
        _restaurant.currency = [response objectForKey:@"currency_code"];
        _restaurant.latitude = [response objectForKey:@"gps_lat"];
        _restaurant.longitude = [response objectForKey:@"gps_long"];
        _restaurant.minPrice = [NSNumber numberWithInteger:[[response objectForKey:@"min_price"] integerValue]];
        _restaurant.name = [response objectForKey:@"name"];
        _restaurant.rate = [NSNumber numberWithDouble:[[response objectForKey:@"avg_rate"] doubleValue]];
        _restaurant.rateCount = [NSNumber numberWithInteger:[[response objectForKey:@"rate_count"] integerValue]];
        _restaurant.restaurantId = [NSNumber numberWithInteger:[[response objectForKey:@"id_restaurant"] integerValue]];
        _restaurant.speciality = [response objectForKey:@"speciality"];
        _restaurant.zipCode = [response objectForKey:@"zipcode"];
        
        // Set Restaurant main picture
        NSDictionary *mainPicturesData = [response objectForKey:@"pics_main"];
        _mainPicture = [[NSMutableDictionary alloc] init];
        
        for (NSString *key in mainPicturesData.allKeys) {
            LFOPicture *picture = [NSEntityDescription insertNewObjectForEntityForName:@"LFOPicture"
                                                                inManagedObjectContext:[[LFOCoreDataManager sharedInstance] managedObjectContext]];
            picture.type = @"main";
            picture.width = [NSNumber numberWithInt:[[key componentsSeparatedByString:@"x"][0]intValue]];
            picture.height = [NSNumber numberWithInt:[[key componentsSeparatedByString:@"x"][1]intValue]];
            picture.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:[mainPicturesData objectForKey:key]]];
            picture.restaurant = _restaurant;
            [_mainPicture setObject:picture forKey:key];
        }
        
        // Set Restaurant diaporama pictures
        NSArray *diaporamaPicturesData = [response objectForKey:@"pics_diaporama"];
        _restaurant.picsNb = [NSNumber numberWithInteger:[diaporamaPicturesData count]];
        
        for (NSDictionary *pictureData in diaporamaPicturesData) {
            for (NSString *key in pictureData.allKeys) {
                if (![key isEqualToString:@"label"]) {
                    LFOPicture *picture = [NSEntityDescription insertNewObjectForEntityForName:@"LFOPicture"
                                                                        inManagedObjectContext:[[LFOCoreDataManager sharedInstance] managedObjectContext]];
                    picture.type = @"diapo";
                    picture.label = [pictureData objectForKey:@"label"];
                    picture.width = [NSNumber numberWithInt:[[key componentsSeparatedByString:@"x"][0]intValue]];
                    picture.height = [NSNumber numberWithInt:[[key componentsSeparatedByString:@"x"][1]intValue]];
                    picture.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:[pictureData objectForKey:key]]];
                    picture.restaurant = _restaurant;
                    
                }
            }
        }
        
        NSError *error;
        
        if (![[[LFOCoreDataManager sharedInstance] managedObjectContext] save:&error]) {
            NSLog(@"Error, couldn't save: %@", [error localizedDescription]);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadDidFinish"
                                                            object:self];
    };
    
    AFFailureBlock failureBlock;
    failureBlock = ^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"Unable to reach server, trying to get local data");
        NSEntityDescription *restaurantDesc = [NSEntityDescription entityForName:@"LFORestaurant"
                                                          inManagedObjectContext:[[LFOCoreDataManager sharedInstance] managedObjectContext]];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = restaurantDesc;
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(restaurantId = %lu)", kRestaurantId];
        request.predicate = pred;
        
        NSError *requestError;
        NSArray *requestResult = [[[LFOCoreDataManager sharedInstance] managedObjectContext] executeFetchRequest:request error:&requestError];
        _restaurant = requestResult[0];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadDidFinish"
                                                            object:self];
    };
    
    [[LFOHTTPClient sharedHTTPClient] getRestaurantWithId:restaurantId
                                             successBlock:successBlock
                                             andFailBlock:failureBlock];
}

#pragma mark NSnotification

- (void)updateRestaurantView:(NSNotification *)notification
{
    [self performSegueWithIdentifier:@"showRestaurant" sender:self];
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showRestaurant"]) {
        LFOCollectionViewController *vc = [segue destinationViewController];
        vc.restaurant = _restaurant;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
