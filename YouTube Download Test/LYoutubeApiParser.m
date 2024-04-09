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
    NSMutableArray *videos = [NSMutableArray array];
    NSArray *tabs = [[[body objectForKey:@"contents"] objectForKey:@"singleColumnBrowseResultsRenderer"] objectForKey:@"tabs"];
    for (NSDictionary *tab in tabs) {
        NSArray *videoDataList = [[[[tab objectForKey:@"tabRenderer"] objectForKey:@"content"] objectForKey:@"richGridRenderer"] objectForKey:@"contents"];
        for (NSDictionary *videoData in videoDataList) {
            [[[videoData objectForKey:@"richItemRenderer"] objectForKey:@"content"] objectForKey:@"videoWithContextRenderer"];
        }
    }
    
//    NSDictionary *videoData = [[[[body objectForKey:@"contents"] objectForKey:@"richItemRenderer"] objectForKey:@"content"] objectForKey:@"videoWithContextRenderer"];
    return videos;
}

@end
