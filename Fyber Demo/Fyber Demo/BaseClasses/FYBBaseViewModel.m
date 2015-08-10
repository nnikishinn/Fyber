//
//  FYBBaseViewModel.m
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import "FYBBaseViewModel.h"

@implementation FYBBaseViewModel

+ (instancetype)model {
    return [[self alloc] init];
}

- (NSString *)navigationBarTitle {
    return nil;
}

@end
