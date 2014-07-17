//
//  SWHomeDirectoryViewController.h
//  Sweeper
//
//  Created by Jay Chae  on 7/16/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

FOUNDATION_EXPORT NSString * SWHomDirectoryViewController_NIB_Name;

@class SWHomeDirectoryViewController;

@protocol SWHomeDirectorySearchTableViewControllerDelegate <NSObject>

/**
 Called when view controller has a new search query string
 @param queryString new queryString
 */
- (void)directorySearchViewController:(SWHomeDirectoryViewController *)directorySearchViewController
         didReceivedSearchQueryString:(NSString *)queryString;

/**
 Called when view controller selects a cell at row index 'rowIndex'
 @param rowIndex index of the selected row
 */
- (void)directorySearchViewController:(SWHomeDirectoryViewController *)directorySearchViewController
                         didSelectRow:(NSUInteger)rowIndex;

/**
 Called when view controller cancels the search
 */
- (void)directorySearchViewControllerDidCancelSearch:(SWHomeDirectoryViewController *)directorySearchViewController;

@end

/**
 Provides interface for searching directories and selecting destination result in home directory
 */
@interface SWHomeDirectoryViewController : NSViewController

/**
 Updates the data source with the given input
 @param homeDirectoriesDatSource new data source
 */
- (void)updateHomeDirectoriesDataSource:(NSArray *)homeDirectoriesDataSource;

@property (nonatomic, weak) id<SWHomeDirectorySearchTableViewControllerDelegate> delegate;

@end
