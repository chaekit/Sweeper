//
//  SWFileStackViewController.h
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SWFileStackHandler;

@interface SWFileStackViewController : NSView <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>


/*
 NSTableView that displays all the SWUnProcessedFiles in the folder
 */
@property (nonatomic, strong) IBOutlet NSTableView *fileTableView;

/*
 NSTableView that displays all query results of system wide directory search
 */
@property (nonatomic, strong) IBOutlet NSTableView *directorySearchTableView;

/*
 NSTextField where user can type in query for directory search.
 */
@property (nonatomic, strong) IBOutlet NSTextField *directorySearchBar;

/*
 Container for directorySearchTableViewContainer
 */
@property (nonatomic, strong) IBOutlet NSScrollView *directorySearchTableViewContainer;

/*
 Container for fileTableViewContainer
 */
@property (nonatomic, strong) IBOutlet NSScrollView *fileTableViewContainer;

/*
 SWFileStackViewController uses fileStackHandler to apply file operations on SWUnProcessedFiles
 */
@property (nonatomic, strong) SWFileStackHandler *fileStackHandler;

/*
 show or hide directorySearchBar
 */
- (void)showSearchBar;
- (void)hideSearchBar;

/*
 file actions
 */
- (void)deleteFile;
- (void)moveFileTo:(NSString *)destinationPath;
- (void)skipFile;

@end
