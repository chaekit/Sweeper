//
//  SWFileStackHandlerTests.m
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SWFileStackHandler.h"

@interface SWFileStackHandlerTests : XCTestCase

@end

@implementation SWFileStackHandlerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testStackHandlerForURL {
    SWFileStackHandler *stackHandler = [SWFileStackHandler stackHandlerForURL:@"/Users/jaychae/Documents"];
    XCTAssertTrue(true, @"test");
}

@end
