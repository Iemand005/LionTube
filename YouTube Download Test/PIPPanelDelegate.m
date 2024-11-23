//
//  PIPPanelDelegate.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "PIPPanelDelegate.h"

@implementation PIPPanelDelegate

- (void)windowDidEnterFullScreen:(NSNotification *)notification
{
    [NSCursor hide];
    [self.panel setStyleMask:NSBorderlessWindowMask];
}

- (BOOL)windowShouldClose:(id)sender
{
    [self.panel orderOut:sender];
    QTMovie *movie = self.pipMovieView.movie;
    [self.pipMovieView setMovie:nil];
    [self.movieView setMovie:movie];
    [self.movieView setControllerVisible:YES];
    return NO;
}

- (NSRect)windowWillUseStandardFrame:(NSWindow *)window defaultFrame:(NSRect)newFrame
{
    return NSMakeRect(0, 0, 100, 100);
}

@end