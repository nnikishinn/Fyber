//
//  FYBOfferObject.h
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYBOfferObjectProtocol.h"

@interface FYBOfferObject : NSObject <FYBOfferObjectProtocol>

+ (instancetype)offerObjectFromJSON:(NSDictionary *)jsonDict;

@end
