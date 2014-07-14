//
//  SWFileStackCellView.m
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWFileStackCellView.h"
#import "SWUnProcessedFile.h"

NSString * const SWFileStackCellView_Identifier = @"SWFileStackCellView_Identifier";

@interface SWFileStackCellView ()

@property (nonatomic, weak) IBOutlet NSImageView *unprocessedFileIconImageView;
@property (nonatomic, weak) IBOutlet NSTextField *unprocessedFileNameTextField;

@end

@implementation SWFileStackCellView

- (void)updateWithUnprocessedFile:(SWUnProcessedFile *)unprocessedFile
{
    [self.textField setStringValue:[unprocessedFile fileName]];
    [self.imageView setImage:[unprocessedFile fileIcon]];
}

@end
