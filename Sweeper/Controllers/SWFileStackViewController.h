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

@property (nonatomic, strong) IBOutlet NSTableView *fileTableView;
@property (nonatomic, strong) IBOutlet NSTableView *directorySearchTableView;
@property (nonatomic, strong) IBOutlet NSTextField *directorySearchBar;
@property (nonatomic, strong) IBOutlet NSScrollView *directorySearchTableViewContainer;
@property (nonatomic, strong) IBOutlet NSScrollView *fileTableViewContainer;
@property (nonatomic, strong) SWFileStackHandler *fileStackHandler;
@property (nonatomic, retain) NSMutableArray *directoriesInUserHomeDirectory;


- (NSString *)systemUserName;

- (void)showSearchBar;
- (void)hideSearchBar;
- (void)resetSearchBarText;

/*
 file actions
 */
- (void)deleteFile;
- (void)moveFileTo:(NSString *)destinationPath;
- (void)skipFile;

@end
