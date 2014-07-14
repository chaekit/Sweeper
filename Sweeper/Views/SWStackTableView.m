//
//  SWStackTableView.m
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWStackTableView.h"

@implementation SWStackTableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)keyDown:(NSEvent *)theEvent
{
    if ([[[self window] firstResponder] isNotEqualTo:self]) {
        return;
    }
    [self.keyEventDelegate stackTableView:self didReceiveKeyEvent:theEvent];
}


@end
