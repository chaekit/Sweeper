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
#import "SWDirectorySearchCellView.h"
#import "NSURL+Sweeper.h"

static CGFloat const SEARCHBAR_ANIMATION_DURATION = 0.3;

static NSColor *colorForDeleteFileAnimation;
static NSColor *colorForMoveFileAnimation;
static NSColor *colorForSkipFileAnimation;

static NSRect frameOfVisibleFileTableView;
static NSRect frameOfHiddenFileTableView;

__attribute__((constructor))
static void initialize_fileTableView_animation_colors() {
    colorForSkipFileAnimation = [NSColor colorWithRed:0.839 green:0.839 blue:0.439 alpha:1.0];      // #d6d670
    colorForMoveFileAnimation = [NSColor colorWithRed:0.639 green:0.839 blue:0.439 alpha:1.0];      // #a3d670
    colorForDeleteFileAnimation = [NSColor colorWithRed:0.839 green:0.439 blue:0.439 alpha:1.0];    // #d67070
}


__attribute__((constructor))
static void initialize_fileTableView_frames() {
    frameOfHiddenFileTableView = NSMakeRect(0, -67, 616, 464);
    frameOfVisibleFileTableView = NSMakeRect(0, -3, 616, 464);
}


@interface SWFileStackViewController ()

@property (nonatomic, strong) NSArray *directorySearchResult;
@property (nonatomic) BOOL initialized;
@property (nonatomic, assign) NSUInteger selectedRowIndex;
@property (nonatomic, retain) NSMutableArray *directoriesInUserHomeDirectory;

- (NSString *)systemUserName;
@end


@implementation SWFileStackViewController

@synthesize fileTableView;
@synthesize fileStackHandler;
@synthesize directoriesInUserHomeDirectory;
@synthesize directorySearchTableView;
@synthesize directorySearchBar;
@synthesize directorySearchResult;
@synthesize directorySearchTableViewContainer;
@synthesize fileTableViewContainer;
@synthesize selectedRowIndex;


- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self _initDirectoriesInUserHomeDirectory];
        [NSApp setServicesProvider:self];
        NSUpdateDynamicServices();
        [fileTableView setAllowsTypeSelect:NO];
        self.initialized = NO;
        NSLog(@"initialized with frame");
    }
    return self;
}

- (void)awakeFromNib {
    if (!self.initialized) {
        [self _initDirectoriesInUserHomeDirectory];
        [directorySearchBar setFocusRingType:NSFocusRingTypeNone];
        [directorySearchBar setEnabled:NO];
#ifdef RELEASE
        [NSApp setServicesProvider:self];
        NSUpdateDynamicServices();
        NSLog(@"release build");
#endif
        self.initialized = YES;
        NSLog(@"awaken from nib");
#ifdef DEBUG
        [self fuckServices:nil userData:nil error:nil];
#endif
        [self.window makeFirstResponder:fileTableView];
    }
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
    if ([[[self window] firstResponder] isEqualTo:directorySearchTableView]) {
        return;
    }
    /*
     Actions for responding to file action events
     */
    NSString *keyCharacter = [theEvent characters];
    if ([keyCharacter isEqualToString:@"m"]) {
        /* 
         move file. show directorySearchBar first for query.
         */
        [self showSearchBar];
    } else if ([keyCharacter isEqualToString:@"x"]) {
        /*
         remove file
         */
        [self deleteFile];
    } else if ([keyCharacter isEqualToString:@"l"]) {
        /*
         defer file
         */
        [self skipFile];
    } else if ([keyCharacter isEqualToString:@"z"]) {
        /*
         undo file
         */
        [self undoFileAction];
    }
    
    /*
     Action for responding to selecting destination file path event (usually RETURN key)
     */
    if ([keyCharacter isEqualToString:@"\r"]) {
        if ([directorySearchTableView selectedRow] > -1) {
            NSURL *url = [directorySearchResult objectAtIndex:[directorySearchTableView selectedRow]];
            [self moveFileTo:[url path]];
        }
    }
}


#pragma mark -
#pragma file actions

- (void)fuckServices:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error {
    NSString *fileURL = [[pboard propertyListForType:NSFilenamesPboardType] lastObject];
#ifdef DEBUG
    fileURL = [NSString stringWithFormat:@"%@/Desktop", NSHomeDirectory()];
#endif
    [self initDataStorageWithPath:fileURL];
    [fileTableView reloadData];
}

