//
//  SWFileStackHandler.h
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWUnProcessedFile;
@class SWFileStack;

@interface SWFileStackHandler : NSObject

+ (instancetype)stackHandlerForURL:(NSString *)anURLString;

@property (nonatomic, strong) SWFileStack *unprocessedFileStack;
@property (nonatomic, strong) SWFileStack *processedFileStack;

@end
