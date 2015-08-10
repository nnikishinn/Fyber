//
//  FYBRequestViewModel.m
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import "FYBRequestViewModel.h"
#import "FyberSDK.h"

static const NSString *kFYBRequestAppid = @"2070";
static const NSString *kFYBRequestUid = @"spiderman";
static const NSString *kFYBRequestAPIKey = @"1c915e3b5d42d05136185030892fbb846c278927";

@implementation FYBRequestViewModel

#pragma mark -
#pragma mark Accessors - Getters
- (NSString *)requestAppid {
    if (!_requestAppid) {
        _requestAppid = [kFYBRequestAppid copy];
    }
    
    return _requestAppid;
}

- (NSString *)requestUid {
    if (!_requestUid) {
        _requestUid = [kFYBRequestUid copy];
    }
    
    return _requestUid;
}

- (NSString *)requestAPIKey {
    if (!_requestAPIKey) {
        _requestAPIKey = [kFYBRequestAPIKey copy];
    }
    
    return _requestAPIKey;
}

#pragma mark -
#pragma mark Appearance
- (NSString *)navigationBarTitle {
    return @"Request";
}

#pragma mark -
#pragma mark Methods
- (void)resetModelWithCompletion:(void (^)())completionBlock {
    _requestAppid = nil;
    _requestUid = nil;
    _requestAPIKey = nil;
    if (completionBlock) completionBlock();
}

- (void)getOffersWithSuccessBlock:(void (^)(NSArray * offersArray))sucessBlock
                       errorBlock:(void (^)(NSError *error))errorBlock {
    
    [FYBAPIClient getOffersWithParametersAppid:self.requestAppid requestUid:self.requestUid requestAPIKey:self.requestAPIKey successBlock:^(NSArray *offersArray) {
        if (sucessBlock) sucessBlock(offersArray);
    } errorBlock:^(NSError *error) {
        if (errorBlock) errorBlock (error);
    }];
}



@end
