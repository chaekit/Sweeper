//
//  SWAppDelegate.m
//  Sweeper
//
//  Created by Jay Chae  on 1/2/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWAppDelegate.h"
#import "SWMainWindowController.h"

@interface SWAppDelegate ()

@property (nonatomic, strong) SWMainWindowController *mainWindowController;

@end

@implementation SWAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.mainWindowController = [[SWMainWindowController alloc] initWithWindowNibName:@"SWMainWindowController"];
    [self.mainWindowController showWindow:self];
    [self.window setReleasedWhenClosed:NO];
    [self.window close];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%d", [defaults boolForKey:@"helped"]);
    if (![defaults boolForKey:@"helped"]){
        NSLog(@"Helped Not Set");
    }else{
        NSLog(@"Helped Set");
    }
}

@end
