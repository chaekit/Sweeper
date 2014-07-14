//
//  SWHomeDirectoryHandler.m
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWHomeDirectoryHandler.h"

@interface SWHomeDirectoryHandler ()

@property (nonatomic, readwrite) NSArray *filesInHomeDirectory;

@end

@implementation SWHomeDirectoryHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupDirectoriesInUserHomeDirectory];
    }
    return self;
}


#pragma mark - Private initialization helper methods

- (void)setupDirectoriesInUserHomeDirectory
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *userURL = [NSURL URLWithString:NSHomeDirectory()];
    NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtURL:userURL
                                                   includingPropertiesForKeys:@[NSURLIsDirectoryKey, NSURLNameKey]
                                                                      options:(NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants)
                                                                 errorHandler:^BOOL(NSURL *url, NSError *error) {
                                                                     NSLog(@"Error occured while traversing URL : %@", [url absoluteString]);
                                                                     NSLog(@"Error : %@", [error localizedDescription]);
                                                                     return NO;
                                                                 }];
   
    NSArray *directoriesInUserHomeDirectory = [self filterOutDirectoriesInDirectoryEnumerator:directoryEnumerator];
    [self.delegate homeDirectoryHandler:self didFinishMappingHomeDiretoryWithFileNames:directoriesInUserHomeDirectory];
}


#pragma mark - Helper methods for mapping files in home directory

- (NSArray *)filterOutDirectoriesInDirectoryEnumerator:(NSDirectoryEnumerator *)directoryEnumerator
{
    NSMutableArray *directoriesInUserHomeDirectory = [[NSMutableArray alloc] init];
    for (NSURL *url in directoryEnumerator) {
        NSNumber *isDirectory;
        NSError *error;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            continue;
        }
        
        if ([isDirectory boolValue]) {
            [directoriesInUserHomeDirectory addObject:url];
        }
      
    }
    
    return directoriesInUserHomeDirectory;
}

- (NSArray *)fileNamesWithPrefix:(NSString *)aPrefix
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.lastPathComponent BEGINSWITH[c] %@", aPrefix];
    NSArray *directorySearchResult = [self.filesInHomeDirectory filteredArrayUsingPredicate:predicate];
    
    if ([directorySearchResult count] > 10) {
        NSRange range;
        range.location = 0;
        range.length = 10;
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"depthOfURLByPathComponents" ascending:YES];
        directorySearchResult = [directorySearchResult sortedArrayUsingDescriptors:@[sortDescriptor]];
        directorySearchResult = [directorySearchResult subarrayWithRange:range];
    }
    
    [self.delegate homeDirectoryHandler:self didFindFiles:directorySearchResult withQueryPrefix:aPrefix];
    return directorySearchResult;
}
@end
