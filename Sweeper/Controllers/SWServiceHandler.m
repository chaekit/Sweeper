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
    NSString *fileURL = [[pboard propertyListForType:NSFilenamesPboardType] lastObject];
#ifdef DEBUG
    fileURL = [NSString stringWithFormat:@"%@/Desktop", NSHomeDirectory()];
#endif
    self.rootWindowController = [[SWMainWindowController alloc] initWithWindowNibName:@"SWMainWindowController"];
    [self.rootWindowController showWindow:self];
}

- (void)registerPasteboardService
{
    [NSApp setServicesProvider:self];
    NSUpdateDynamicServices();
}


@end
