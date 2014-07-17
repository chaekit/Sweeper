//
//  SWHomeDirectoryViewController.m
//  Sweeper
//
//  Created by Jay Chae  on 7/16/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWHomeDirectoryViewController.h"
#import "SWDirectorySearchCellView.h"

NSString * SWHomDirectoryViewController_NIB_Name = @"SWHomeDirectoryViewController";

static NSString * const kSWHomeDirectorySearchResultCellColumnIdentifier = @"SWHomeDirectorySearchResultCellColumnIdentifier";

static NSUInteger const kDefaultSelectedCellRow = 0;

@interface SWHomeDirectoryViewController () <NSTableViewDataSource,
                                                NSTableViewDelegate,
                                                NSTextFieldDelegate>

@property (nonatomic, weak) IBOutlet NSTableView *homeDirectorySearchTableView;
@property (nonatomic, weak) IBOutlet NSTextField *directorySearchTextField;
@property (nonatomic, assign) NSUInteger selectedHomeDirectorySearchTableViewRow;
@property (nonatomic, strong) NSArray *homeDirectoriesDataSource;

@end

@implementation SWHomeDirectoryViewController

- (void)updateHomeDirectoriesDataSource:(NSArray *)homeDirectoriesDataSource
{
    self.homeDirectoriesDataSource = homeDirectoriesDataSource;
    [self.homeDirectorySearchTableView reloadData];
    [self showHomeDirectoryTableViewIfDataSourceIsNotEmpty];
    [self.homeDirectorySearchTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}


#pragma mark - Overridden methods

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    [self.view.window makeFirstResponder:self.directorySearchTextField];
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    [self.directorySearchTextField setStringValue:@""];
    self.homeDirectoriesDataSource = nil;
    return YES;
}

- (void)cancelOperation:(id)sender
{
    [super cancelOperation:sender];
    [self.delegate directorySearchViewControllerDidCancelSearch:self];
}


#pragma mark - Private helper methods

- (void)showHomeDirectoryTableViewIfDataSourceIsNotEmpty
{
    if (self.homeDirectoriesDataSource == nil || [self.homeDirectoriesDataSource count] == 0) {
        [self.homeDirectorySearchTableView setAlphaValue:0.0];
    } else if ([self.homeDirectoriesDataSource count] > 0) {
        [self.homeDirectorySearchTableView setAlphaValue:1.0];
        [self setSelectedHomeDirectorySearchTableViewRow:kDefaultSelectedCellRow];
    }
}

- (void)selectCellAboveCurrentlySelectedCell
{
    NSInteger adjustedSelectedRowIndex = (--self.selectedHomeDirectorySearchTableViewRow) % [self.homeDirectoriesDataSource count];
    [self.homeDirectorySearchTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:adjustedSelectedRowIndex] byExtendingSelection:NO];
}

- (void)selectCellBelowCurrentlySelectedCell
{
    NSInteger adjustedSelectedRowIndex = (++self.selectedHomeDirectorySearchTableViewRow) % [self.homeDirectoriesDataSource count];
    [self.homeDirectorySearchTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:adjustedSelectedRowIndex] byExtendingSelection:NO];
}


#pragma mark - NSTableViewDelegate & NSTableViewDataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.homeDirectoriesDataSource count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([[tableColumn identifier] isEqualToString:kSWHomeDirectorySearchResultCellColumnIdentifier] == NO) {
        return nil;
    }
    
    SWDirectorySearchCellView *cellView = [tableView makeViewWithIdentifier:SWDirectorySearchCellView_Identifier
                                                                      owner:self];
    NSURL *urlToDirectory = self.homeDirectoriesDataSource[row];
    [cellView updateWithPathToDirectory:[urlToDirectory path]];
    return cellView;
}

#pragma mark - NSTextFieldDelegate methods

- (void)controlTextDidChange:(NSNotification *)obj
{
    NSString *searchQueryString = [[[obj.userInfo valueForKey:@"NSFieldEditor"] textStorage] string];
    [self.delegate directorySearchViewController:self didReceivedSearchQueryString:searchQueryString];
}


- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if ([control isEqualTo:self.directorySearchTextField] == NO) {
        return NO;
    }
    
    NSString *commandSelectorString = NSStringFromSelector(commandSelector);
    BOOL userPressedDownKey = [commandSelectorString isEqualToString:@"moveDown:"];
    BOOL userPressedUpKey = [commandSelectorString isEqualToString:@"moveUp:"];
    BOOL userPressedEnterKey = [commandSelectorString isEqualToString:@"insertNewline:"];
    BOOL userPressedESCKey = [commandSelectorString isEqualToString:@"cancelOperation:"];
    
    if (userPressedDownKey) {
        [self selectCellBelowCurrentlySelectedCell];
    } else if (userPressedUpKey) {
        [self selectCellAboveCurrentlySelectedCell];
    } else if (userPressedEnterKey) {
        if ([self.homeDirectorySearchTableView selectedRow] > -1) {
            [self.delegate directorySearchViewController:self didSelectRow:[self.homeDirectorySearchTableView selectedRow]];
        }
    } else if (userPressedESCKey) {
        [self.delegate directorySearchViewControllerDidCancelSearch:self];
    }
    
    return NO;
}

@end
