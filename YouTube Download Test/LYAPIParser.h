//
//  LYoutubeApiParser.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LYouTubeProfile.h"
#import "LYouTubeChannel.h"
#import "LYouTubeVideo.h"

//@class LYouTubeVideo;
//@class LYPlaybackTracker;

@interface LYAPIParser : NSObject

@property NSArray *webResponseContextPreloadData;
@property BOOL isLoggedIn;

- (NSArray *)parseVideosOnHomePage:(NSDictionary *)body;
- (LYouTubeVideo *)parseVideo:(NSDictionary *)videoData;
- (void)addVideoData:(NSDictionary *)videoInfo toVideo:(LYouTubeVideo *)video;
- (LYouTubeProfile *)parseProfile:(NSDictionary *)body;
- (NSURL *)addParameters:(NSDictionary *)parameters toURL:(NSURL *)url;
- (NSDictionary *)dictionaryWithQueryFromURL:(NSURL *)url;
- (NSString *)stringByRemovingQueryFromURL:(NSURL *)url;
- (void)sendParameters:(NSDictionary *)parameters toEndpoint:(NSURL *)endpoint;

+ (LYAPIParser *)parser;

@end
