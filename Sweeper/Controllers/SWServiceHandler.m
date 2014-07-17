//
//  SWServiceHandler.m
//  Sweeper
//
//  Created by Jay Chae  on 7/17/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWServiceHandler.h"
#import "SWMainWindowController.h"
#import "SWRootWireframe.h"

@interface SWServiceHandler ()

@property (nonatomic, strong) SWRootWireframe *rootWireframe;
@property (nonatomic, strong) SWMainWindowController *rootWindowController;

@end

@implementation SWServiceHandler

- (void)sortWithSweeperServices:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error
{
    NSString *selectedDirectoryPath = [[pboard propertyListForType:NSFilenamesPboardType] lastObject];
    self.rootWireframe = [[SWRootWireframe alloc] initWithDirectoryPathToDirectory:selectedDirectoryPath];
    self.rootWindowController = [[SWMainWindowController alloc] initWithWindowNibName:@"SWMainWindowController"];
    [self.rootWindowController setRootWireframe:self.rootWireframe];
    [self.rootWireframe setMainWindowController:self.rootWindowController];
    [self.rootWindowController showWindow:self];
    NSLog(@"starting service from handler");
}

- (void)registerPasteboardService
{
    [NSApp setServicesProvider:self];
    NSUpdateDynamicServices();
}


@end
