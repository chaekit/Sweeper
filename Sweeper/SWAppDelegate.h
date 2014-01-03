//
//  SWAppDelegate.h
//  Sweeper
//
//  Created by Jay Chae  on 1/2/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SWFileStackHandler;

@interface SWAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTabViewDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
