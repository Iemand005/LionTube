//
//  LYoutubeApiParser.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LYouTubeProfile.h"
#import "LYouTubeVideo.h"
#import "LYouTubeChannel.h"

@interface LYAPIParser : NSObject

@property NSArray *webResponseContextPreloadData;
@property BOOL isLoggedIn;

- (NSArray *)parseVideosOnHomePage:(NSDictionary *)body;
- (LYouTubeVideo *)parseVideo:(NSDictionary *)videoData;
- (LYouTubeProfile *)parseProfile:(NSDictionary *)body;
- (NSURL *)addParameters:(NSDictionary *)parameters toURL:(NSURL *)url;
- (NSDictionary *)dictionaryWithQueryFromURL:(NSURL *)url;
- (NSString *)stringByRemovingQueryFromURL:(NSURL *)url;
- (void)sendParameters:(NSDictionary *)parameters toEndpoint:(NSURL *)endpoint;

+ (LYAPIParser *)parser;

@end