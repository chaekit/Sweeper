//
//  SWProcessedFile.h
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SWFileAction) {
    SWFileActionDeleteFile,
    SWFileActionDeferFile,
    SWFileActionMoveFile,
    SWFileActionUndoFile
};

@class SWUnProcessedFile;

/**
 Class SWProcessedFile
 
 Every SWProcessedFile action starts from a SWUnProcessedFile.
 After a file operation was applied to the SWUnprocessedFile, it is transformed into a SWProcessedFile.
 */
@interface SWProcessedFile : NSObject

/**
 The action that was applied to the unprocessedFile.
 This property is referenced to undo the file operation.
 */
@property (nonatomic, readonly) SWFileAction processedAction;

/**
 The path of the file before it was processed.
 */
@property (nonatomic, copy, readonly) NSString *pathProcessedFrom;

/**
 The current path of the file after file operation
 */
@property (nonatomic, copy, readonly) NSString *currentPath;

/**
 The file icon
 */
@property (nonatomic, readonly) NSImage *fileIcon;

/**
 Factory method for transforming unprocessedFile to processedFile
 
 @param anUnprocessedFile an instance of SWUnProcessedFile
 @param action a file action that was used to process the file
 */
+ (instancetype)processedFileFromUnprocessedFile:(SWUnProcessedFile *)anUnprocessedFile
                                      withAction:(SWFileAction)action;

@end
