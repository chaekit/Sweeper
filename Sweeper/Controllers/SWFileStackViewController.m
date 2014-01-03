//
//  SWFileStackViewController.m
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWFileStackViewController.h"
#import "SWFileStackHandler.h"
#import "SWFileStack.h"
#import "SWUnProcessedFile.h"

@interface SWFileStackViewController ()

@end

@implementation SWFileStackViewController

@synthesize fileTableView;
@synthesize fileStackHandler;

- (id)init {
    self = [super init];
    if (self) {
        [self _initDataStorage];
    }
    return self;
}

- (void)_initDataStorage {
    fileStackHandler = [SWFileStackHandler stackHandlerForURL:@"/Users/jaychae/Documents"]; // Harcoded URL for dev
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [fileStackHandler.unprocessedFileStack stackCount];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = [tableColumn identifier];
    if ([identifier isEqualToString:@"fileColumn"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"SWFileStackViewCell" owner:self];
        SWUnProcessedFile *unprocessedFile = [fileStackHandler.unprocessedFileStack fileAtIndex:row];
        [cellView.textField setStringValue:[unprocessedFile fileName]];
        [cellView.imageView setImage:[unprocessedFile fileIcon]];
        return cellView;
    }
    return nil;
}

@end
