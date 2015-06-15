//
//  LFOHTTPClient.h
//  TestTechnique
//
//  Created by Jeremie Janoir on 13/06/15.
//  Copyright (c) 2015 Jeremie Janoir. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface LFOHTTPClient : AFHTTPSessionManager

+ (LFOHTTPClient *)sharedHTTPClient;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (void)getRestaurantWithId:(NSNumber*)restaurantId
               successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
               andFailBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failBlock;

@end
