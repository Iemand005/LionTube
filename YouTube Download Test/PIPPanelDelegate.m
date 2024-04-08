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
    return NO;
}

@end
