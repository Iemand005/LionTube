//
//  LYPlaybackTracker.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 10/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//
//  The playback tracker stores the watch time of the current video to make it count as a view and allow the user to continue watching where they left off.
//

#import <Foundation/Foundation.h>

#import "LYTools.h"

@interface LYPlaybackTracker : NSObject

@property NSURL *playbackUrl;
@property NSURL *watchtimeUrl;
@property NSURL *delayplayUrl;
@property NSURL *ptrackingUrl;
@property NSURL *qoeUrl;
@property NSURL *atrUrl;

@property NSNumber *cmt;
@property NSNumber *rt;
@property NSNumber *lact;
@property NSNumber *rtn;
@property NSNumber *rti;
@property NSNumber *st;
@property NSNumber *et;

@property NSArray *scheduledFlushWalltimeSeconds;
@property NSNumber *defaultFlushIntervalSeconds;

- (void)updateWatchtime;
- (void)startTracking;
- (void)pauseTracking;
- (void)continueTracking;

+ (LYPlaybackTracker *)tracker;

@end
