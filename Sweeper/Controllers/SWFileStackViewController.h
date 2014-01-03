//
//  SWFileStackViewController.h
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SWFileStackHandler;

@interface SWFileStackViewController : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) IBOutlet NSTableView *fileTableView;
@property (nonatomic, strong) SWFileStackHandler *fileStackHandler;

@end
