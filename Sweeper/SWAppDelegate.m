//
//  SWAppDelegate.m
//  Sweeper
//
//  Created by Jay Chae  on 1/2/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWAppDelegate.h"
#import "SWFileStackViewController.h"

@implementation SWAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%d", [defaults boolForKey:@"helped"]);
    if (![defaults boolForKey:@"helped"]){
        NSLog(@"Helped Not Set");
    }else{
        NSLog(@"Helped Set");
    }
}

@end
