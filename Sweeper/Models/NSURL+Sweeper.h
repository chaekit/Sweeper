//
//  NSURL+Sweeper.h
//  Sweeper
//
//  Created by Jay Chae  on 4/19/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Sweeper)

/*
 Returns the depth by counting the number of slashes "/" in a URL component.
 More slashes = deeper
 */
- (NSUInteger)depthOfURLByPathComponents;

@end
