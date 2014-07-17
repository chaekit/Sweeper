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
@class SWStackViewController;

@protocol SWStackViewControllerEventDelegate <NSObject>

/**
 Called when a stackViewController receives a remove file action
 */
- (void)stackViewConrollerDidReceiveRemoveFileAction:(SWStackViewController *)stackViewController;

/**
 Called when a stackViewController receives a leave file action
 */
- (void)stackViewConrollerDidReceiveLeaveFileAction:(SWStackViewController *)stackViewController;

/**
 Called when a stackViewController receives a undo file action
 */
- (void)stackViewConrollerDidReceiveUndoFileAction:(SWStackViewController *)stackViewController;

/**
 Called when a stackViewController receives a move file action
 */
- (void)stackViewConrollerDidReceiveMoveFileAction:(SWStackViewController *)stackViewController;

@end

@interface SWStackViewController : NSViewController

/**
 A SWFileStack of unprocessed files that this view controller has to display
 */
@property (nonatomic, strong) SWFileStack *fileStackDataSource;

@property (nonatomic, weak) id<SWStackViewControllerEventDelegate> delegate;

/**
 Pops the top cell of the table view with given fileAction
 @param fileAction the action that was given.
 */
- (void)popStackCellViewForAction:(SWFileAction)fileAction;

/**
 Pushes a new cell to the table view with given fileAction
 @param fileAction the action that was given.
 */
- (void)pushStackCellViewForAction:(SWFileAction)fileAction;

/**
 Hides the stack view.
 */
- (void)hideStackView;

@end
