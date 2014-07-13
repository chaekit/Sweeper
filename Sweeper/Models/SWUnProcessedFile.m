//
//  SWUnProcessedFile.m
//  Sweeper
//
//  Created by Jay Chae  on 1/2/14.
//  Copyright (c) 2014 JCLab. All rights reserved.
//

#import "SWUnProcessedFile.h"
#import <QuickLook/QuickLook.h>

static const NSUInteger kSWUnprocessedFileIconWidth         = 64;
static const NSUInteger kSWUnprocessedFileIconHeight        = 64;

@implementation SWUnProcessedFile

+ (instancetype)unprocessedFileAtPath:(NSString *)path {
    SWUnProcessedFile *unprocessedFile = [[SWUnProcessedFile alloc] init];
    [unprocessedFile setFilePath:path];
    [unprocessedFile setupFilename];
    [unprocessedFile setupIcon];
    
    return unprocessedFile;
}

#pragma mark - Private initialization helper methods

- (void)setupIcon {
    CGImageRef iconImageRef = QLThumbnailImageCreate(NULL,
                                                     (__bridge CFURLRef)[NSURL fileURLWithPath:self.filePath],
                                                     CGSizeMake(kSWUnprocessedFileIconWidth, kSWUnprocessedFileIconHeight),
                                                     (__bridge CFDictionaryRef)@{ (NSString*) kQLThumbnailOptionIconModeKey:@(YES)});
    NSImage *icon;
    if (!iconImageRef) {
        /* No image was found through QuickLook request. Gets a basic icon using an NSWorkspace object */
        NSWorkspace *workspace = [[NSWorkspace alloc] init];
        icon = [workspace iconForFile:self.filePath];
        [icon setSize:NSMakeSize(kSWUnprocessedFileIconWidth * 2, kSWUnprocessedFileIconHeight * 2)];
    } else {
        icon = [[NSImage alloc] initWithCGImage:iconImageRef size:NSMakeSize(kSWUnprocessedFileIconWidth, kSWUnprocessedFileIconHeight)];
    }
    
    [self setFileIcon:icon];
}

- (void)setupFilename {
    NSArray *pathComponents = [self.filePath componentsSeparatedByString:@"/"];
    NSString *fileName = [pathComponents lastObject];
    [self setFileName:fileName];
}


@end
