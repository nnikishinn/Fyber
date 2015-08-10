//
//  FYBOfferObject.m
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import "FYBOfferObject.h"

@interface FYBOfferObject()

@property (nonatomic, strong) NSDictionary *jsonDict;

@end

@implementation FYBOfferObject

@dynamic title, teaser, thumbnail_hires_url, payout;

#pragma mark Designated Initialiser
+ (instancetype)offerObjectFromJSON:(NSDictionary *)jsonDict {
    FYBOfferObject *object = [[FYBOfferObject alloc] init];
    
    if ([jsonDict isKindOfClass:[NSDictionary class]]) {
        object.jsonDict = jsonDict;
    }
    
    return object;
}

- (NSString *)title {
   return _jsonDict[@"title"];
}
- (NSString *)teaser {
    return _jsonDict[@"teaser"];
}

- (NSURL *)thumbnail_hires_url {
    NSString *urlStr = _jsonDict[@"thumbnail"][@"hires"];
    return [NSURL URLWithString:urlStr];
}

- (NSNumber *)payout {
    return _jsonDict[@"payout"];
}


@end
