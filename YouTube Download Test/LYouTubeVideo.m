//
//  LYouTubeVideo.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYouTubeVideo.h"

@implementation LYouTubeVideo

- (id)initWithId:(NSString *)videoId
{
    self = [super init];
    if (self) {
        self.videoId = [self getVideoIdFromArbitraryString:videoId];
        self.title = @"title";
    }
    return self;
}

- (QTMovie *)getMovieWithFormat:(LVideoFormat *)format
{
    self.url = [NSURL URLWithString:format.url];
    return [[QTMovie alloc] initWithURL:self.url error:nil];
}

- (QTMovie *)getMovieWithFormatIndex:(NSUInteger)index
{
    return [self getMovieWithFormat:[self.formats objectAtIndex:index]];
}

- (QTMovie *)getDefaultMovie
{
    QTMovie *movie;
    if (self.isYouTubeVideo) return [self getMovieWithFormatIndex:0];
    else return [[QTMovie alloc] initWithURL:self.url error:nil];
    return movie;
}

- (NSString *)getVideoIdFromArbitraryString:(NSString *)string
{
    NSString *result;
    if ([self isUrl:string]) {
        NSDictionary *query = [self extractQueryComponentsFromURLString:string];
        result = [query objectForKey:@"v"];
    } else {
        result = string;
    }

    if (!result) result = string;
    return result;
}

- (BOOL)isUrl:(NSString *)string
{
    return [string hasPrefix:@"http"] || [string hasPrefix:@"www"];
}

- (NSDictionary *)extractQueryComponentsFromURLString:(NSString *)url
{
    NSArray *components = [url componentsSeparatedByString:@"?"];
    NSString *query = [components objectAtIndex:1];
    NSArray *queryParameterStrings = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionaryWithCapacity:queryParameterStrings.count];
    for (NSString *queryParameterString in queryParameterStrings) {
        NSArray *queryParameterComponents = [queryParameterString componentsSeparatedByString:@"="];
        [queryParameters setObject:[queryParameterComponents objectAtIndex:1] forKey:[queryParameterComponents objectAtIndex:0]];
    }
    return queryParameters;
}

+ (LYouTubeVideo *)videoWithId:(NSString *)videoId
{
    return [[LYouTubeVideo alloc] initWithId:videoId];
}

@end

@implementation LVideoFormat

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.url = [dict objectForKey:@"url"];
        self.fps = [dict objectForKey:@"fps"];
        self.width = [dict objectForKey:@"width"];
        self.height = [dict objectForKey:@"height"];
        self.mimeType = [dict objectForKey:@"mimeType"];
    }
    return self;
}

+ (LVideoFormat *)formatWithDictionary:(NSDictionary *)dict
{
    return [[LVideoFormat alloc] initWithDictionary:dict];
}

@end
