//
//  LYoutubeApiParser.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYoutubeApiParser.h"

@implementation LYoutubeApiParser

- (NSArray *)parseVideosOnHomePage:(NSDictionary *)body
{
    NSString *tracking = [body objectForKey:@"trackingParams"];
    [body writeToFile:[NSString stringWithFormat:@"homePage%@.plist", tracking] atomically:NO];
    NSDictionary *responseContext = [body objectForKey:@"responseContext"];
    NSArray *preloadMessageNames = [[[responseContext objectForKey:@"webResponseContextExtensionData"] objectForKey:@"webResponseContextPreloadData"] objectForKey:@"preloadMessageNames"];
    NSUInteger tabRendererIndex = [preloadMessageNames indexOfObject:@"tabRenderer"];
    NSString *listRenderer = [preloadMessageNames objectAtIndex:tabRendererIndex + 1];
    NSString *itemRenderer = [preloadMessageNames objectAtIndex:tabRendererIndex + 2];
    NSString *videoRenderer = [preloadMessageNames objectAtIndex:tabRendererIndex + 3];
//    self.isLoggedIn;
    
    NSMutableArray *videos = [NSMutableArray array];
    NSArray *tabs = [[[body objectForKey:@"contents"] objectForKey:@"singleColumnBrowseResultsRenderer"] objectForKey:@"tabs"];
    for (NSDictionary *tab in tabs) {
        NSDictionary *tabContent = [[tab objectForKey:@"tabRenderer"] objectForKey:@"content"];
        NSDictionary *richRenderer = [tabContent objectForKey:listRenderer];
        NSArray *videoDataList = [richRenderer objectForKey:@"contents"];
        for (NSDictionary *videoData in videoDataList) {
            NSDictionary *renderer = [videoData objectForKey:itemRenderer];
            //if (!renderer) renderer = [videoData objectForKey:@"richSectionRenderer"];
            
            NSDictionary *content = [renderer objectForKey:@"content"];
            NSArray *contents;
            if (content) contents = [NSArray arrayWithObject:content];
            else contents = [renderer objectForKey:@"contents"];
            for (NSDictionary *content in contents) {
                NSDictionary *videokak = [content objectForKey:videoRenderer];
                if (videokak) [videos addObject:[self parseVideo:videokak]];
            }
        }
    }
    
//    NSDictionary *videoData = [[[[body objectForKey:@"contents"] objectForKey:@"richItemRenderer"] objectForKey:@"content"] objectForKey:@"videoWithContextRenderer"];
    return videos;
}

