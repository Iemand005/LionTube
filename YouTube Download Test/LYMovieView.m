//
//  MovieViewController.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYMovieView.h"

@implementation LYMovieView

- (void)updateConstraintsForSubtreeIfNeeded
{
    
}

//-movie

- (void)keyUp:(NSEvent *)theEvent
{
    NSLog(@"%hi", theEvent.keyCode);
//    NSApplicationpre
    switch (theEvent.keyCode) {
        case 3:
        case 53:
            [self toggleFullScreenMode];
//            if (self.isInFullScreenMode) {
//                [self exitFullScreenModeWithOptions:nil];
//                self.fillColor = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0];
//            }
//            else [self enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
            break;
    }
}

- (BOOL)enterFullScreenMode:(NSScreen *)screen withOptions:(NSDictionary *)options
{
    [self setFillColor:[NSColor blackColor]];
    return [super enterFullScreenMode:screen withOptions:options];
}

- (void)exitFullScreenModeWithOptions:(NSDictionary *)options
{
//    [super exitFullScreenModeWithOptions:options];
    [self setFillColor:[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0]];
    [super exitFullScreenModeWithOptions:options];
}

- (void)toggleFullScreenMode
{
    if (self.isInFullScreenMode) [self exitFullScreenModeWithOptions:nil];
    else [self enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
}

@end