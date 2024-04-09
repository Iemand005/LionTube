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
        
        self.credentialFile = @"auth.plist";
        
        self.clientName = @"MWEB";
        self.clientVersion = @"2.20220918";
        
        self.clientId = @"861556708454-d6dlm3lh05idd8npek18k6be8ba3oc68.apps.googleusercontent.com";
        self.clientSecret = @"SboVhoG9s0rNafixCSGGKXAT";
        
        self.discoveryDocumentUrl = [NSURL URLWithString:@"https://accounts.google.com/.well-known/openid-configuration"];
        
        NSDictionary *openIDConfig = [self getOpenIDConfiguration];
        self.deviceAuthorizationEndpoint = [NSURL URLWithString:[openIDConfig objectForKey:@"device_authorization_endpoint"]];
        self.tokenEndpoint = [NSURL URLWithString:[openIDConfig objectForKey:@"token_endpoint"]];
        
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
        NSString *authHeader = [self getAccessTokenHeader];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:requestBody];
        [request addValue:[NSString stringWithFormat:@"%li", requestBody.length] forHTTPHeaderField:@"Content-Length"];
        [request addValue:@"com.lasse.macos.youtube/1.0.0 (Darwin; U; Mac OS X 10.7; GB) gzip" forHTTPHeaderField:@"User-Agent"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:authHeader forHTTPHeaderField:@"Authorization"];
        
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

- (NSDictionary *)POSTRequestURLString:(NSString *)urlString WithBody:(NSDictionary *)body error:(NSError **)error
{
    return [self POSTRequest:[NSURL URLWithString:urlString] WithBody:body error:error];
}

- (NSDictionary *)GETRequest:(NSURL *)url error:(NSError **)error
{
    NSDictionary *result;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    if (!error && responseData)
        result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:error];
    if (!result) NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
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

- (NSString *)getCookies
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:@"https://www.youtube.com"]];
    self.cookieArray = cookies;
    NSMutableArray *cookieStrings = [NSMutableArray arrayWithCapacity:cookies.count];
    for (NSHTTPCookie *cookie in cookies) [cookieStrings addObject:[NSString stringWithFormat:@"%1@=%2@", cookie.name, cookie.value]];
    return [cookieStrings componentsJoinedByString:@"; "];
}

- (NSDictionary *)getBearerAuthCode
{
    NSDictionary *requestBody = @{ @"client_id": self.clientId, @"scope": @"https://www.googleapis.com/auth/youtube" };
    NSDictionary *responseBody = [self POSTRequest:self.deviceAuthorizationEndpoint WithBody:requestBody error:nil];
    self.deviceCode = [responseBody objectForKey:@"device_code"];
    return responseBody;
}

- (NSDictionary *)getBearerToken
{
    NSDictionary *tokenBody;
    self.tokenCreatedOn = [NSDate date];
    NSDictionary *data = @{
                           @"client_id": self.clientId,
                           @"client_secret": self.clientSecret,
                           @"device_code": self.deviceCode,
                           @"grant_type": @"urn:ietf:params:oauth:grant-type:device_code"
                           };
    if (self.clientId && self.clientSecret && self.deviceCode) {
        tokenBody = [self POSTRequest:self.tokenEndpoint WithBody:data error:nil];
//        self.accessToken = [tokenBody objectForKey:@"access_token"];
//        self.refreshToken = [tokenBody objectForKey:@"refresh_token"];
//        self.tokenExpiresIn = [tokenBody objectForKey:@"expires_in"];
//        self.tokenType = [tokenBody objectForKey:@"token_type"];
//        [tokenCreatedOn ]
//        if ([self saveAuthCredentials: tokenBody] && [self loadAuthCredentials]);
        [self saveAuthCredentials: tokenBody];
        [self loadAuthCredentials];
    }
    return tokenBody;
}

- (NSString *)getAccessTokenHeader
{
    return [NSString stringWithFormat:@"%1@ %2@", self.tokenType, self.accessToken];
}

- (BOOL)loadAuthCredentials
{
    NSDictionary *tokenBody = [NSDictionary dictionaryWithContentsOfFile:self.credentialFile];
    if (tokenBody) {
        self.accessToken = [tokenBody objectForKey:@"access_token"];
        self.refreshToken = [tokenBody objectForKey:@"refresh_token"];
        self.tokenExpiresIn = [tokenBody objectForKey:@"expires_in"];
        self.tokenType = [tokenBody objectForKey:@"token_type"];
//        self.accessToken = [tokenBody objectForKey:@"accessToken"];
//        self.refreshToken = [tokenBody objectForKey:@"refreshToken"];
//        self.tokenExpiresIn = [tokenBody objectForKey:@"expiresIn"];
//        self.tokenType = [tokenBody objectForKey:@"tokenType"];
    }
    return self.accessToken && self.tokenType;
}

- (BOOL)saveAuthCredentials:(NSDictionary *)credentials
{
    //NSDictionary *credStore = [NSDictionary dictionaryWithContentsOfFile:self.credentialFile];
    [credentials writeToFile:self.credentialFile atomically:YES];
}

+ (LYouTubeClient *)client
{
    return [[LYouTubeClient alloc] init];
}

@end