- (LYouTubeVideo *)parseVideo:(NSDictionary *)videoData
{
    LYouTubeVideo *video = [LYouTubeVideo video];
    
    NSDictionary *playabilityStatus = [videoData objectForKey:@"playabilityStatus"];
    if (playabilityStatus) {
        if ([[playabilityStatus objectForKey:@"status"] isEqualToString:@"OK"])
            NSLog(@"Playability OK");
        
        NSDictionary *streamingData = [videoData objectForKey:@"streamingData"];
        
        NSArray *formats = [streamingData objectForKey:@"formats"];
        //NSArray *adaptiveFormats = [streamingData objectForKey:@"adaptiveFormats"];
        
        // https://gist.github.com/sidneys/7095afe4da4ae58694d128b1034e01e2
        NSMutableArray *parsedFormats = [NSMutableArray arrayWithCapacity:formats.count];
        for (NSDictionary *format in formats)
            [parsedFormats addObject:[LYVideoFormat formatWithDictionary:format]];
//        for (NSDictionary *format in adaptiveFormats) [parsedFormats addObject:[LYVideoFormat formatWithDictionary:format]];
        video.formats = parsedFormats;
        
        NSDictionary *videoDetails = [videoData objectForKey:@"videoDetails"];
        video.description = [videoDetails objectForKey:@"shortDescription"];
        video.title = [videoDetails objectForKey:@"title"];
        video.viewCount = [videoDetails objectForKey:@"viewCount"];
        [video setTracker:[self parsePlaybackTracker:[videoData objectForKey:@"playbackTracking"]]];
    } else {
        NSString *videoId = [videoData objectForKey:@"videoId"];
        NSString *videoTitle = [[[[videoData objectForKey:@"headline"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
        
        NSDictionary *thumbnailData = [[[videoData objectForKey:@"thumbnail"] objectForKey:@"thumbnails"] lastObject];
        NSURL *thumbnailUrl = [NSURL URLWithString:[thumbnailData objectForKey:@"url"]];
        
        NSString *shortStats = [[[[videoData objectForKey:@"shortViewCountText"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
        NSString *shortLength = [[[[videoData objectForKey:@"lengthText"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
        NSString *shortTime = [self runText:[videoData objectForKey:@"publishedTimeText"]];
        video.lengthText = shortLength;
        video.shortStats = [shortStats stringByAppendingFormat:@" - %@", shortTime];

        video.videoId = videoId;
        LYouTubeChannel *channel = [self parseChannel:[videoData objectForKey:@"channelThumbnail"]];
        NSString *channelName = [[[[videoData objectForKey:@"shortBylineText"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
        [channel setName:channelName];
        [video setChannel:channel];
        [video setThumbnailURL:thumbnailUrl];
        [video setTitle:videoTitle];
    }
    return video;
}

- (NSString *)runText:(NSDictionary *)body
{
    return [[[body objectForKey:@"runs"] firstObject] objectForKey:@"text"];
}

- (NSString *)accessibilityText:(NSDictionary *)body
{
    return [[[body objectForKey:@"accessibility"] objectForKey:@"accessibilityData"] objectForKey:@"label"];
}

- (LYouTubeChannel *)parseChannel:(NSDictionary *)channelData
{
    LYouTubeChannel *youtubeChannel;
    NSDictionary *data;
    if ((data = [channelData objectForKey:@"channelThumbnailWithLinkRenderer"])) {
        youtubeChannel = [LYouTubeChannel channel];
//        [[[NSArray alloc] init] l]
        NSDictionary *thumbnailData = [[[data objectForKey:@"thumbnail"] objectForKey:@"thumbnails"] firstObject];
        NSString *thumbnailUrl = [thumbnailData objectForKey:@"url"];
//        NSString *videoTitle = [[[[data objectForKey:@"headline"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
        
        NSDictionary *channelEndpoint = [[data objectForKey:@"navigationEndpoint"] objectForKey:@"browseEndpoint"];
//        NSNumber *thumbnailWidth = [thumbnailData objectForKey:@"width"];
//        NSNumber *thumbnailHeight = [thumbnailData objectForKey:@"height"];
        [youtubeChannel setThumbnailWithURL:[NSURL URLWithString:thumbnailUrl]];
        [youtubeChannel setTag:[channelEndpoint objectForKey:@"canonicalBaseUrl"]];
        [youtubeChannel setBrowseId:[channelEndpoint objectForKey:@"browseId"]];
    }
    return youtubeChannel;
}

- (LYouTubeProfile *)parseProfile:(NSDictionary *)body
{
    LYouTubeProfile *profile = [LYouTubeProfile profile];
    profile.name = [body objectForKey:@"name"];
    profile.givenName = [body objectForKey:@"given_name"];
    profile.familyName = [body objectForKey:@"family_name"];
    profile.locale = [body objectForKey:@"name"];
    profile.pictureUrl = [NSURL URLWithString:[body objectForKey:@"picture"]];
    profile.picture = [[NSImage alloc] initByReferencingURL:profile.pictureUrl];
    profile.sub = [body objectForKey:@"sub"];
    return profile;
}

- (LYPlaybackTracker *)parsePlaybackTracker:(NSDictionary *)body
{
    LYPlaybackTracker *tracker = [LYPlaybackTracker tracker];
    tracker.playbackUrl = [body objectForKey:@"videostatsPlaybackUrl"];
        tracker.delayPlayUrl = [body objectForKey:@"videostatsDelayplayUrl"];
        tracker.watchtimeUrl = [body objectForKey:@"videostatsWatchtimeUrl"];
        tracker.ptrackingUrl = [body objectForKey:@"ptrackingUrl"];
            tracker.qoeUrl = [body objectForKey:@"qoeUrl"];
            tracker.atrUrl = [body objectForKey:@"atrUrl"];
    tracker.scheduledFlushWalltimeSeconds = [body objectForKey:@"videostatsScheduledFlushWalltimeSeconds"];
    tracker.defaultFlushIntervalSeconds = [body objectForKey:@"videostatsDefaultFlushIntervalSeconds"];
    return tracker;
}

+ (LYoutubeApiParser *)parser
{
    return [[LYoutubeApiParser alloc] init];
}

@end
