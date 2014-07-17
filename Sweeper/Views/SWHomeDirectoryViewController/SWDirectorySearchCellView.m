//
//  SWDirectorySearchCellView.m
//  Sweeper
//
//  Created by Jay Chae  on 1/7/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWDirectorySearchCellView.h"

NSString * const SWDirectorySearchCellView_Identifier = @"SWDirectorySearchCellView";

static CGFloat kSWDirectorySearchCellViewDefaultIconHeight      = 64.0;
static CGFloat kSWDirectorySearchCellViewDefaultIconWidth       = 64.0;

@interface SWDirectorySearchCellView ()

@property (nonatomic, weak) IBOutlet NSTextField *fullPathTextField;
@property (nonatomic, weak) IBOutlet NSTextField *nameTextField;
@property (nonatomic, weak) IBOutlet NSImageView *iconImageView;

@end

@implementation SWDirectorySearchCellView

- (void)updateWithPathToDirectory:(NSString *)pathToDirectory
{
    [self.fullPathTextField setStringValue:pathToDirectory];
    [self.nameTextField setStringValue:[self directoryNameFromPath:pathToDirectory]];
    [self.iconImageView setImage:[self directoryIconFromPath:pathToDirectory]];
    
}


#pragma mark - Private helper methods

- (NSString *)directoryNameFromPath:(NSString *)pathToDirectory
{
    return [pathToDirectory lastPathComponent];
}

- (NSImage *)directoryIconFromPath:(NSString *)pathToDirectory
{
    NSWorkspace *workspace = [[NSWorkspace alloc] init];
    NSImage *iconImage = [workspace iconForFile:pathToDirectory];
    [iconImage setSize:NSMakeSize(kSWDirectorySearchCellViewDefaultIconWidth,
                                  kSWDirectorySearchCellViewDefaultIconHeight)];
    return iconImage;
}

@end
