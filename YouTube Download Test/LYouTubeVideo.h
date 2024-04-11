//
//  LYouTubeVideo.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>

//#import "LYTools.h"
#import "LYouTubeChannel.h"
#import "LYVideoFormat.h"
#import "LYPlaybackTracker.h"

@class LYAPIParser;
@class LYouTubeClient;

@interface LYouTubeVideo : NSObject

@property NSString *videoId;
@property NSArray *formats;
@property NSArray *adaptiveFormats;
@property NSString *title;
@property NSString *description;
@property NSNumber *viewCount;
@property NSString *subtitle;
@property QTMovie *movie;
@property LYouTubeClient *client;
@property LYouTubeChannel *channel;
@property LYPlaybackTracker *tracker;
@property BOOL isWatched;
@property NSImage *thumbnail;
@property NSURL *thumbnailURL;
@property NSString *shortStats;
@property NSString *lengthText;

@property NSURL *url;

@property BOOL isYouTubeVideo;

@property (nonatomic, readonly) NSInteger currentMediaTime;
@property (nonatomic, readonly) NSURL *channelThumbnailURL;

- (id)initWithId:(NSString *)videoId;

- (void)updateTracker;
- (QTMovie *)getDefaultMovie;
- (QTMovie *)getMovieWithFormat:(LYVideoFormat *)format;

- (void)play;
- (void)pause;
- (void)like;
- (void)dislike;
- (void)removeLike;

+ (LYouTubeVideo *)video;
+ (LYouTubeVideo *)videoWithId:(NSString *)videoId;

@end
