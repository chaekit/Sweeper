//
//  SWHomeDirectoryHandler.h
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWHomeDirectoryHandler;

@protocol SWHomeDirectoryHandlerDelegate <NSObject>

/**
 Called when a home directory handler finishes mapping directory
 @param directoryPath path to directory that was mapped
 @param fileNames NSString of all file names that were found while mapping the directory.
                    these are not limited to immediate children of the directory
 */
- (void)homeDirectoryHandler:(SWHomeDirectoryHandler *)directoryHandler
didFinishMappingHomeDiretoryWithFileNames:(NSArray *)fileNames;

/**
 Called when a home directory handler finishes searching filenames
 @param fileNames search result of all the file names found
 @param queryPrefix prefix of the fileNames. This is the string value that 
                    was passed in as a query for search
 */
- (void)homeDirectoryHandler:(SWHomeDirectoryHandler *)directoryHandler
                didFindFiles:(NSArray *)fileNames
             withQueryPrefix:(NSString *)queryPrefix;

@end


@interface SWHomeDirectoryHandler : NSObject

@property (nonatomic, weak) id<SWHomeDirectoryHandlerDelegate> delegate;

@property (nonatomic, copy, readonly) NSArray *filesInHomeDirectory;

@end
