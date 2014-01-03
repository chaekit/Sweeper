//
//  SWFileStack.h
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWFileStack : NSObject

- (instancetype)popHead;
- (instancetype)headObject;
- (void)pushObject:(id)anObject;
- (NSInteger)stackCount;
- (id)fileAtIndex:(NSInteger)index;

@end
