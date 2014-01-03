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

@interface SWFileStackHandler ()

@end

@implementation SWFileStackHandler

@synthesize unprocessedFileStack;
@synthesize processedFileStack;

- (id)init {
    self = [super init];
    if (self) {
        unprocessedFileStack = [[SWFileStack alloc] init];
        processedFileStack = [[SWFileStack alloc] init];
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

@end
