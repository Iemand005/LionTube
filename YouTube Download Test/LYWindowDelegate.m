//
//  LYWindow.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYWindowDelegate.h"

@implementation LYWindowDelegate

//- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
//{
//    [self.splitView setPosition:self.videoParentView.frame.size.width ofDividerAtIndex:0];
//    //NSSize newSize = NSMakeSize(self.videoParentView.frame.size.width, self.videoParentView.frame.size.width / 16 * 9);
//    //[self.videoParentView setFrameSize:newSize];
//    return frameSize;
//}

- (void)windowDidResize:(NSNotification *)notification
{
    [self.splitView setPosition:self.videoParentView.frame.size.width / 16 * 9 ofDividerAtIndex:0];
}

@end
