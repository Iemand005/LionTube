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

- (void)keyUp:(NSEvent *)theEvent
{
    NSLog(@"%hi", theEvent.keyCode);
//    NSApplicationpre
    switch (theEvent.keyCode) {
        case 3:
        case 53:
            if (self.isInFullScreenMode) [self exitFullScreenModeWithOptions:nil];
            else [self enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
            break;
    }
}

@end
