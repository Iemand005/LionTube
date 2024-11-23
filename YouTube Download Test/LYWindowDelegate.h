//
//  LYWindow.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LYWindowDelegate : NSObject <NSWindowDelegate>

@property IBOutlet NSSplitView *splitView;
@property IBOutlet NSView *videoParentView;

@property NSInteger videoWidth;
@property NSInteger videoHeight;

@end
