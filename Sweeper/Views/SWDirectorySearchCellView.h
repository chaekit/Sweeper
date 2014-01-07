//
//  SWDirectorySearchCellView.h
//  Sweeper
//
//  Created by Jay Chae  on 1/7/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SWDirectorySearchCellView : NSTableCellView

@property (nonatomic, strong) IBOutlet NSTextField *fullPathTextField;
@property (nonatomic, strong) IBOutlet NSTextField *nameTextField;
@property (nonatomic, strong) IBOutlet NSImageView *iconImageView;

@end
