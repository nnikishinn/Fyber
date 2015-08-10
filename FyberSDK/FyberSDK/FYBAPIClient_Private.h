//
//  FYBApiClient.h
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import "FYBAPIClient.h"

@interface FYBAPIClient (Private)

+ (NSString *)hashKeyForParamaters:(NSDictionary *)parametersDict requestAPIKey:(NSString *)requestAPIKey;

@end
