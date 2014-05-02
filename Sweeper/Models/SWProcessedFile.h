//
//  SWProcessedFile.h
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWUnProcessedFile;

/*
 Class SWProcessedFile
 
 Every SWProcessedFile action starts from a SWUnProcessedFile.
 After a file operation was applied to the SWUnprocessedFile, it is transformed into a SWProcessedFile.
 */
@interface SWProcessedFile : NSObject

/*
 The action that was applied to the unprocessedFile.
 This property is referenced to undo the file operation.
 */
@property (nonatomic, strong) NSString *processedAction;

/*
 The path of the file before it was processed.
 */
@property (nonatomic, strong) NSString *pathProcessedFrom;

/*
 The current path of the file after file operation
 */
@property (nonatomic, strong) NSString *currentPath;

/*
 The file icon
 */
@property (nonatomic, strong) NSImage *fileIcon;

/*
 Factory method for transforming unprocessedFile to processedFile
 */
+ (instancetype)processedFileFromUnprocessedFile:(SWUnProcessedFile *)anUnprocessedFile
                                          Action:(NSString *)action;

@end
