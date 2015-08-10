//
//  FyberSDK_UnitTests.m
//  FyberSDK UnitTests
//
//  Created by Nickolai Nikishin on 8/10/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FYBAPIClient_Private.h"

@interface FyberSDK_UnitTests : XCTestCase

@end

@implementation FyberSDK_UnitTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testHashCalculation {
    NSDictionary *dict = @{@"appid" : @"2070",
                           @"apple_idfa" : @"026670C7-1FB8-4483-A6EF-AF5A9334BC64",
                           @"apple_idfa_tracking_enabled" : @"true",
                           @"device_id" : @"BE66D148-E9B2-4FA4-A79B-3E6FE5AAF053",
                           @"ip" : @"109.235.143.113",
                           @"locale" : @"DE",
                           @"offer_types" : @"112",
                           @"os_version" : @"8.4",
                           @"timestamp" : @"1439226010.056612",
                           @"uid" : @"spiderman"
                           };
    NSString *hash = [FYBAPIClient hashKeyForParamaters:dict requestAPIKey:@"1c915e3b5d42d05136185030892fbb846c278927"];
    XCTAssertEqualObjects(@"e0e6acf07f95fa89f365ec5124667da7c4af2a26", hash);
}



@end
