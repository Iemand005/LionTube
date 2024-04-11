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
{
    int cmt;
    int rt;
    int lact;
    int rtn;
    int rti;
    int st;
    int et;
    
    bool timeCMT;
    bool timeRT;
    bool timeRTN;
    bool timeRTI;
}

@property NSURL *playbackUrl;
@property NSURL *watchtimeUrl;
@property NSURL *delayplayUrl;
@property NSURL *ptrackingUrl;
@property NSURL *qoeUrl;
@property NSURL *atrUrl;

@property NSDate *rtStart;
@property NSDate *cmtStart;
//@property NSTimer *timer;

@property (readonly, nonatomic) NSInteger cmt;
@property (readonly, nonatomic) NSInteger rt;
@property NSInteger st;
@property NSInteger et;
@property NSInteger lact;
//@property int cmt;
//@property int rt;
//@property int lact;
//@property int rtn;
//@property int rti;
//@property int st;
//@property int et;

@property NSArray *scheduledFlushWalltimeSeconds;
@property NSNumber *defaultFlushIntervalSeconds;

- (void)updateWatchtime;
- (void)startTracking;
- (void)pauseTracking;
- (void)continueTracking;

+ (LYPlaybackTracker *)tracker;

@end