- (void)moveFileTo:(NSString *)destinationPath {
    [fileStackHandler moveHeadFileToDirectoryAtPath:destinationPath];
    NSTableRowView *cellAtTop = [fileTableView rowViewAtRow:0 makeIfNecessary:NO];
    [cellAtTop setBackgroundColor:colorForMoveFileAnimation];
    [fileTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:(NSTableViewAnimationEffectFade | NSTableViewAnimationSlideUp)];
    [self hideSearchBar];
}

- (void)deleteFile {
    [fileStackHandler removeHeadFile];
    NSTableRowView *cellAtTop = [fileTableView rowViewAtRow:0 makeIfNecessary:NO];
    [cellAtTop setBackgroundColor:colorForDeleteFileAnimation];
    [fileTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:(NSTableViewAnimationEffectFade | NSTableViewAnimationSlideUp)];
}

- (void)skipFile {
    [fileStackHandler deferHeadFile];
    NSTableRowView *cellAtTop = [fileTableView rowViewAtRow:0 makeIfNecessary:YES];
    [cellAtTop setBackgroundColor:colorForSkipFileAnimation];
    [fileTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:(NSTableViewAnimationEffectFade | NSTableViewAnimationSlideUp)];
}

- (void)undoFileAction {
    NSError *error;
    [fileStackHandler undoPreviousAction:&error];
    
    if (error)  return;
    
    [fileTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NSTableViewAnimationSlideDown];
}

- (void)cancelOperation:(id)sender {
    [self hideSearchBar];
}

#pragma mark -
#pragma initializations


- (void)initDataStorageWithPath:(NSString *)path {
#ifdef RELEASE
    fileStackHandler = [SWFileStackHandler stackHandlerForURL:path];
#else
    NSString *pathToDesktop = [NSString stringWithFormat:@"%@/Desktop", NSHomeDirectory()];
    fileStackHandler = [SWFileStackHandler stackHandlerForURL:pathToDesktop];
#endif
}


/*
 Initialize the app using Services
 */

- (void)_initDirectoriesInUserHomeDirectory {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *userURL = [NSURL URLWithString:NSHomeDirectory()];
    NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtURL:userURL
                                                   includingPropertiesForKeys:@[NSURLIsDirectoryKey, NSURLNameKey]
                                                                      options:(NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants)
                                                                 errorHandler:^BOOL(NSURL *url, NSError *error) {
                                                                     NSLog(@"Error occured while traversing URL : %@", [url absoluteString]);
                                                                     NSLog(@"Error : %@", [error localizedDescription]);
                                                                     return NO;
                                                                 }];
   
    self.directoriesInUserHomeDirectory = [[NSMutableArray alloc] init];
    for (NSURL *url in directoryEnumerator) {
        NSNumber *isDirectory;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        if ([isDirectory boolValue]) {
            [self.directoriesInUserHomeDirectory addObject:url];
        }
    }
    NSLog(@"%@", self);
}

- (NSString *)systemUserName {
    NSURL *documentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSAllDomainsMask] lastObject];
    NSArray *components = [documentDirectory pathComponents];
    NSInteger componentSize = [components count];
    NSString *userName = components[componentSize - 2];
    return userName;
}

#pragma mark -
#pragma UI actions


- (void)showSearchBar {
    [self setSelectedRowIndex:0];
    [directorySearchBar setEnabled:YES];
    [[self window] makeFirstResponder:directorySearchBar];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setDuration:SEARCHBAR_ANIMATION_DURATION];
        [[fileTableViewContainer animator] setFrame:NSMakeRect(0, -67, 616, 464)];
        [[fileTableViewContainer animator] setAlphaValue:0.0];
    } completionHandler:nil];
}


- (void)hideSearchBar {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setDuration:SEARCHBAR_ANIMATION_DURATION];
        [[fileTableViewContainer animator] setFrame:NSMakeRect(0, -3, 616, 464)];
        [fileTableViewContainer setAlphaValue:1.0];
        [directorySearchTableViewContainer setAlphaValue:0.0];
    } completionHandler:^{
        [directorySearchBar setStringValue:@""];
        [directorySearchBar resignFirstResponder];
        [directorySearchBar setEnabled:NO];
        [self.window makeFirstResponder:fileTableView];
    }];
}


