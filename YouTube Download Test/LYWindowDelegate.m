//
//  LYWindow.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYWindowDelegate.h"

@implementation LYWindowDelegate

- (void)windowDidResize:(NSNotification *)notification
{
    [self.splitView setPosition:self.videoParentView.frame.size.width / 16 * 9 ofDividerAtIndex:0];
}

@end
