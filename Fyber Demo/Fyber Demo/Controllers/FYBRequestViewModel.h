//
//  FYBRequestViewModel.h
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import "FYBBaseViewModel.h"

@interface FYBRequestViewModel : FYBBaseViewModel

@property (nonatomic, copy) NSString *requestAppid;
@property (nonatomic, copy) NSString *requestUid;
@property (nonatomic, copy) NSString *requestAPIKey;

- (void)resetModelWithCompletion:(void (^)())completionBlock;
- (void)getOffersWithSuccessBlock:(void (^)(NSArray * offersArray))sucessBlock
                          errorBlock:(void (^)(NSError *error))errorBlock;

@end
