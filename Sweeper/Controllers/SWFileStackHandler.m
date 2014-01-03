//
//  SWFileStackHandler.m
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWFileStackHandler.h"
#import "SWFileStack.h"
#import "SWUnProcessedFile.h"
#import "SWProcessedFile.h"

@interface SWFileStackHandler ()

@property (nonatomic, strong) NSWorkspace *workspace;

@end

@implementation SWFileStackHandler

@synthesize unprocessedFileStack;
@synthesize processedFileStack;
@synthesize workspace;

- (id)init {
    self = [super init];
    if (self) {
        unprocessedFileStack = [[SWFileStack alloc] init];
        processedFileStack = [[SWFileStack alloc] init];
        workspace = [[NSWorkspace alloc] init];
    }
    return self;
}

+ (instancetype)stackHandlerForURL:(NSString *)anURLString {
    SWFileStackHandler *handler = [[SWFileStackHandler alloc] init];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error;
   
    /* testing */
    NSArray *contentsAtURL = [fileManager contentsOfDirectoryAtPath:anURLString error:&error];
    for (NSString *fileName in contentsAtURL) {
        NSString *fullFilePath = [NSString pathWithComponents:@[anURLString, fileName]];
        SWUnProcessedFile *unprocessedFile = [SWUnProcessedFile unprocessedFileAtPath:fullFilePath];
        [handler.unprocessedFileStack pushObject:unprocessedFile];
    }
    NSLog(@"%@", handler.unprocessedFileStack);
    return handler;
}


- (void)removeHeadFile {
    SWUnProcessedFile *unprocessedFile = (SWUnProcessedFile *)[unprocessedFileStack popHead];
    NSString *unprocessedFilePath = [unprocessedFile filePath];
    NSLog(@"filePath  %@", unprocessedFilePath);
    [workspace recycleURLs:@[[NSURL fileURLWithPath:unprocessedFilePath]]  completionHandler:nil];   //handle error
    SWProcessedFile *processedFile = [SWProcessedFile processedFileFromUnprocessedFile:unprocessedFile Action:@"Remove"];
    [processedFile setCurrentPath:@"Trash"];
    [processedFileStack pushObject:processedFile];
}

- (void)moveHeadFileToDirectoryAtPath:(NSString *)aURLString {
    
}

- (void)deferHeadFile {
    SWUnProcessedFile *unprocessedFile = (SWUnProcessedFile *)[unprocessedFileStack popHead];
    SWProcessedFile *processedFile = [SWProcessedFile processedFileFromUnprocessedFile:unprocessedFile Action:@"Defer"];
    [processedFile setCurrentPath:@"Not Changed"];
    [processedFileStack pushObject:processedFile];
}

- (void)undoPreviousAction {
}

@end
