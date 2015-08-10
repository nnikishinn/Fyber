//
//  FYBBaseViewController.m
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import "FYBBaseViewController.h"

@interface FYBBaseViewController ()

@end

@implementation FYBBaseViewController

+ (instancetype)controllerWithXIB {
    id con = [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    return con;
}

+ (instancetype)controllerWithStoryBoard {
    id con = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return con;
}


@end
