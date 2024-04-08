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
    }
    return self;
}

- (void)requestVideoWithClient:(LYouTubeClient *)client
{
    if (!client.clientName) client.clientName = @"MWEB";
        if (!client.clientVersion) client.clientVersion = @"2.20220918";
//    if (!self.videoId) self.videoId = @"";
    NSLog(@"%1@, %2@, %3@", client.clientName, client.clientVersion, self.videoId);
    NSDictionary *body = @{
                           @"context": @{
                                   @"client": @{
                                           @"clientName": client.clientName,// ? client.clientName : @"MWEB",
                                           @"clientVersion": client.clientVersion// ? client.clientVersion : @"2.20220918"
                                           }
                                   },
                           @"videoId": self.videoId,// ? self.videoId : @"",
                           @"contentCheckOk": @"true",
                           @"racyCheckOk": @"true"
                           };
    
    NSError *error;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:&error];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:client.endPoint];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBody];
    [request addValue:[NSString stringWithFormat:@"%li", requestBody.length] forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"com.lasse.macos.youtube/1.0.0 (Darwin; U; Mac OS X 10.7; GB) gzip" forHTTPHeaderField:@"User-Agent"];
    [request addValue:@"www.youtube.com" forHTTPHeaderField:@"Host"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    
    NSURLResponse *response;
    NSData *responseBody = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *videoDetailsDict = [NSJSONSerialization JSONObjectWithData:responseBody options:NSJSONReadingAllowFragments error:&error];
    
    NSDictionary *playabilityStatus = [videoDetailsDict objectForKey:@"playabilityStatus"];
    if ([[playabilityStatus objectForKey:@"status"] isEqualToString:@"OK"])
        NSLog(@"Playability OK");
    
    NSDictionary *streamingData = [videoDetailsDict objectForKey:@"streamingData"];
    NSArray *formats = [streamingData objectForKey:@"formats"];
    
    NSMutableArray *parsedFormats = [NSMutableArray arrayWithCapacity:formats.count];
    for (NSDictionary *format in formats)
        [parsedFormats addObject:[LVideoFormat formatWithDictionary:format]];
   // self.formats = parsedFormats;
    
    NSArray *adaptiveFormats = [streamingData objectForKey:@"adaptiveFormats"];
    //parsedFormats = [NSMutableArray arrayWithCapacity:adaptiveFormats.count];
    for (NSDictionary *format in adaptiveFormats)
        [parsedFormats addObject:[LVideoFormat formatWithDictionary:format]];
    self.formats = parsedFormats;
    
    NSDictionary *videoDetails = [videoDetailsDict objectForKey:@"videoDetails"];
    self.description = [videoDetails objectForKey:@"shortDescription"];
    self.viewCount = [videoDetails objectForKey:@"viewCount"];
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
    NSDictionary *query = [self extractQueryComponentsFromURLString:string];
    result = [query objectForKey:@"v"];
    if (!result) result = string;
    return result;
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
        self.mimeType = [dict objectForKey:@"mimeType"];
    }
    return self;
}

+ (LVideoFormat *)formatWithDictionary:(NSDictionary *)dict
{
    return [[LVideoFormat alloc] initWithDictionary:dict];
}

@end
