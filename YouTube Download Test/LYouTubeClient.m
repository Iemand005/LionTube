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
        
        self.clientId = @"861556708454-d6dlm3lh05idd8npek18k6be8ba3oc68.apps.googleusercontent.com";
        self.clientSecret = @"SboVhoG9s0rNafixCSGGKXAT";
        
        self.discoveryDocumentUrl = [NSURL URLWithString:@"https://accounts.google.com/.well-known/openid-configuration"];
        
        NSDictionary *openIDConfig = [self getOpenIDConfiguration];
        self.deviceAuthorizationEndpoint = [NSURL URLWithString:[openIDConfig objectForKey:@"device_authorization_endpoint"]];
        
        self.clientContext = @{
                               @"client": @{
                                       @"clientName": self.clientName,
                                       @"clientVersion": self.clientVersion
                                       }
                               };
        
        self.baseAddress = [NSURL URLWithString:@"https://www.youtube.com/youtubei/v1"];
        self.alternativeBaseAddress = [NSURL URLWithString:@"https://youtubei.googleapis.com/youtubei/v1"];
        self.playerEndpoint = [self.baseAddress URLByAppendingPathComponent:@"player"];
        self.nextEndpoint = [self.baseAddress URLByAppendingPathComponent:@"next"];
        self.browseEndpoint = [self.baseAddress URLByAppendingPathComponent:@"browse"];
        self.searchEndpoint = [self.baseAddress URLByAppendingPathComponent:@"search"];
        self.likeEndpoint = [self.baseAddress URLByAppendingPathComponent:@"like"];
        https://music.youtube.com/youtubei/v1/account/account_menu
        self.cookieString = [self getCookies];
    }
    return self;
}

- (NSDictionary *)POSTRequest:(NSURL *)url WithBody:(NSDictionary *)body error:(NSError **)error
{
    NSDictionary *result;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:error];
    NSLog(@"%@", [[NSString alloc] initWithData:requestBody encoding:NSUTF8StringEncoding]);
    if (!error || !*error) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:requestBody];
        [request addValue:[NSString stringWithFormat:@"%li", requestBody.length] forHTTPHeaderField:@"Content-Length"];
        [request addValue:@"com.lasse.macos.youtube/1.0.0 (Darwin; U; Mac OS X 10.7; GB) gzip" forHTTPHeaderField:@"User-Agent"];
//        [request addValue:@"www.youtube.com" forHTTPHeaderField:@"Host"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [request addValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
//        [request addValue:@"keep-alive" forHTTPHeaderField:@"Authorization"];
//        [request addValue:self.cookieString forHTTPHeaderField:@"Cookie"];
//        NSDictionary * headers = ;
//        [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:self.cookieArray]];
        
        NSURLResponse *response;
        NSData *responseBody = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
        //response.
        NSString *htmlString = [[NSString alloc] initWithData:responseBody encoding:NSUTF8StringEncoding];
        NSLog(@"%@", htmlString);
        if (!error || !*error)
            result = [NSJSONSerialization JSONObjectWithData:responseBody options:NSJSONReadingAllowFragments error:error];
        if (!result) {
            [self.webView.window makeKeyAndOrderFront:self];
            [[self.webView mainFrame] loadHTMLString:htmlString baseURL:self.playerEndpoint];
        }
    }
    return result;
}

- (NSDictionary *)GETRequest:(NSURL *)url error:(NSError **)error
{
    NSDictionary *result;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    if (!error || !*error)
        result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:error];
    return result;
}

- (NSDictionary *)getOpenIDConfiguration
{
    return [self GETRequest:self.discoveryDocumentUrl error:nil];
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
    NSDictionary *videoDetailsDict = [self POSTRequest:self.playerEndpoint WithBody:body error:&error];
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

- (NSDictionary *)getBrowseEndpoint:(NSString *)browseId
{
    NSDictionary *body = @{
                           @"browseId": browseId,
                           @"context": self.clientContext
                           };
    return [self POSTRequest:self.browseEndpoint WithBody:body error:nil];
}

- (NSDictionary *)getHome
{
    return [self getBrowseEndpoint:@"FEwhat_to_watch"];
}

- (NSArray *)getTrendingVideos
{
    NSDictionary *body = @{
                           @"browseId": @"FEtrending",
                           @"context": self.clientContext
                           };
    NSError *error;
    NSDictionary *response = [self POSTRequest:self.browseEndpoint WithBody:body error:&error];
    if (error) NSLog(@"%@", error.localizedDescription);
    NSLog(@"%@", response.description);
}

- (void)logIn
{
    NSString *endpoint = @"https://accounts.google.com/ServiceLogin?service=youtube";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    [self.webView.window makeKeyAndOrderFront:self];
    [[self.webView mainFrame] loadRequest:request];
    [self.webView frameLoadDelegate];
}

- (NSString *)getCookies
{
//    NSString *cookieString = @"";

    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:@"https://www.youtube.com"]];
    self.cookieArray = cookies;
    NSMutableArray *cookieStrings = [NSMutableArray arrayWithCapacity:cookies.count];
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"%1@ value: %2@", cookie.name, cookie.value);
        [cookieStrings addObject:[NSString stringWithFormat:@"%1@=%2@", cookie.name, cookie.value]];
    }
    NSString *cookieString = [cookieStrings componentsJoinedByString:@"; "];
    return cookieString;
}

- (void)getBearer
{
    NSString *authApi = @"https://oauth2.googleapis.com/device/code";
    NSDictionary *data = @{ @"client_id": self.clientId, @"scope": @"https://www.googleapis.com/auth/youtube" };
    NSDictionary *response = [self POSTRequest:[NSURL URLWithString:authApi] WithBody:data error:nil];
    NSString *verificationUrl = [response objectForKey:@"verification_url"];
    NSString *userCode = [response objectForKey:@"user_code"];
    NSLog(@"%1@, %2@", verificationUrl, userCode);
}

+ (LYouTubeClient *)client
{
    return [[LYouTubeClient alloc] init];
}

@end
