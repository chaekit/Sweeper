//
//  SWRootWireframe.m
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWRootWireframe.h"
#import "SWFileStackHandler.h"
#import "SWHomeDirectoryHandler.h"
#import "SWHomeDirectoryViewController.h"
#import "SWStackViewController.h"
#import "SWMainWindowController.h"

@interface SWRootWireframe () <SWFileStackHandlerDelegate,
                                SWHomeDirectoryHandlerDelegate,
                                SWStackViewControllerEventDelegate,
                                SWHomeDirectorySearchTableViewControllerDelegate>

@property (nonatomic, strong) SWFileStackHandler *fileStackHandler;
@property (nonatomic, strong) SWHomeDirectoryHandler *homeDirectoryHandler;
@property (nonatomic, strong) NSArray *filesInHomeDirectory;

@property (nonatomic, strong) SWStackViewController *fileStackViewController;
@property (nonatomic, strong) SWHomeDirectoryViewController *homeDirectoryViewController;

@end

@implementation SWRootWireframe

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupFileStackHandler];
        [self setupHomeDirectoryHandler];
        [self setupHomeDirectoryViewController];
        [self setupStackViewController];
    }
    return self;
}


#pragma mark - Private initializer methods

- (void)setupFileStackHandler
{
    // TODO : get rid of hardcoded path
    NSString *pathToDesktop = [NSString stringWithFormat:@"%@/Desktop", NSHomeDirectory()];
    self.fileStackHandler = [[SWFileStackHandler alloc] initWithPathToDirectory:pathToDesktop];
    [self.fileStackHandler setDelegate:self];
}

- (void)setupHomeDirectoryHandler
{
    self.homeDirectoryHandler = [[SWHomeDirectoryHandler alloc] init];
    [self.homeDirectoryHandler setDelegate:self];
}

- (void)setupStackViewController
{
    self.fileStackViewController = [[SWStackViewController alloc] initWithNibName:SWStackViewController_NIB_Name
                                                                           bundle:nil];
    [self.fileStackViewController setDelegate:self];
    [self.fileStackViewController setFileStackDataSource:self.fileStackHandler.unprocessedFileStack];
}

- (void)setupHomeDirectoryViewController
{
    self.homeDirectoryViewController = [[SWHomeDirectoryViewController alloc] initWithNibName:SWHomDirectoryViewController_NIB_Name
                                                                                       bundle:nil];
    [self.homeDirectoryViewController setDelegate:self];
}

#pragma mark - SWFileStackHandlerDelegate methods

- (void)stackHandler:(SWFileStackHandler *)stackHandler failedToUndoProcessedFile:(SWProcessedFile *)processedFile error:(NSError *)error
{
    
}

#pragma mark - SWHomeDirectoryHandlerDelegate methods

- (void)homeDirectoryHandler:(SWHomeDirectoryHandler *)directoryHandler
didFinishMappingHomeDiretoryWithFileNames:(NSArray *)fileNames
{
    self.filesInHomeDirectory = fileNames;
}

- (void)homeDirectoryHandler:(SWHomeDirectoryHandler *)directoryHandler
                didFindFiles:(NSArray *)fileNames
             withQueryPrefix:(NSString *)queryPrefix
{
    [self.homeDirectoryViewController updateHomeDirectoriesDataSource:fileNames];
}


#pragma mark - SWFileStackViewControllerDelegate methods

- (void)stackViewConrollerDidReceiveUndoFileAction:(SWStackViewController *)stackViewController
{
    [self.fileStackHandler undoPreviousAction:nil];
    [self.fileStackViewController pushStackCellViewForAction:SWFileActionUndoFile];
}

- (void)stackViewConrollerDidReceiveRemoveFileAction:(SWStackViewController *)stackViewController
{
    [self.fileStackHandler removeHeadFile];
    [self.fileStackViewController popStackCellViewForAction:SWFileActionDeleteFile];
}

- (void)stackViewConrollerDidReceiveLeaveFileAction:(SWStackViewController *)stackViewController
{
    [self.fileStackHandler deferHeadFile];
    [self.fileStackViewController popStackCellViewForAction:SWFileActionDeferFile];
}

- (void)stackViewConrollerDidReceiveMoveFileAction:(SWStackViewController *)stackViewController
{
    [self.mainWindowController switchToDirectorySearchView];
}

#pragma mark - SWHomeDirectorySearchTableViewControllerDelegate methods

- (void)directorySearchViewController:(SWHomeDirectoryViewController *)directorySearchViewController
         didReceivedSearchQueryString:(NSString *)queryString
{
    [self.homeDirectoryHandler fileNamesWithPrefix:queryString];
}

- (void)directorySearchViewController:(SWHomeDirectoryViewController *)directorySearchViewController
                         didSelectRow:(NSUInteger)rowIndex
{
    [self.mainWindowController switchToFileStackView];
    NSString *selectedDestinationPath = [self.homeDirectoryHandler.recentSearchResult[rowIndex] path];
    [self.fileStackHandler moveHeadFileToDirectoryAtPath:selectedDestinationPath];
    [self.fileStackViewController popStackCellViewForAction:SWFileActionMoveFile];
}

- (void)directorySearchViewControllerDidCancelSearch:(SWHomeDirectoryViewController *)directorySearchViewController
{
    [self.mainWindowController switchToFileStackView];
}

@end
