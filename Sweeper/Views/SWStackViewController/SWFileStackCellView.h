//
//  SWFileStackCellView.h
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

FOUNDATION_EXPORT NSString * const SWFileStackCellView_Identifier;

@class SWUnProcessedFile;

@interface SWFileStackCellView : NSTableCellView

/**
 Updates the cell with given information from unprocessedFile
 @param unprocessedFile the file instance that this cell needs to represent
 */
- (void)updateWithUnprocessedFile:(SWUnProcessedFile *)unprocessedFile;

@end
