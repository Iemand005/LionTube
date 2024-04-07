//
//  LYClient.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYouTubeClient.h"

@implementation LYouTubeClient

- (id)init
{
    self = [super init];
    if (self) {
        self.endPoint = [NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/player"];
        self.clientDetails = @{
                               @"context": @{
                                       @"client": @{
                                               @"clientName": @"MWEB",
                                               @"clientVersion": @"2.20220918",
                                               }
                                       },
                               @"videoId": @"",
                               @"contentCheckOk": @"true",
                               @"racyCheckOk": @"true"
                               };
    }
    return self;
}

- (void)requestVideoDetails
{
    NSError *error;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:self.clientDetails options:NSJSONWritingPrettyPrinted error:&error];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.endPoint];
    
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
    
    if ([[videoDetailsDict objectForKey:@"playabilityStatus"] isEqualToString:@"OK"]) {
        NSDictionary *streamingData = [videoDetailsDict objectForKey:@"streamingData"];
        NSArray *formats = [streamingData objectForKey:@"formats"];
        
    }
}

- (LYouTubeVideo *)getVideoWithId:(NSString *)videoId
{
    self.masterVideo = [LYouTubeVideo videoWithId:videoId];
    
    return self.masterVideo;
}///Users/Lasse/Documents/Projects/YouTube Download Test/YouTube Download Test/LYouTubeClient.h

+ (LYouTubeClient *)client
{
    return [[LYouTubeClient alloc] init];
}

@end
