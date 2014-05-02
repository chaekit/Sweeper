//
//  SWUnProcessedFile.h
//  Sweeper
//
//  Created by Jay Chae  on 1/2/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWProcessedFile;

/*
 Class SWUnProcessedFile
 
 Initial state of a file. When a file operation is applied using SWFileStackHandler, a SWProcessedFile is 
 created from SWUnProcessedFile.
 */
@interface SWUnProcessedFile : NSObject

/*
 Path of the SWUnProcessedFile
 */
@property (nonatomic, strong) NSString *filePath;

/*
 File name of the SWUnProcessedFile
 */
@property (nonatomic, strong) NSString *fileName;

/*
 File icon image
 */
@property (nonatomic, strong) NSImage *fileIcon;

/*
 Returns YES if the file at filePath is a directory.
 */
@property (nonatomic, getter = isDirectory) BOOL directory;

/*
 Returns an instance of SWUnProcessedFile given the file path
 */
+ (instancetype)unprocessedFileAtPath:(NSString *)path;

@end
