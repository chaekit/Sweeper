//
//  SWAppDelegate.m
//  Sweeper
//
//  Created by Jay Chae  on 1/2/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWAppDelegate.h"
#import "SWMainWindowController.h"
#import "SWRootWireframe.h"
#import "SWServiceHandler.h"

@interface SWAppDelegate ()

@property (nonatomic, strong) SWRootWireframe *rootWireframe;
@property (nonatomic, strong) SWServiceHandler *serviceHandler;

@end

@implementation SWAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
#ifdef DEBUG
    NSString *developmentPath = [NSString stringWithFormat:@"%@/Desktop", NSHomeDirectory()];
    self.rootWireframe = [[SWRootWireframe alloc] initWithDirectoryPathToDirectory:developmentPath];
    [self.rootWireframe beginFlow];
#else
    self.serviceHandler = [[SWServiceHandler alloc] init];
    [NSApp setServicesProvider:self.serviceHandler];
    NSUpdateDynamicServices();
#endif
    [self.window setReleasedWhenClosed:NO];
    [self.window close];
}

@end
