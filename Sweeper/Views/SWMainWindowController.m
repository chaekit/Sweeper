//
//  SWMainWindowController.m
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWMainWindowController.h"
#import "SWRootWireframe.h"

@interface SWMainWindowController ()

@property (nonatomic, strong) SWRootWireframe *rootWireframe;

@end

@implementation SWMainWindowController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rootWireframe = [[SWRootWireframe alloc] init];
    [self setupInitivalView];
}

- (void)setupInitivalView {
    NSView *fileStackView = self.rootWireframe.fileStackViewController.view;
    [self.window.contentView addSubview:fileStackView];
    [self.window.contentView setFrame:fileStackView.bounds];
}

@end
