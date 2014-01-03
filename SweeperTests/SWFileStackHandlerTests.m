//
//  SWFileStackHandlerTests.m
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "SWFileStackHandler.h"
#import "SWFileStack.h"
#import "SWProcessedFile.h"

@interface SWFileStackHandler (SWFileStackHandlerTest)

@property (nonatomic, strong) NSWorkspace *workspace;

@end

@interface SWFileStackHandlerTests : XCTestCase

@property (nonatomic, strong) SWFileStackHandler *stackHandler;

@end

@implementation SWFileStackHandlerTests

@synthesize stackHandler;

- (void)setUp {
    [super setUp];
    stackHandler = [SWFileStackHandler stackHandlerForURL:@"/Users/jaychae/Documents"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testHasBothStacksAfterInitialization {
    BOOL respondsToProcessedStack = [stackHandler respondsToSelector:@selector(processedFileStack)];
    BOOL respondsToUnprocessedStack = [stackHandler respondsToSelector:@selector(unprocessedFileStack)];
    
    XCTAssertTrue(respondsToProcessedStack, @"Responds to processedFileStack");
    XCTAssertTrue(respondsToUnprocessedStack, @"Responds to unprocessedFileStack");
}

- (void)testRemoveHeadFile {
    id workspaceMock = [OCMockObject mockForClass:[NSWorkspace class]];
    [[workspaceMock expect] recycleURLs:[OCMArg any] completionHandler:nil];
    stackHandler.workspace = workspaceMock;
    NSInteger previousUnprocessedCount = [stackHandler.unprocessedFileStack stackCount];
    NSInteger previousProcessedCount = [stackHandler.processedFileStack stackCount];
    
    [stackHandler removeHeadFile];
    
    NSInteger newUnprocessedCount = [stackHandler.unprocessedFileStack stackCount];
    NSInteger newProcessedCount = [stackHandler.processedFileStack stackCount];
    
    XCTAssertTrue(newUnprocessedCount == previousUnprocessedCount - 1, @"The count of unprocessedCount should decrease by 1");
    XCTAssertTrue(newProcessedCount == previousProcessedCount + 1, @"The count of processedCount should increase by 1");
}

- (void)testCheckPropertiesOfRemovedFile {
    id workspaceMock = [OCMockObject mockForClass:[NSWorkspace class]];
    [[workspaceMock expect] recycleURLs:[OCMArg any] completionHandler:nil];
    stackHandler.workspace = workspaceMock;
    
    [stackHandler removeHeadFile];
    SWProcessedFile *processedFile = (SWProcessedFile *)[stackHandler.processedFileStack headObject];
    NSString *currentPathOfNewlyRemovedFile = [processedFile currentPath];
    XCTAssertTrue([currentPathOfNewlyRemovedFile isEqualToString:@"Trash"], @"Removed file should have 'Trash' as its currentPath");
    XCTAssertTrue([processedFile.processedAction isEqualToString:@"Remove"], @"Removed file should have 'Remove' as its processedAction");
}

- (void)testDeferHeadFile {
    NSInteger previousUnprocessedCount = [stackHandler.unprocessedFileStack stackCount];
    NSInteger previousProcessedCount = [stackHandler.processedFileStack stackCount];
    
    [stackHandler deferHeadFile];
    
    NSInteger newUnprocessedCount = [stackHandler.unprocessedFileStack stackCount];
    NSInteger newProcessedCount = [stackHandler.processedFileStack stackCount];
    
    XCTAssertTrue(newUnprocessedCount == previousUnprocessedCount - 1, @"The count of unprocessedCount should decrease by 1 after deferHead");
    XCTAssertTrue(newProcessedCount == previousProcessedCount + 1, @"The count of processedCount should increase by 1 after deferHead");
}


- (void)testCheckPropertiesOfDeferredFile {
    [stackHandler deferHeadFile];
    SWProcessedFile *processedFile = (SWProcessedFile *)[stackHandler.processedFileStack headObject];
    NSString *currentPathOfNewlyDeferredFile = [processedFile currentPath];
    XCTAssertTrue([currentPathOfNewlyDeferredFile isEqualToString:@"Not Changed"], @"Deferred file should have 'Not Changed' as its currentPath");
    XCTAssertTrue([processedFile.processedAction isEqualToString:@"Defer"], @"Deferred file should have 'Defer' as its processedAction");
}


@end
