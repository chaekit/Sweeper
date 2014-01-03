//
//  SWFileStack.m
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWFileStack.h"

@interface SWFileStack ()

@property (nonatomic, retain) NSMutableArray *theStack;

@end

@implementation SWFileStack

@synthesize theStack;

- (id)init {
    self = [super init];
    if (self) {
        theStack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)popHead {
    id headObject = [theStack lastObject];
    [theStack removeLastObject];
    return headObject;
}

- (instancetype)headObject {
    return [theStack lastObject];
}
- (void)pushObject:(id)anObject {
    [theStack addObject:anObject];
}

- (NSInteger)stackCount {
    return [theStack count];
}

- (id)fileAtIndex:(NSInteger)index {
    NSInteger jIndex = [theStack count] -  index - 1;
    return [theStack objectAtIndex:jIndex];
}

@end
