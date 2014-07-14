//
//  SWRootWireframe.m
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWRootWireframe.h"
#import "SWFileStackHandler.h"
#import "SWHomeDirectoryHandler.h"

@interface SWRootWireframe () <SWFileStackHandlerDelegate, SWHomeDirectoryHandlerDelegate>

@property (nonatomic, strong) SWFileStackHandler *fileStackHandler;
@property (nonatomic, strong) SWHomeDirectoryHandler *homeDirectoryHandler;

@property (nonatomic, strong) NSArray *filesInHomeDirectory;

@end

@implementation SWRootWireframe

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupFileStackHandler];
        [self setupHomeDirectoryHandler];
    }
    return self;
}

- (void)setupFileStackHandler
{
    self.fileStackHandler = [[SWFileStackHandler alloc] init];
}

- (void)setupHomeDirectoryHandler
{
    self.homeDirectoryHandler = [[SWHomeDirectoryHandler alloc] init];
}

#pragma mark - SWFileStackHandlerDelegate methods

- (void)stackHandler:(SWFileStackHandler *)stackHandler failedToUndoProcessedFile:(SWProcessedFile *)processedFile error:(NSError *)error
{
    
}

#pragma mark - SWHomeDirectoryHandlerDelegate methods

- (void)homeDirectoryHandler:(SWHomeDirectoryHandler *)directoryHandler
didFinishMappingHomeDiretoryWithFileNames:(NSArray *)fileNames
{
    self.filesInHomeDirectory = fileNames;
}

- (void)homeDirectoryHandler:(SWHomeDirectoryHandler *)directoryHandler
                didFindFiles:(NSArray *)fileNames
             withQueryPrefix:(NSString *)queryPrefix
{
    
}


@end
