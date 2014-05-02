//
//  SWFileStackHandler.h
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWUnProcessedFile;
@class SWFileStack;

/*
 Possible statuses of SWProcessedFile's 
 */
extern NSString * const SWFileStackHandlerProcessActionRemoved;
extern NSString * const SWFileStackHandlerProcessActionMoved;
extern NSString * const SWFileStackHandlerProcessActionDeferred;

/*
 Class SWFileStackHandler
 
 SWFileStackHandler is an interface layer to SWFileStack(s). It handles various operations a set of fileStacks.
 */
@interface SWFileStackHandler : NSObject

/*
 Creates a handler for a given URL
 */
+ (instancetype)stackHandlerForURL:(NSString *)aURLString;

/*
 A SWFileStack of files that need to be processed.
 After a file is processed, it is popped and then pushed to processedFileStack.
 */
@property (nonatomic, strong) SWFileStack *unprocessedFileStack;

/*
 A SWFileStack of files that already have been processed.
 */
@property (nonatomic, strong) SWFileStack *processedFileStack;

/*
 Moves the head of unprocessedFileStack to Trash
 */
- (void)removeHeadFile;

/*
 Pops the head of unprocessedFileStack and moves the head of unprocessedFileStack to the given aURLString
 @param aURLString - the URL of the directory path the file should be moved to
 */
- (void)moveHeadFileToDirectoryAtPath:(NSString *)aURLString;

/*
 Pops the head of unprocessedFileStack and does NO file operation on it. It just pushes the popped head to
 processedFileStack
 */
- (void)deferHeadFile;

/*
 Pops the head from processedFileStack and pushes it to unprocessedFileStack
 */
- (void)undoPreviousAction:(NSError * __autoreleasing *)error;

@end
