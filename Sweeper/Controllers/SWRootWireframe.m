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

@interface SWRootWireframe () <SWFileStackHandlerDelegate,
                                SWHomeDirectoryHandlerDelegate,
                                SWStackViewControllerEventDelegte>

@property (nonatomic, strong) SWFileStackHandler *fileStackHandler;
@property (nonatomic, strong) SWHomeDirectoryHandler *homeDirectoryHandler;
@property (nonatomic, strong) NSArray *filesInHomeDirectory;

@property (nonatomic, strong) SWStackViewController *fileStackViewController;

@end

@implementation SWRootWireframe

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupFileStackHandler];
//        [self setupHomeDirectoryHandler];
        [self setupStackViewController];
    }
    return self;
}

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
}

- (void)setupStackViewController
{
    self.fileStackViewController = [[SWStackViewController alloc] initWithNibName:SWStackViewController_NIB_Name
                                                                           bundle:nil];
    [self.fileStackViewController setDelegate:self];
    [self.fileStackViewController setFileStackDataSource:self.fileStackHandler.unprocessedFileStack];
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

@end