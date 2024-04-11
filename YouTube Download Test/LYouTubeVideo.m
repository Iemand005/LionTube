//
//  LYouTubeVideo.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYouTubeVideo.h"
#import "LYouTubeClient.h"

@implementation LYouTubeVideo

- (id)init
{
    self = [super init];
    if (self) {
        self.tracker = [LYPlaybackTracker trackerForVideo:self];
    }
    return self;
}

- (id)initWithId:(NSString *)videoId
{
    self = [self init];
    if (self) {
        self.videoId = [self getVideoIdFromArbitraryString:videoId];
    }
    return self;
}

- (void)play
{
    [self.tracker updateWatchtime];
}

- (void)pause
{
    [self.tracker pauseTracking];
}

- (NSInteger)currentMediaTime
{
    return round(self.movie.currentTime.timeValue / self.movie.currentTime.timeScale);
}

- (NSURL *)channelThumbnailURL
{
    return self.channel.thumbnailUrl;
}

- (QTMovie *)getMovieWithFormat:(LYVideoFormat *)format
{
    self.url = [NSURL URLWithString:format.url];
    return self.movie = [[QTMovie alloc] initWithURL:self.url error:nil];
}

- (QTMovie *)getMovieWithFormatIndex:(NSUInteger)index
{
    return [self getMovieWithFormat:[self.formats objectAtIndex:index]];
}

- (QTMovie *)getDefaultMovie
{
    if (!self.isYouTubeVideo) return [[QTMovie alloc] initWithURL:self.url error:nil];
    return [self getMovieWithFormatIndex:0];
}

- (void)like
{
    [self sendActionForEndpoint:self.client.likeLikeEndpoint];
}

- (void)dislike
{
    [self sendActionForEndpoint:self.client.likeDislikeEndpoint];
}

- (void)removeLike
{
    [self sendActionForEndpoint:self.client.likeRemoveLikeEndpoint];
}

- (NSDictionary *)sendActionForEndpoint:(NSURL *)endpoint
{
    return [self.client POSTRequest:endpoint WithBody:[self rateBody] error:nil];
}

- (NSDictionary *)rateBody
{
    return @{@"context": self.client.clientContext, @"target": @{@"videoId": self.videoId}};
}

- (NSDictionary *)actionBody
{
    NSDictionary *body = @{@"context": self.client.clientContext, @"videoId": self.videoId};
    return body;
}

- (NSString *)getVideoIdFromArbitraryString:(NSString *)string
{
    NSString *result;
//    self.client.par wait morgan and morgan is real???
    NSDictionary *query = [self.client.parser dictionaryWithQueryFromURL:[NSURL URLWithString:string]];
    result = [query objectForKey:@"v"];
    
    if (!result) result = string;

    if (!result) result = string;
    return result;
}

- (BOOL)isUrl:(NSString *)string
{
    return [string hasPrefix:@"http"] || [string hasPrefix:@"www"];
}

- (void)updateTracker
{
    [self.tracker updateWatchtime];
}

+ (LYouTubeVideo *)video
{
    return [[LYouTubeVideo alloc] init];
}

+ (LYouTubeVideo *)videoWithId:(NSString *)videoId
{
    return [[LYouTubeVideo alloc] initWithId:videoId];
}

@end

//@implementation LVideoFormat
//
//
//
//@end
