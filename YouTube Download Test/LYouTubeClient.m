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
        
        self.info.name = @"MWEB";
        self.info.version = @"2.20220918";
        
        self.clientId = @"861556708454-d6dlm3lh05idd8npek18k6be8ba3oc68.apps.googleusercontent.com";
        self.clientSecret = @"SboVhoG9s0rNafixCSGGKXAT";
        
        self.scope = @"https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/userinfo.profile";
        
        self.discoveryDocumentUrl = [NSURL URLWithString:@"https://accounts.google.com/.well-known/openid-configuration"];
        
        NSDictionary *openIDConfig = [self getOpenIDConfiguration];
        self.deviceAuthorizationEndpoint = [NSURL URLWithString:[openIDConfig objectForKey:@"device_authorization_endpoint"]];
        self.tokenEndpoint = [NSURL URLWithString:[openIDConfig objectForKey:@"token_endpoint"]];
        self.userInfoEndpoint = [NSURL URLWithString:[openIDConfig objectForKey:@"userinfo_endpoint"]];
        
        self.clientContext = @{
                               @"client": @{
                                       @"clientName": self.info.name,
                                       @"clientVersion": self.info.version
                                       }
                               };
        
        self.baseAddress = [NSURL URLWithString:@"https://www.youtube.com/youtubei/v1"];
        self.alternativeBaseAddress = [NSURL URLWithString:@"https://youtubei.googleapis.com/youtubei/v1"];
        self.playerEndpoint = [self.baseAddress URLByAppendingPathComponent:@"player"];
        self.nextEndpoint = [self.baseAddress URLByAppendingPathComponent:@"next"];
        self.browseEndpoint = [self.baseAddress URLByAppendingPathComponent:@"browse"];
        self.searchEndpoint = [self.baseAddress URLByAppendingPathComponent:@"search"];
        self.likeEndpoint = [self.baseAddress URLByAppendingPathComponent:@"like"];
        self.credentialLogPath = @"authlog.plist";
        self.logAuthCredentials = YES;
        
        self.parser = [LYAPIParser parser];
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
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        if (self.accessToken) [request addValue:[self getAccessTokenHeader] forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *response;
        NSData *responseBody = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];

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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if (self.accessToken)
        [request addValue:[self getAccessTokenHeader] forHTTPHeaderField:@"Authorization"];
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    //NSLog(@"%@", [*error localizedDescription]);
    NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
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
//    LYouTubeVideo *video = [LYouTubeVideo videoWithId:videoId];
    NSLog(@"%1@, %2@, %3@", self.info.name, self.info.version, videoId);
    NSDictionary *body = @{
                           @"context": self.clientContext,
                           @"videoId": videoId,
                           @"contentCheckOk": @"true",
                           @"racyCheckOk": @"true"
                           };
    
    NSError *error;
    NSDictionary *videoDetailsDict = [self POSTRequest:self.playerEndpoint WithBody:body error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    return [self.parser parseVideo:videoDetailsDict];
    
    
//    return video;
}

- (NSDictionary *)getBrowseEndpoint:(NSString *)browseId
{
    NSDictionary *body = @{
                           @"browseId": browseId,
                           @"context": self.clientContext
                           };
    return [self POSTRequest:self.browseEndpoint WithBody:body error:nil];
}

- (NSArray *)getHome
{
//    NSString *browseId = self.isLoggedIn ? @"FEwhat_to_watch" : @"FEtrending";
    NSDictionary *data = [self getBrowseEndpoint:self.isLoggedIn ? @"FEwhat_to_watch" : @"FEtrending"];
    return [self.parser parseVideosOnHomePage:data];
}

- (NSArray *)getTrendingVideos
{
//    NSString *browseId = self.isLoggedIn ? @"FEwhat_to_watch"
    NSDictionary *body = @{
                           @"browseId": @"FEtrending",
                           @"context": self.clientContext
                           };
    NSError *error;
    NSDictionary *response = [self POSTRequest:self.browseEndpoint WithBody:body error:&error];
    if (error) NSLog(@"%@", error.localizedDescription);
    NSLog(@"%@", response.description);
    return [self.parser parseVideosOnHomePage:response];
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
    NSDictionary *requestBody = @{ @"client_id": self.clientId, @"scope": self.scope };
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
        [self saveAuthCredentials: tokenBody];
    }
    return tokenBody;
}

- (NSString *)getAccessTokenHeader
{
    return [NSString stringWithFormat:@"%1@ %2@", self.tokenType, self.accessToken];
}

- (BOOL)loadAuthCredentials
{
    return [self applyAuthCredentials:[NSDictionary dictionaryWithContentsOfFile:self.credentialFile]];
}

- (BOOL)saveAuthCredentials:(NSDictionary *)credentials
{
    if (self.logAuthCredentials) {
        NSMutableArray *authLog = [NSMutableArray arrayWithContentsOfFile:self.credentialLogPath];
        [authLog addObject:credentials];
        [authLog writeToFile:self.credentialLogPath atomically:NO];
    }
    if ([self applyAuthCredentials:credentials]) [credentials writeToFile:self.credentialFile atomically:YES];
    return !!credentials;
}

- (BOOL)applyAuthCredentials:(NSDictionary *)credentials
{
    if (credentials) {
        self.accessToken = [credentials objectForKey:@"access_token"];
        self.refreshToken = [credentials objectForKey:@"refresh_token"];
        self.tokenExpiresIn = [credentials objectForKey:@"expires_in"];
        self.tokenType = [credentials objectForKey:@"token_type"];
    }
//    BOOL a = self.accessToken && self.refreshToken;
    return self.accessToken && self.refreshToken;//!self.isLoggedIn ? self.isLoggedIn = self.accessToken && self.refreshToken : YES;
}

- (BOOL)applyUserProfile
{
    self.profile = [self getUserInfo];
    return self.profile && self.profile.name;
}

- (void)saveUserProfilePicture:(NSString *)path
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.profile.pictureUrl];
    NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:request delegate:nil];
    [download setDestination:@"profile.jpg" allowOverwrite:YES];
}

- (BOOL)refreshAuthCredentials
{
//    NSDictionary *credentials;
    BOOL authenticated = NO;
    if ([self loadAuthCredentials]) {
        NSDictionary *data = @{
                               @"client_id": self.clientId,
                               @"client_secret": self.clientSecret,
                               @"grant_type": @"refresh_token",
                               @"refresh_token": self.refreshToken
                               };
        authenticated = [self saveAuthCredentials:[self POSTRequest:self.tokenEndpoint WithBody:data error:nil]];
    }// else credentials =
    if (authenticated) self.isLoggedIn = YES;
    return authenticated || self.isLoggedIn;
}

//-(NSString *)description
//{
//    return self.name;
//}

- (LYouTubeProfile *)getUserInfo
{
    NSDictionary *userInfo = [self GETRequest:self.userInfoEndpoint error:nil];
    [userInfo writeToFile:@"user.plist" atomically:YES];
    NSLog(@"%@", userInfo);
    return [self.parser parseProfile:userInfo];
}

+ (LYouTubeClient *)client
{
    return [[LYouTubeClient alloc] init];
}

@end
