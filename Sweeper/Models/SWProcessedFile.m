//
//  SWProcessedFile.m
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWProcessedFile.h"
#import "SWUnProcessedFile.h"

@interface SWProcessedFile ()

@property (nonatomic, assign) SWFileAction processedAction;
@property (nonatomic, readwrite) NSString *pathProcessedFrom;
@property (nonatomic, readwrite) NSString *currentPath;
@property (nonatomic, strong) NSImage *fileIcon;

@end

@implementation SWProcessedFile

+ (instancetype)processedFileFromUnprocessedFile:(SWUnProcessedFile *)anUnprocessedFile
                                      withAction:(SWFileAction)action
                                 destinationPath:(NSString *)aDestinationPath
{
    SWProcessedFile *processedFile = [[SWProcessedFile alloc] init];
    [processedFile setProcessedAction:action];
    [processedFile setPathProcessedFrom:[anUnprocessedFile filePath]];
    [processedFile setFileIcon:[anUnprocessedFile fileIcon]];
    [processedFile setCurrentPath:aDestinationPath];
    return processedFile;
}

@end
