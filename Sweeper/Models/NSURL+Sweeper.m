//
//  NSURL+Sweeper.m
//  Sweeper
//
//  Created by Jay Chae  on 4/19/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "NSURL+Sweeper.h"

@implementation NSURL (Sweeper)

- (NSUInteger)depthOfURLByPathComponents {
    return [[self pathComponents] count];
}

@end
