//
//  SWMainWindowController.m
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWMainWindowController.h"
#import "SWRootWireframe.h"

#import "SWHomeDirectoryViewController.h"
#import "SWStackViewController.h"


NSString *const SWMainWindowController_NIB_Name = @"SWMainWindowController";

@interface SWMainWindowController ()

@property (nonatomic, weak) IBOutlet NSView *fileStackViewContainerView;
@property (nonatomic, weak) IBOutlet NSView *homeDirectoryViewContainerView;

@end

@implementation SWMainWindowController

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupHomeDirectoryView];
    [self setupFileStackView];
}

- (void)switchToDirectorySearchView
{
    [self hideFileStackView];
    [self showDirectorySearchView];
}

- (void)switchToFileStackView
{
    [self hideDirectorySearchView];
    [self showFileStackView];
}


#pragma mark - Private initializer methods

- (void)setupFileStackView
{
    NSView *fileStackView = self.rootWireframe.fileStackViewController.view;
    [fileStackView setFrame:self.fileStackViewContainerView.frame];
    [self.fileStackViewContainerView addSubview:fileStackView];
    [self.fileStackViewContainerView setWantsLayer:YES];
    [self.window makeFirstResponder:self.fileStackViewContainerView];
    
}

- (void)setupHomeDirectoryView
{
    NSView *homeDirectoryView = self.rootWireframe.homeDirectoryViewController.view;
    [homeDirectoryView setFrame:self.homeDirectoryViewContainerView.frame];
    [self.homeDirectoryViewContainerView addSubview:homeDirectoryView];
    [self.homeDirectoryViewContainerView setWantsLayer:YES];
    [self.homeDirectoryViewContainerView setAlphaValue:0.0];
}


#pragma mark - Helper methods for transitioning fileStackView and homeDirectoryView

- (void)hideFileStackView
{
    [self.fileStackViewContainerView setAlphaValue:0.0];
    [self.fileStackViewContainerView resignFirstResponder];
}

- (void)showDirectorySearchView
{
    [self.homeDirectoryViewContainerView setAlphaValue:1.0];
    [self.window makeFirstResponder:self.rootWireframe.homeDirectoryViewController];
}

- (void)showFileStackView
{
    [self.fileStackViewContainerView setAlphaValue:1.0];
    [self.window makeFirstResponder:self.rootWireframe.fileStackViewController];
}

- (void)hideDirectorySearchView
{
    [self.homeDirectoryViewContainerView setAlphaValue:0.0];
    [self.rootWireframe.homeDirectoryViewController resignFirstResponder];
}

@end
