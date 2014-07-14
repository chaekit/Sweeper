//
//  SWStackViewController.h
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

FOUNDATION_EXPORT NSString * SWStackViewController_NIB_Name;

@class SWFileStack;

@interface SWStackViewController : NSViewController

@property (nonatomic, strong) SWFileStack *fileStackDataSource;

@end
