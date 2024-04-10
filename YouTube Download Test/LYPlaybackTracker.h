//
//  LYPlaybackTracker.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 10/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYPlaybackTracker : NSObject

@property NSURL *playbackUrl;
@property NSURL *watchtimeUrl;
@property NSURL *delayPlayUrl;
@property NSURL *ptrackingUrl;
@property NSURL *qoeUrl;
@property NSURL *atrUrl;

@property NSArray *scheduledFlushWalltimeSeconds;
@property NSNumber *defaultFlushIntervalSeconds;

+ (LYPlaybackTracker *)tracker;

@end
