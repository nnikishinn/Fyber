//
//  FYBOfferObjectProtocol.h
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/9/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FYBOfferObjectProtocol <NSObject>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *teaser;
@property (nonatomic, strong) NSURL *thumbnail_hires_url;
@property (nonatomic, strong) NSNumber *payout;

@end
