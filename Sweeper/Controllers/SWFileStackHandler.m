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
    return handler;
}


- (void)removeHeadFile {
    SWUnProcessedFile *unprocessedFile = (SWUnProcessedFile *)[unprocessedFileStack popHead];
    NSString *unprocessedFilePath = [unprocessedFile filePath];
    NSLog(@"filePath  %@", unprocessedFilePath);
    [workspace recycleURLs:@[[NSURL fileURLWithPath:unprocessedFilePath]] completionHandler:nil];
    SWProcessedFile *processedFile = [SWProcessedFile processedFileFromUnprocessedFile:unprocessedFile Action:@"Remove"];
    NSString *processedFilePath = [NSString stringWithFormat:@"%@/%@", @"/Users/jaychae/.Trash", [unprocessedFile fileName]];
    [processedFile setCurrentPath:processedFilePath];
    [processedFileStack pushObject:processedFile];
}

- (void)moveHeadFileToDirectoryAtPath:(NSString *)aPathString {
    SWUnProcessedFile *unprocessedFile = (SWUnProcessedFile *)[unprocessedFileStack popHead];
    SWProcessedFile *processedFile = [SWProcessedFile processedFileFromUnprocessedFile:unprocessedFile Action:@"Move"];
    
   
//    NSString *currentPath = [NSString stringWithFormat:@"%@/%@", aPathString, unprocessedFile]
    NSString *destinationPath = [NSString stringWithFormat:@"%@/%@", aPathString, [unprocessedFile fileName]];
    [processedFile setCurrentPath:destinationPath];
    [processedFileStack pushObject:processedFile];
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:[unprocessedFile filePath] toPath:destinationPath error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (void)deferHeadFile {
    SWUnProcessedFile *unprocessedFile = (SWUnProcessedFile *)[unprocessedFileStack popHead];
    SWProcessedFile *processedFile = [SWProcessedFile processedFileFromUnprocessedFile:unprocessedFile Action:@"Defer"];
    [processedFile setCurrentPath:@"Not Changed"];
    [processedFileStack pushObject:processedFile];
}

- (void)undoPreviousAction {
    if ([unprocessedFileStack stackCount] <= 0)
        return;
    
    SWProcessedFile *processedFile = (SWProcessedFile *)[processedFileStack popHead];
    SWUnProcessedFile *unprocessedFile;
    NSString *processedAction = [processedFile processedAction];
    
    if ([processedAction isEqualToString:@"Remove"]) {
        NSString *currentPath = [processedFile currentPath];
        NSString *destinationPath = [processedFile pathProcessedFrom];
        unprocessedFile = [SWUnProcessedFile unprocessedFileAtPath:[processedFile pathProcessedFrom]];
        [unprocessedFileStack pushObject:unprocessedFile];
       
        NSError *error;
        [[NSFileManager defaultManager] moveItemAtPath:currentPath toPath:destinationPath error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    } else if ([processedAction isEqualToString:@"Move"]) {
        NSString *currentPath = [processedFile currentPath];
        NSString *destinationPath = [processedFile pathProcessedFrom];
        unprocessedFile = [SWUnProcessedFile unprocessedFileAtPath:[processedFile pathProcessedFrom]];
        [unprocessedFileStack pushObject:unprocessedFile];
       
        NSError *error;
        [[NSFileManager defaultManager] moveItemAtPath:currentPath toPath:destinationPath error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    } else if ([processedAction isEqualToString:@"Defer"]) {
        unprocessedFile = [SWUnProcessedFile unprocessedFileAtPath:[processedFile pathProcessedFrom]];
        [unprocessedFileStack pushObject:unprocessedFile];
    }
}

@end
