//
//  SWProcessedFile.h
//  Sweeper
//
//  Created by Jay Chae  on 1/3/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWUnProcessedFile;

@interface SWProcessedFile : NSObject

@property (nonatomic, strong) NSString *processedAction;
@property (nonatomic, strong) NSString *pathProcessedFrom;
@property (nonatomic, strong) NSString *currentPath;

+ (instancetype)processedFileFromUnprocessedFile:(SWUnProcessedFile *)anUnprocessedFile
                                          Action:(NSString *)action;

@end
