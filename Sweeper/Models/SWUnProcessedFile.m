//
//  SWUnProcessedFile.m
//  Sweeper
//
//  Created by Jay Chae  on 1/2/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWUnProcessedFile.h"

@implementation SWUnProcessedFile

@synthesize filePath;
@synthesize fileName;
@synthesize fileIcon;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (instancetype)unprocessedFileAtPath:(NSString *)path {
    NSString *fileName = [[path componentsSeparatedByString:@"/"] lastObject];
    
    SWUnProcessedFile *unprocessedFile = [[SWUnProcessedFile alloc] init];
    [unprocessedFile setFilePath:path];
    [unprocessedFile setFileName:fileName];
    
    NSWorkspace *workspace = [[NSWorkspace alloc] init];
    [unprocessedFile setFileIcon:[workspace iconForFile:path]];
    
    return unprocessedFile;
}

@end
