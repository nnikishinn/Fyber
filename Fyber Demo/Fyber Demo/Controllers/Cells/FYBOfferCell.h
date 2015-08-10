//
//  FYBOfferCell.h
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBBaseCell.h"

@class FYBOfferObject;

@interface FYBOfferCell : FYBBaseCell

- (void)updateWithObject:(FYBOfferObject *)offerObject;

@end
