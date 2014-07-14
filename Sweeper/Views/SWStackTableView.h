//
//  SWStackTableView.h
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SWStackTableView;

@protocol SWStackTableViewEventDelegate <NSObject>

/**
 Notifies the delegate when the stackTableView receives a keyDown event
 @param keyEvent the key event this stackTableView received
 */
- (void)stackTableView:(SWStackTableView *)stackTableView didReceiveKeyEvent:(NSEvent *)keyEvent;

@end

@interface SWStackTableView : NSTableView

@property (nonatomic, weak) id<SWStackTableViewEventDelegate> keyEventDelegate;

@end
