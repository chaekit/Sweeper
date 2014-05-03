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


NSString * const SWFileStackHandlerProcessActionRemoved = @"Remove";
NSString * const SWFileStackHandlerProcessActionMoved = @"Move";
NSString * const SWFileStackHandlerProcessActionDeferred = @"Defer";

static NSInteger remainingAsyncTaskCountGlobal;

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

+ (instancetype)stackHandlerForURL:(NSString *)aURLString {
    SWFileStackHandler *handler = [[SWFileStackHandler alloc] init];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error;
    NSArray *contentsAtURL = [fileManager contentsOfDirectoryAtPath:aURLString error:&error];
    
    __block SWFileStack *temporaryUnprocessedFileStack = [[SWFileStack alloc] init];
    __block NSInteger remainingAsyncTaskCount = [contentsAtURL count];
   
    /*
     Fire an interrupt 5 seconds after the asyncloading starts. Assume that asyncloading went wrong
     if the loading hasn't finished in 5 secs.
     */
    NSTimer *watchdogTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                              target:self
                                                            selector:@selector(checkOnAsyncStackHandlerLoading:) userInfo:nil
                                                             repeats:NO];
    
    for (NSString *fileName in contentsAtURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *fullFilePath = [NSString pathWithComponents:@[aURLString, fileName]];
            SWUnProcessedFile *unprocessedFile = [SWUnProcessedFile unprocessedFileAtPath:fullFilePath];
            [temporaryUnprocessedFileStack pushObject:unprocessedFile];
            remainingAsyncTaskCount--;
        });
    }

    /*
     Investigate why loop doesn't terminate when it is simply
     ''while (remainingAsyncTaskCount > 0);''
     Maybe the process has to update is register??
     */
    while (remainingAsyncTaskCount > 0) {
        remainingAsyncTaskCountGlobal = remainingAsyncTaskCount;
    }
    
    [watchdogTimer invalidate];
    [handler setUnprocessedFileStack:temporaryUnprocessedFileStack];
    
    NSLog(@"%ld remaining task", (long)remainingAsyncTaskCount);
    NSLog(@"%ld@ remaining task", [temporaryUnprocessedFileStack stackCount]);
    return handler;
}

- (void)checkOnAsyncStackHandlerLoading:(NSTimer *)watchdogTimer {
    if (remainingAsyncTaskCountGlobal > 0) {
        [self.delegate stackHandlerFailedToLoad];
    }
}


- (void)removeHeadFile {
    SWUnProcessedFile *unprocessedFile = (SWUnProcessedFile *)[unprocessedFileStack popHead];
    NSString *unprocessedFilePath = [unprocessedFile filePath];
    [workspace recycleURLs:@[[NSURL fileURLWithPath:unprocessedFilePath]] completionHandler:nil];
    SWProcessedFile *processedFile = [SWProcessedFile processedFileFromUnprocessedFile:unprocessedFile
                                                                                Action:SWFileStackHandlerProcessActionRemoved];
    NSString *processedFilePath = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @".Trash", [unprocessedFile fileName]];
    [processedFile setCurrentPath:processedFilePath];
    [processedFileStack pushObject:processedFile];
}

- (void)moveHeadFileToDirectoryAtPath:(NSString *)aPathString {
    SWUnProcessedFile *unprocessedFile = (SWUnProcessedFile *)[unprocessedFileStack popHead];
    SWProcessedFile *processedFile = [SWProcessedFile processedFileFromUnprocessedFile:unprocessedFile
                                                                                Action:SWFileStackHandlerProcessActionMoved];
    
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
    SWProcessedFile *processedFile = [SWProcessedFile processedFileFromUnprocessedFile:unprocessedFile
                                                                                Action:SWFileStackHandlerProcessActionDeferred];
    [processedFile setCurrentPath:@"Not Changed"];
    [processedFileStack pushObject:processedFile];
}

- (void)undoPreviousAction:(NSError * __autoreleasing *)error {
    if ([processedFileStack stackCount] <= 0) {
        if (error) {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorFileDoesNotExist userInfo:nil];
        }
        return;
    }

    SWProcessedFile *processedFile = (SWProcessedFile *)[processedFileStack popHead];
    SWUnProcessedFile *unprocessedFile;
    NSString *processedAction = [processedFile processedAction];
    
    if ([processedAction isEqualToString:SWFileStackHandlerProcessActionRemoved] ||
        [processedAction isEqualToString:SWFileStackHandlerProcessActionMoved]) {
        
        NSString *currentPath = [processedFile currentPath];
        NSString *destinationPath = [processedFile pathProcessedFrom];
        unprocessedFile = [SWUnProcessedFile unprocessedFileAtPath:[processedFile pathProcessedFrom]];
        [unprocessedFileStack pushObject:unprocessedFile];
       
        NSError *error;
        [[NSFileManager defaultManager] moveItemAtPath:currentPath toPath:destinationPath error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    } else if ([processedAction isEqualToString:SWFileStackHandlerProcessActionDeferred]) {
        unprocessedFile = [SWUnProcessedFile unprocessedFileAtPath:[processedFile pathProcessedFrom]];
        [unprocessedFileStack pushObject:unprocessedFile];
    }
}

@end
