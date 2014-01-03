//
//  SWUnProcessedFile.h
//  Sweeper
//
//  Created by Jay Chae  on 1/2/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWProcessedFile;

@interface SWUnProcessedFile : NSObject

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSImage *fileIcon;
@property (nonatomic, getter = isDirectory) BOOL directory;

+ (instancetype)unprocessedFileAtPath:(NSString *)path;
+ (instancetype)unprocessedFileFromProcessFile:(SWProcessedFile *)processedFile;

@end
