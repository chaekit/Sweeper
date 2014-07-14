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

static NSString * const kSWKeyEventCharacterMoveFile        = @"m";
static NSString * const kSWKeyEventCharacterDeleteFile      = @"x";
static NSString * const kSWKeyEventCharacterLeaveFile       = @"l";
static NSString * const kSWKeyEventCharacterUndoAction      = @"z";
static NSString * const kSWKeyEventCharacterShowHelpScreen  = @"h";

static NSTableViewAnimationOptions const kSWStackViewControllerDefaultCellPopAnimationOptions = (NSTableViewAnimationEffectFade | NSTableViewAnimationSlideUp) ;
static NSTableViewAnimationOptions const kSWStackViewControllerDefaultCellPushAnimationOptions = (NSTableViewAnimationEffectFade | NSTableViewAnimationSlideDown) ;

static NSColor *kSWStackViewConrollerColorForDeleteFileAnimation;
static NSColor *kSWStackViewConrollerColorForMoveFileAnimation;
static NSColor *kSWStackViewConrollerColorForLeaveFileAnimation;

__attribute__((constructor))
static void initialize_animation_colors() {
    kSWStackViewConrollerColorForLeaveFileAnimation = [NSColor colorWithRed:0.839 green:0.839 blue:0.439 alpha:1.0];      // #d6d670
    kSWStackViewConrollerColorForMoveFileAnimation = [NSColor colorWithRed:0.639 green:0.839 blue:0.439 alpha:1.0];      // #a3d670
    kSWStackViewConrollerColorForDeleteFileAnimation = [NSColor colorWithRed:0.839 green:0.439 blue:0.439 alpha:1.0];    // #d67070
}


@class SWUnProcessedFile;

@interface SWStackViewController () <SWStackTableViewEventDelegate,
                                        NSTableViewDataSource,
                                        NSTableViewDelegate>

@property (nonatomic, weak) IBOutlet SWStackTableView *fileStackTableView;

@end

@implementation SWStackViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupDefaultProperties];
    [self.fileStackTableView setKeyEventDelegate:self];
}

- (void)setupDefaultProperties
{
    [self.view setWantsLayer:YES];
}

- (void)popStackCellViewForAction:(SWFileAction)fileAction
{
    NSTableRowView *cellAtTop = [self.fileStackTableView rowViewAtRow:0 makeIfNecessary:YES];
    NSColor *colorForAnimation;
    switch (fileAction) {
        case SWFileActionDeferFile:
            colorForAnimation = kSWStackViewConrollerColorForLeaveFileAnimation;
            break;
        case SWFileActionDeleteFile:
            colorForAnimation = kSWStackViewConrollerColorForDeleteFileAnimation;
            break;
        case SWFileActionMoveFile:
            colorForAnimation = kSWStackViewConrollerColorForMoveFileAnimation;
            break;
        default:
            break;
    }
    [cellAtTop setBackgroundColor:colorForAnimation];
    [self.fileStackTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:0]
                                   withAnimation:kSWStackViewControllerDefaultCellPopAnimationOptions];
}

- (void)pushStackCellViewForAction:(SWFileAction)fileAction
{
    [self.fileStackTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0]
                                   withAnimation:kSWStackViewControllerDefaultCellPushAnimationOptions];
}

- (void)hideStackView
{
    [self resignFirstResponder];
    [self.view setAlphaValue:0.0];
}


#pragma mark - SWStackTableViewEventDelegate methods

- (void)stackTableView:(SWStackTableView *)stackTableView didReceiveKeyEvent:(NSEvent *)keyEvent
{
    NSString *keyCharacter = [keyEvent characters];
    
    if ([keyCharacter isEqualToString:kSWKeyEventCharacterMoveFile]) {
        [self.delegate stackViewConrollerDidReceiveMoveFileAction:self];
    } else if ([keyCharacter isEqualToString:kSWKeyEventCharacterDeleteFile]) {
        [self.delegate stackViewConrollerDidReceiveRemoveFileAction:self];
    } else if ([keyCharacter isEqualToString:kSWKeyEventCharacterLeaveFile]) {
        [self.delegate stackViewConrollerDidReceiveLeaveFileAction:self];
    } else if ([keyCharacter isEqualToString:kSWKeyEventCharacterUndoAction]) {
        [self.delegate stackViewConrollerDidReceiveUndoFileAction:self];
    } else if ([keyCharacter isEqualToString:kSWKeyEventCharacterShowHelpScreen]) {
    }
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
