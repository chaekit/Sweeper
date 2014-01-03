//
//  SweeperTests.m
//  SweeperTests
//
//  Created by Jay Chae  on 1/2/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SWUnProcessedFile.h"

@interface SweeperTests : XCTestCase

@property (nonatomic, strong) SWUnProcessedFile *unprocessedFile;

@end

@implementation SweeperTests

@synthesize unprocessedFile;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    unprocessedFile = nil;
}

- (void)testRespondingProperties {
    unprocessedFile = [[SWUnProcessedFile alloc] init];
    BOOL respondsToFilePath = [unprocessedFile respondsToSelector:@selector(filePath)];
    BOOL respondsToFileName = [unprocessedFile respondsToSelector:@selector(fileName)];
    BOOL respondsToIsDirectory = [unprocessedFile respondsToSelector:@selector(isDirectory)];
    
    XCTAssertTrue(respondsToFilePath, @"Unprocessed path responds to filePath property");
    XCTAssertTrue(respondsToFileName, @"Unprocessed path responds to fileName property");
    XCTAssertTrue(respondsToIsDirectory, @"Unprocessed path responds to isDirectory property");
}

- (void)testUnprocessedFileAtPath {
    unprocessedFile = [SWUnProcessedFile unprocessedFileAtPath:@"/mock/mock.txt"];
    XCTAssertTrue([unprocessedFile filePath], @"/mock/mock.txt");
    XCTAssertTrue([unprocessedFile fileName], @"mock.txt");
}

@end
