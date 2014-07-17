//
//  SWHomeDirectoryHandler.m
//  Sweeper
//
//  Created by Jay Chae  on 7/13/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWHomeDirectoryHandler.h"

static NSUInteger const kDirectorySearchResultFilterLimitCount = 10;

@interface SWHomeDirectoryHandler ()

@property (nonatomic, readwrite) NSArray *filesInHomeDirectory;
@property (nonatomic, readwrite) NSArray *recentSearchResult;

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

- (NSArray *)fileNamesWithPrefix:(NSString *)aPrefix
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.lastPathComponent BEGINSWITH[c] %@", aPrefix];
    NSArray *directorySearchResult = [self.filesInHomeDirectory filteredArrayUsingPredicate:predicate];
    
    directorySearchResult = [self firstTenResultsOfSearchResult:[self sortResultsByURLDepth:directorySearchResult]];
    
    [self.delegate homeDirectoryHandler:self didFindFiles:directorySearchResult withQueryPrefix:aPrefix];
    self.recentSearchResult = directorySearchResult;
    return directorySearchResult;
}


#pragma mark - Private initialization helper methods

- (void)setupDirectoriesInUserHomeDirectory
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
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
        self.filesInHomeDirectory = directoriesInUserHomeDirectory;
        [self.delegate homeDirectoryHandler:self didFinishMappingHomeDiretoryWithFileNames:directoriesInUserHomeDirectory];
    });
}

- (NSArray *)sortResultsByURLDepth:(NSArray *)directorySearchResult
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"depthOfURLByPathComponents" ascending:YES];
    return [directorySearchResult sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSArray *)firstTenResultsOfSearchResult:(NSArray *)directorySearchResult
{
    if ([directorySearchResult count] <= kDirectorySearchResultFilterLimitCount) {
        return directorySearchResult;
    }
    
    NSRange range;
    range.location = 0;
    range.length = kDirectorySearchResultFilterLimitCount;
    
    return [directorySearchResult subarrayWithRange:range];
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

@end
