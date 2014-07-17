//
//  SWMainWindowController.h
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SWRootWireframe;
/**
 Container window that displays directorySearchView and fileStackView
 */
@interface SWMainWindowController : NSWindowController

/**
 Shows diretorySearchView
 */
- (void)switchToDirectorySearchView;

/**
 Shows fileStackView
 */
- (void)switchToFileStackView;

@property (nonatomic, weak) SWRootWireframe *rootWireframe;
@end
