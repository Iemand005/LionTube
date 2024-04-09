//
//  LYoutubeApiParser.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LYouTubeVideo.h"
#import "LYouTubeChannel.h"

@interface LYoutubeApiParser : NSObject

@property NSArray *webResponseContextPreloadData;
@property BOOL isLoggedIn;

- (NSArray *)parseVideosOnHomePage:(NSDictionary *)body;

+ (NSURL *)getLoginURLFromBody:(NSDictionary *)body;

+ (LYoutubeApiParser *)parser;

@end
