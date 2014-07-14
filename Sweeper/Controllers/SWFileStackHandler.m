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

static NSInteger remainingAsyncTaskCountGlobal;

@interface SWFileStackHandler ()

@property (nonatomic, strong) NSWorkspace *workspace;

@property (nonatomic, strong) SWFileStack *unprocessedFileStack;
@property (nonatomic, strong) SWFileStack *processedFileStack;

@end

@implementation SWFileStackHandler

- (id)init {
    self = [super init];
    if (self) {
        _unprocessedFileStack = [[SWFileStack alloc] init];
        _processedFileStack = [[SWFileStack alloc] init];
        _workspace = [[NSWorkspace alloc] init];
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
   
    NSTimer *watchdogTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                              target:self
                                                            selector:@selector(checkOnAsyncStackHandlerLoading:) userInfo:nil
                                                             repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:watchdogTimer forMode:NSRunLoopCommonModes];
    
    NSCondition *waitForAsynTasks = [[NSCondition alloc] init];
    for (NSString *fileName in contentsAtURL) {
        BOOL fileIsDotfile = ([fileName rangeOfString:@"." options:NSBackwardsSearch].location == 0);
        
        if (fileIsDotfile) {
            remainingAsyncTaskCount--;
            continue;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *fullFilePath = [NSString pathWithComponents:@[aURLString, fileName]];
            SWUnProcessedFile *unprocessedFile = [SWUnProcessedFile unprocessedFileAtPath:fullFilePath];
            [temporaryUnprocessedFileStack pushObject:unprocessedFile];
            remainingAsyncTaskCount--;
            if (remainingAsyncTaskCount == 0) {
                [waitForAsynTasks signal];
            }
        });
    }

    [waitForAsynTasks lock];
    while (remainingAsyncTaskCount > 0) {
        [waitForAsynTasks wait];
    }
    
    [waitForAsynTasks unlock];
    
    [watchdogTimer invalidate];
    [handler setUnprocessedFileStack:temporaryUnprocessedFileStack];
    
    return handler;
}

- (void)checkOnAsyncStackHandlerLoading:(NSTimer *)watchdogTimer {
    if (remainingAsyncTaskCountGlobal > 0) {
        [self.delegate stackHandlerFailedToLoad];
    }
}


#pragma mark - file operations

- (NSInteger)countOfUnprocessedFileStackObjects {
    return [self.unprocessedFileStack stackCount];
}

- (void)removeHeadFile {
    SWUnProcessedFile *unprocessedFile = (SWUnProcessedFile *)[self.unprocessedFileStack popHead];
    [self moveUnprocessedFileToTrash:unprocessedFile];
}

- (void)moveHeadFileToDirectoryAtPath:(NSString *)aPathString {
    SWUnProcessedFile *unprocessedFile = (SWUnProcessedFile *)[self.unprocessedFileStack popHead];
    NSString *destinationPath = [NSString stringWithFormat:@"%@/%@", aPathString, [unprocessedFile fileName]];
    SWProcessedFile *processedFile = [SWProcessedFile processedFileFromUnprocessedFile:unprocessedFile
                                                                            withAction:SWFileActionMoveFile
                                                                       destinationPath:destinationPath];
    [self moveUnprocessedFile:unprocessedFile toNewDestination:destinationPath];
    [self.processedFileStack pushObject:processedFile];
}

- (void)deferHeadFile {
    SWUnProcessedFile *unprocessedFile = (SWUnProcessedFile *)[self.unprocessedFileStack popHead];
    SWProcessedFile *processedFile = [SWProcessedFile processedFileFromUnprocessedFile:unprocessedFile
                                                                            withAction:SWFileActionDeferFile
                                                                       destinationPath:nil];
    [self.processedFileStack pushObject:processedFile];
}

- (void)undoPreviousAction:(NSError * __autoreleasing *)error {
    if ([self.processedFileStack stackCount] <= 0) {
        if (error) {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorFileDoesNotExist userInfo:nil];
        }
        return;
    }

    SWProcessedFile *processedFile = (SWProcessedFile *)[self.processedFileStack popHead];
    SWFileAction processedAction = [processedFile processedAction];
    
    switch (processedAction) {
        case SWFileActionMoveFile:
        case SWFileActionDeleteFile: {
            [self moveProcessedFileBackToWhereItCameFrom:processedFile];
            [self.unprocessedFileStack pushObject:[self unprocessedFileFromProcessedFile:processedFile]];
           
        }
        break;
        case SWFileActionDeferFile:
            [self.unprocessedFileStack pushObject:[self unprocessedFileFromProcessedFile:processedFile]];
        default:
            break;
    }
}


#pragma mark - undoPreviousAction helper methods

- (SWUnProcessedFile *)unprocessedFileFromProcessedFile:(SWProcessedFile *)processedFile {
    SWUnProcessedFile *unprocessedFile = [SWUnProcessedFile unprocessedFileAtPath:[processedFile pathProcessedFrom]];
    [unprocessedFile setFileIcon:[processedFile fileIcon]];
    return unprocessedFile;
}

- (void)moveProcessedFileBackToWhereItCameFrom:(SWProcessedFile *)processedFile {
    NSString *currentPath = [processedFile currentPath];
    NSString *destinationPath = [processedFile pathProcessedFrom];
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:currentPath toPath:destinationPath error:&error];
    if (error) {
        [self.delegate stackHandler:self failedToUndoProcessedFile:processedFile error:error];
    }
}


#pragma mark - moveHeadFile helper methods

- (void)moveUnprocessedFile:(SWUnProcessedFile *)unprocessedFile toNewDestination:(NSString *)newDestination {
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:[unprocessedFile filePath] toPath:newDestination error:&error];
    if (error) {
//        NSDictionary *userInfo = @{@"processAction": SWFileStackHandlerProcessActionMoved,
//                                   @"error": error};
//        [self.delegate stackHandlerFailedProcessWithUserInfo:userInfo];
    }
    
}


#pragma mark - removeHeadFile helper methods

- (void)moveUnprocessedFileToTrash:(SWUnProcessedFile *)unprocessedFile {
    NSString *unprocessedFilePath = [unprocessedFile filePath];
    [self.workspace recycleURLs:@[[NSURL fileURLWithPath:unprocessedFilePath]]
              completionHandler:^(NSDictionary *newURLs, NSError *error) {
                  if (error) {
//                      NSDictionary *userInfo = @{@"processAction": SWFileStackHandlerProcessActionRemoved,
//                                                 @"error": error};
//                      [self.delegate stackHandlerFailedProcessWithUserInfo:userInfo];
                  }
                  
                  NSString *processedFilePath = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @".Trash", [unprocessedFile fileName]];
                  SWProcessedFile *processedFile = [SWProcessedFile processedFileFromUnprocessedFile:unprocessedFile
                                                                                          withAction:SWFileActionDeleteFile
                                                                                     destinationPath:processedFilePath];
                  [self.processedFileStack pushObject:processedFile];
              }];
}

@end