#pragma mark -
#pragma NSTableViewDelegate & NSTableViewDataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if ([tableView isEqual:fileTableView]) {
        return [fileStackHandler.unprocessedFileStack stackCount];
    } else if ([tableView isEqual:directorySearchTableView]) {
        return [directorySearchResult count];
    }
    return 1;
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([tableView isEqual:fileTableView]) {
        NSString *identifier = [tableColumn identifier];
        if ([identifier isEqualToString:@"fileColumn"]) {
            NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"SWFileStackViewCell" owner:self];
            SWUnProcessedFile *unprocessedFile = [fileStackHandler.unprocessedFileStack fileAtIndex:row];
            [cellView.textField setStringValue:[unprocessedFile fileName]];
            [cellView.imageView setImage:[unprocessedFile fileIcon]];
            return cellView;
        }
        return nil;
    } else if ([tableView isEqual:directorySearchTableView]) {
        NSString *identifier = [tableColumn identifier];
        if ([identifier isEqualToString:@"searchColumn"]) {
            NSWorkspace *workspace = [[NSWorkspace alloc] init];
            SWDirectorySearchCellView *cellView = [tableView makeViewWithIdentifier:@"SWDirectorySearchCellView" owner:self];
            
            NSURL *directoryURL = directorySearchResult[row];
            NSString *fullPath = [directoryURL path];
            NSString *directoryName = [fullPath lastPathComponent];
            NSImage *iconImage = [workspace iconForFile:fullPath];
            [iconImage setSize:NSMakeSize(64.0, 64.0)];
           
            [cellView.fullPathTextField setStringValue:fullPath];
            [cellView.nameTextField setStringValue:directoryName];
            [cellView.iconImageView setImage:iconImage];
            return cellView;
        }
    }
    return nil;
}

#pragma mark -
#pragma NSTextFieldDelegate methods

- (void)controlTextDidChange:(NSNotification *)obj {
    NSString *searchQueryString = [[[obj.userInfo valueForKey:@"NSFieldEditor"] textStorage] string];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.lastPathComponent BEGINSWITH[c] %@", searchQueryString];
   
    NSLog(@"query string  %@", searchQueryString);
    directorySearchResult = [directoriesInUserHomeDirectory filteredArrayUsingPredicate:predicate];
    if ([directorySearchResult count] > 10) {
        NSRange range;
        range.location = 0;
        range.length = 10;
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"depthOfURLByPathComponents" ascending:YES];
        directorySearchResult = [directorySearchResult sortedArrayUsingDescriptors:@[sortDescriptor]];
        directorySearchResult = [directorySearchResult subarrayWithRange:range];
    }
    
    if ([directorySearchResult count] > 0) {
        [directorySearchTableViewContainer setAlphaValue:1.0];
    } else {
        [directorySearchTableViewContainer setAlphaValue:0.0];
    }
    [directorySearchTableView reloadData];
    [self setSelectedRowIndex:0];
    [directorySearchTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRowIndex] byExtendingSelection:NO];
}


- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if (![control isEqualTo:directorySearchBar]) {
        return NO;
    }
    
    NSLog(@"%@", NSStringFromSelector(commandSelector));
    if ([NSStringFromSelector(commandSelector) isEqualToString:@"moveDown:"]) {
        NSInteger adjustedSelectedRowIndex = (++selectedRowIndex) % [directorySearchResult count];
        [directorySearchTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:adjustedSelectedRowIndex] byExtendingSelection:NO];
    }
   
    if ([NSStringFromSelector(commandSelector) isEqualToString:@"moveUp:"]) {
        NSInteger adjustedSelectedRowIndex = (--selectedRowIndex) % [directorySearchResult count];
        [directorySearchTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:adjustedSelectedRowIndex] byExtendingSelection:NO];
    }
   
    if ([NSStringFromSelector(commandSelector) isEqualToString:@"insertNewline:"]) {
        if ([directorySearchTableView selectedRow] > -1) {
            NSURL *url = [directorySearchResult objectAtIndex:[directorySearchTableView selectedRow]];
            [self moveFileTo:[url path]];
        }
    }
    
    return NO;
}

@end
