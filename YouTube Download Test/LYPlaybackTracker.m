//
//  LYPlaybackTracker.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 10/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYPlaybackTracker.h"

@implementation LYPlaybackTracker

- (void)updateWatchtime
{
    [self pollTracker:self.watchtimeUrl];
}

- (void)startTracking
{
    [self pollTracker:self.playbackUrl];
    [self updateWatchtime];
}

- (void)pauseTracking
{
    [self pollTracker:self.delayplayUrl];
}

- (void)continueTracking
{
//    [self pollTracker:self.watchtimeUrl];
    [self updateWatchtime];
}

- (void)pollTracker:(NSURL *)endpoint
{
    NSURLRequest *request = [NSURLRequest requestWithURL:endpoint];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSInteger result){}];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

+ (LYPlaybackTracker *)tracker
{
    return [[LYPlaybackTracker alloc] init];
}

@end
