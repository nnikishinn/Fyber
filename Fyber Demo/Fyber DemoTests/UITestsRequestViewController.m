//
//  KIFTestCase+UITestsRequestViewController.m
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/10/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import "UITestsRequestViewController.h"

@implementation UITestsRequestViewController

- (void)testMandatoryFieldsFunctionality {
    [tester clearTextFromViewWithAccessibilityLabel:@"textFieldUid"];
    [tester enterTextIntoCurrentFirstResponder:@"\n"];
    
    UIView *view = [tester waitForViewWithAccessibilityLabel:@"labelMandatoryFields"];
    XCTAssert(!view.hidden, @"labelMandatoryFields view should be visible");
   
    [tester clearTextFromViewWithAccessibilityLabel:@"textFieldApiKey"];
    [tester enterTextIntoCurrentFirstResponder:@"\n"];

   
    XCTAssert(!view.hidden, @"labelMandatoryFields view should be visible");
   
    [tester clearTextFromViewWithAccessibilityLabel:@"textFieldAppid"];
    XCTAssert(!view.hidden, @"labelMandatoryFields view should be visible");
    
    [tester tapViewWithAccessibilityLabel:@"navItemReset"];
    XCTAssert(view.hidden, @"labelMandatoryFields view should be hidden");
}

@end
