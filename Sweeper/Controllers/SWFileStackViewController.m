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
#import "SWAppDelegate.h"

@interface SWFileStackViewController ()

@end

@implementation SWFileStackViewController

@synthesize fileTableView;
@synthesize fileStackHandler;
@synthesize directoriesInUserHomeDirectory;

- (id)init {
    self = [super init];
    if (self) {
        [self _initDataStorage];
        [self _initDirectoriesInUserHomeDirectory];
        [fileTableView setAllowsTypeSelect:NO];
    }
    return self;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
    NSString *keyCharacter = [theEvent characters];
    if ([keyCharacter isEqualToString:@"m"]) {
        NSLog(@"move file");
    } else if ([keyCharacter isEqualToString:@"x"]) {
        NSLog(@"delete file");
    } else if ([keyCharacter isEqualToString:@"l"]) {
        NSLog(@"defer file");
    } else if ([keyCharacter isEqualToString:@"z"]) {
        NSLog(@"undo action");
    }
}

- (void)_initDataStorage {
    fileStackHandler = [SWFileStackHandler stackHandlerForURL:@"/Users/jaychae/Documents"]; // Harcoded URL for dev
}

- (void)_initDirectoriesInUserHomeDirectory {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *userURL = [NSURL URLWithString:@"/Users/jaychae"];
    NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtURL:userURL
                                                   includingPropertiesForKeys:@[NSURLIsDirectoryKey, NSURLNameKey]
                                                                      options:(NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants)
                                                                 errorHandler:^BOOL(NSURL *url, NSError *error) {
                                                                     NSLog(@"Error occured while traversing URL : %@", [url absoluteString]);
                                                                     NSLog(@"Error : %@", [error localizedDescription]);
                                                                     return NO;
                                                                 }];
   
//    int i = 0;
    for (NSURL *url in directoryEnumerator) {
        NSNumber *isDirectory;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        if ([isDirectory boolValue]) {
//            NSLog(@"url   %@", [url path]);
//            NSLog(@"last path component   %@", [url lastPathComponent]);
            [directoriesInUserHomeDirectory addObject:[url lastPathComponent]];
//            if (i++ == 10) break;
        }
    }
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

#pragma mark -
#pragma NSTextFieldDelegate methods

- (void)controlTextDidChange:(NSNotification *)obj {
    NSString *searchQueryString = [[[obj.userInfo valueForKey:@"NSFieldEditor"] textStorage] string];
    NSLog(@"%@", searchQueryString);
}

@end
