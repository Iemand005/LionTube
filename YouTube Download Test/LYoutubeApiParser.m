//
//  LYoutubeApiParser.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYoutubeApiParser.h"

@implementation LYoutubeApiParser

+ (NSURL *)getLoginURLFromBody:(NSDictionary *)body
{
    NSDictionary *header = [body objectForKey:@"overlay"];
    NSDictionary *consentBumpV2Renderer = [header objectForKey:@"consentBumpV2Renderer"];
    NSDictionary *signInButton = [consentBumpV2Renderer objectForKey:@"signInButton"];
    
}

- (NSArray *)parseVideosOnHomePage:(NSDictionary *)body
{
    NSDictionary *responseContext = [body objectForKey:@"responseContext"];
    self.webResponseContextPreloadData = [[responseContext objectForKey:@"webResponseContextExtensionData"] objectForKey:@"webResponseContextPreloadData"];
//    self.isLoggedIn;
    
    NSMutableArray *videos = [NSMutableArray array];
    NSArray *tabs = [[[body objectForKey:@"contents"] objectForKey:@"singleColumnBrowseResultsRenderer"] objectForKey:@"tabs"];
    for (NSDictionary *tab in tabs) {
        NSArray *videoDataList = [[[[tab objectForKey:@"tabRenderer"] objectForKey:@"content"] objectForKey:@"richGridRenderer"] objectForKey:@"contents"];
        for (NSDictionary *videoData in videoDataList) {
            NSDictionary *renderer = [videoData objectForKey:@"richItemRenderer"];
            //if (!renderer) renderer = [videoData objectForKey:@"richSectionRenderer"];
            
            NSDictionary *context = [renderer objectForKey:@"content"];
            NSDictionary *videokak = [context objectForKey:@"videoWithContextRenderer"];
//            if (!videokak) videokak
            [videos addObject:[self parseVideo:videokak]];
        }
    }
    
//    NSDictionary *videoData = [[[[body objectForKey:@"contents"] objectForKey:@"richItemRenderer"] objectForKey:@"content"] objectForKey:@"videoWithContextRenderer"];
    return videos;
}

- (LYouTubeVideo *)parseVideo:(NSDictionary *)videoData
{
    NSString *videoId = [videoData objectForKey:@"videoId"];
    NSString *videoTitle = [[[[videoData objectForKey:@"headline"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
    
    NSDictionary *thumbnailData = [[[videoData objectForKey:@"thumbnail"] objectForKey:@"thumbnails"] lastObject];
    NSURL *thumbnailUrl = [NSURL URLWithString:[thumbnailData objectForKey:@"url"]];
    
    LYouTubeVideo *video = [LYouTubeVideo videoWithId:videoId];
    LYouTubeChannel *channel = [self parseChannel:[videoData objectForKey:@"channelThumbnail"]];
    NSString *channelName = [[[[videoData objectForKey:@"shortBylineText"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
    [channel setName:channelName];
    [video setChannel:channel];
    [video setThumbnailURL:thumbnailUrl];
    [video setTitle:videoTitle];
    return video;
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

+ (LYoutubeApiParser *)parser
{
    return [[LYoutubeApiParser alloc] init];
}

@end
