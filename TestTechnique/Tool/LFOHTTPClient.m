//
//  LFOHTTPClient.m
//  TestTechnique
//
//  Created by Jeremie Janoir on 13/06/15.
//  Copyright (c) 2015 Jeremie Janoir. All rights reserved.
//

#import "LFOHTTPClient.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const baseURL = @"http://api.lafourchette.com";

@implementation LFOHTTPClient

+ (LFOHTTPClient *)sharedHTTPClient
{
    static LFOHTTPClient *sharedHTTPClient = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    });
    
    return sharedHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    return self;
}

- (void)getRestaurantWithId:(NSNumber*)restaurantId
               successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
               andFailBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failBlock
{
    
    NSString* path = [NSString stringWithFormat:@"api?key=IPHONEPRODEDCRFV&method=restaurant_get_info&id_restaurant=%@", restaurantId];
    
    [self GET:path parameters:nil success:successBlock failure:failBlock];
}

@end
