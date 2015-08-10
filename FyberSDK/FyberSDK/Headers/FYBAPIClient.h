//
//  FYBApiClient.h
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYBAPIClient : NSObject

+ (void)getOffersWithParametersAppid:(NSString *)requestAppid
                     requestUid:(NSString *)requestUid
                  requestAPIKey:(NSString *)requestAPIKey
                   successBlock:(void (^)(NSArray * offersArray))sucessBlock
                     errorBlock:(void (^)(NSError *error))errorBlock;



@end
