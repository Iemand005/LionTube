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
        // https://github.com/iv-org/invidious/issues/1981
        
        self.clientName = @"MWEB";
        self.clientVersion = @"2.20220918";
        
        self.clientContext = @{
                               @"client": @{
                                       @"clientName": self.clientName,
                                       @"clientVersion": self.clientVersion
                                       }
                               };
        
        self.baseAddress = [NSURL URLWithString:@"https://www.youtube.com/youtubei/v1"];
        self.alternativeBaseAddress = [NSURL URLWithString:@"https://youtubei.googleapis.com/youtubei/v1"];
        self.playerEndpoint = [NSURL URLWithString:@"player" relativeToURL:self.baseAddress];
        self.nextEndpoint = [NSURL URLWithString:@"next" relativeToURL:self.baseAddress];
        self.browseEndpoint = [NSURL URLWithString:@"browse" relativeToURL:self.baseAddress];
        self.searchEndpoint = [NSURL URLWithString:@"search" relativeToURL:self.baseAddress];
        self.likeEndpoint = [NSURL URLWithString:@"like" relativeToURL:self.baseAddress];
        

    }
    return self;
}

- (NSDictionary *)sendPOSTRequestWithBody:(NSDictionary *)body error:(NSError **)error
{
    NSDictionary *result;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:error];
    if (!*error) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.playerEndpoint];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:requestBody];
        [request addValue:[NSString stringWithFormat:@"%li", requestBody.length] forHTTPHeaderField:@"Content-Length"];
        [request addValue:@"com.lasse.macos.youtube/1.0.0 (Darwin; U; Mac OS X 10.7; GB) gzip" forHTTPHeaderField:@"User-Agent"];
        [request addValue:@"www.youtube.com" forHTTPHeaderField:@"Host"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
        
        NSURLResponse *response;
        NSData *responseBody = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
        //response.
        NSString *htmlString = [[NSString alloc] initWithData:responseBody encoding:NSUTF8StringEncoding];
        NSLog(@"%@", htmlString);
        if (!*error)
            result = [NSJSONSerialization JSONObjectWithData:responseBody options:NSJSONReadingAllowFragments error:error];
        if (!result) {
            [[self.webView mainFrame] loadHTMLString:htmlString baseURL:self.playerEndpoint];
//            [[self.webView mainFrame] loadData:responseBody MIMEType:response.MIMEType textEncodingName:@"UTF8" baseURL:self.playerEndpoint];
//            WebView *webVie;
//            [[webVie mainFrame] load]
        }
    }
    return result;
}

- (LYouTubeVideo *)getVideoWithId:(NSString *)videoId
{
    LYouTubeVideo *video = [LYouTubeVideo videoWithId:videoId];
    NSLog(@"%1@, %2@, %3@", self.clientName, self.clientVersion, videoId);
    NSDictionary *body = @{
                           @"context": self.clientContext,
                           @"videoId": video.videoId,
                           @"contentCheckOk": @"true",
                           @"racyCheckOk": @"true"
                           };
    
    NSError *error;
    NSDictionary *videoDetailsDict = [self sendPOSTRequestWithBody:body error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    NSDictionary *playabilityStatus = [videoDetailsDict objectForKey:@"playabilityStatus"];
    if ([[playabilityStatus objectForKey:@"status"] isEqualToString:@"OK"])
        NSLog(@"Playability OK");
    
    NSDictionary *streamingData = [videoDetailsDict objectForKey:@"streamingData"];
    
    NSArray *formats = [streamingData objectForKey:@"formats"];
    NSArray *adaptiveFormats = [streamingData objectForKey:@"adaptiveFormats"];
    
    // https://gist.github.com/sidneys/7095afe4da4ae58694d128b1034e01e2
    NSMutableArray *parsedFormats = [NSMutableArray arrayWithCapacity:formats.count];
    for (NSDictionary *format in formats)
        [parsedFormats addObject:[LVideoFormat formatWithDictionary:format]];
    for (NSDictionary *format in adaptiveFormats)
        [parsedFormats addObject:[LVideoFormat formatWithDictionary:format]];
    video.formats = parsedFormats;
    
    NSDictionary *videoDetails = [videoDetailsDict objectForKey:@"videoDetails"];
    video.description = [videoDetails objectForKey:@"shortDescription"];
    video.title = [videoDetails objectForKey:@"title"];
    video.viewCount = [videoDetails objectForKey:@"viewCount"];
    return video;
}

- (NSArray *)browseYouTube
{
//    NSDictionary *body = @{
//                           @"context": self.clientContext,
//                           @"videoId": video.videoId,
//                           @"contentCheckOk": @"true",
//                           @"racyCheckOk": @"true"
//                           };
}

+ (LYouTubeClient *)client
{
    return [[LYouTubeClient alloc] init];
}

@end
