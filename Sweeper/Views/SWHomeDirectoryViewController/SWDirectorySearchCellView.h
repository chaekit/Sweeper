//
//  SWDirectorySearchCellView.h
//  Sweeper
//
//  Created by Jay Chae  on 1/7/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

FOUNDATION_EXPORT NSString * const SWDirectorySearchCellView_Identifier;

/**
 Cell that displays information about directories in home directory
 */
@interface SWDirectorySearchCellView : NSTableCellView

/**
 Updates the cell with given full path to the directory
 @param pathTODirectory Full path to the directory
 */
- (void)updateWithPathToDirectory:(NSString *)pathToDirectory;

@end
