//
//  SWStackViewController.m
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWStackViewController.h"
#import "SWStackTableView.h"
#import "SWFileStackCellView.h"
#import "SWFileStack.h"

NSString * SWStackViewController_NIB_Name = @"SWStackViewController";

static NSString * const kSWStackViewControllerStackViewCellColumnIdentifier = @"SWStackViewControllerStackViewCellColumnIdentifier";

@class SWUnProcessedFile;

@interface SWStackViewController () <SWStackTableViewEventDelegate,
                                        NSTableViewDataSource,
                                        NSTableViewDelegate>

@property (nonatomic, weak) IBOutlet SWStackTableView *fileStackTableView;

@end

@implementation SWStackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.fileStackTableView setKeyEventDelegate:self];
}


#pragma mark - SWStackTableViewEventDelegate methods

- (void)stackTableView:(SWStackTableView *)stackTableView didReceiveKeyEvent:(NSEvent *)keyEvent
{
    
}


#pragma mark - NSTableViewDelegate & NSTableViewDataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.fileStackDataSource stackCount];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (![[tableColumn identifier] isEqualToString:kSWStackViewControllerStackViewCellColumnIdentifier]) {
        return nil;
    }
    
    SWFileStackCellView *cellView = [tableView makeViewWithIdentifier:SWFileStackCellView_Identifier owner:self];
    SWUnProcessedFile *unprocessedFile = [self.fileStackDataSource fileAtIndex:row];
    [cellView updateWithUnprocessedFile:unprocessedFile];
    return cellView;
}


@end
