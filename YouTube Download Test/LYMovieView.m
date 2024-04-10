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
            if (self.isInFullScreenMode) {
                [self exitFullScreenModeWithOptions:nil];
                self.fillColor = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0];
            }
            else [self enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
            break;
    }
}

@end

@implementation dd

//- mo

@end
