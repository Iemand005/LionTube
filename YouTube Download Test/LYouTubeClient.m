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
        
//        id a = @[@(NO)];
        self.prettyPrint = NO;
        
        self.credentialFile = @"auth.plist";
        
        self.name = @"MWEB";
        self.version = @"2.20220918";
        self.browser = @"Firefox";
        self.browserVersion = @"10000";
        self.player = @"";
//        self.version = @"5";
        self.operatingSystem = @"Mac OS X";
        self.operatingSystemVersion = @"10.7";
        self.platform = @"MacOS";
        
        self.key = @"AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8"; // Everyone has the same key, the key isn't even required.
        
        self.clientId = @"861556708454-d6dlm3lh05idd8npek18k6be8ba3oc68.apps.googleusercontent.com";
        self.clientSecret = @"SboVhoG9s0rNafixCSGGKXAT";
        
        self.scope = @"https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/userinfo.profile";
        
        self.discoveryDocumentUrl = [NSURL URLWithString:@"https://accounts.google.com/.well-known/openid-configuration"];
        
        NSDictionary *openIDConfig = [self getOpenIDConfiguration];
        self.deviceAuthorizationEndpoint = [NSURL URLWithString:[openIDConfig objectForKey:@"device_authorization_endpoint"]];
        self.tokenEndpoint = [NSURL URLWithString:[openIDConfig objectForKey:@"token_endpoint"]];
        self.userInfoEndpoint = [NSURL URLWithString:[openIDConfig objectForKey:@"userinfo_endpoint"]];
        
        self.locale = [NSLocale systemLocale];
        self.context = @{@"client": @{@"clientName": self.name, @"clientVersion": self.version, @"hl": self.hostLanguage, @"gl": self.gLanguage}, @"user":@{}};
        
        self.baseAddress = [NSURL URLWithString:@"https://www.youtube.com/youtubei/v1"];
        self.alternativeBaseAddress = [NSURL URLWithString:@"https://youtubei.googleapis.com/youtubei/v1"];
        self.musicBaseAddress = [NSURL URLWithString:@"https://music.youtube.com/youtubei/v1"];
        self.playerEndpoint = [self.baseAddress URLByAppendingPathComponent:@"player"];
        self.nextEndpoint = [self.baseAddress URLByAppendingPathComponent:@"next"];
        self.browseEndpoint = [self.baseAddress URLByAppendingPathComponent:@"browse"];
        self.searchEndpoint = [self.baseAddress URLByAppendingPathComponent:@"search"];
        self.likeEndpoint = [self.baseAddress URLByAppendingPathComponent:@"like"];
        self.likeLikeEndpoint = [self.likeEndpoint URLByAppendingPathComponent:@"like"];
        self.likeDislikeEndpoint = [self.likeEndpoint URLByAppendingPathComponent:@"dislike"];
        self.likeRemoveLikeEndpoint = [self.likeEndpoint URLByAppendingPathComponent:@"removelike"];
        self.accountEndpoint = [self.baseAddress URLByAppendingPathComponent:@"account"];
        self.accountAccountMenuEndpoint = [self.accountEndpoint URLByAppendingPathComponent:@"account_menu"];
        self.commentEndpoint = [self.baseAddress URLByAppendingPathComponent:@"comment"];
        self.commentCreateCommentEndpoint = [self.commentEndpoint URLByAppendingPathComponent:@"create_comment"];
        self.commentUpdateCommentEndpoint = [self.commentEndpoint URLByAppendingPathComponent:@"update_comment"];
        self.commentPerformCommentActionEndpoint = [self.commentEndpoint URLByAppendingPathComponent:@"perform_comment_action"];
        
//        self.locale = [NSLocale systemLocale];
        
        self.credentialLogPath = @"authlog.plist";
        self.logAuthCredentials = YES;
        
        self.parser = [LYAPIParser parser];
    }
    return self;
}

- (NSString *)hostLanguage
{
    return [self languageCodeFromLocaleIdentifier:self.locale.localeIdentifier];
}

- (NSString *)gLanguage
{
    return [self countryCodeFromLocaleIdentifier:self.locale.localeIdentifier];
}

- (NSArray *)componentsOfLocaleIdentifier:(NSString *)localeIdentifier
{
    NSArray *components = [localeIdentifier componentsSeparatedByString:@"_"];
//    if (components.count == 1) components = [localeIdentifier componentsSeparatedByString:@"-"];
    return components;
}

- (NSString *)languageCodeFromLocaleIdentifier:(NSString *)localeIdentifier
{
    NSString *languageCode = [[self componentsOfLocaleIdentifier:localeIdentifier] objectAtIndex:0];
    return ![languageCode isEqualToString:@""] ? languageCode : @"en";
}

- (NSString *)countryCodeFromLocaleIdentifier:(NSString *)localeIdentifier
{
    NSString *countryCode = [[self componentsOfLocaleIdentifier:localeIdentifier] lastObject];
    return ![countryCode isEqualToString:@""] ? countryCode : @"US";
}

- (NSDictionary *)POSTRequest:(NSURL *)url withBody:(NSDictionary *)body error:(NSError **)error
{
    NSDictionary *result;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:error];
    
         NSLog(@"%@", [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding]);
    if (url && (!error || !*error)) {
        NSDictionary *optionalParameters = @{@"key":self.key, @"prettyPrint": (self.prettyPrint ? @"true" : @"false")}; // Key is optional and pretty print disabled is faster.
        url = [self.parser addParameters:optionalParameters toURL:url];
        NSLog(@"%@", url);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:requestData];
        [request addValue:[NSString stringWithFormat:@"%li", requestData.length] forHTTPHeaderField:@"Content-Length"];
        [request addValue:@"com.lasse.macos.youtube/1.0.0 (Darwin; U; Mac OS X 10.7; GB) gzip" forHTTPHeaderField:@"User-Agent"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        if (self.accessToken) [request addValue:[self getAccessTokenHeader] forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *response;
        NSData *responseBody = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];

        NSString *htmlString = [[NSString alloc] initWithData:responseBody encoding:NSUTF8StringEncoding];
        NSLog(@"%@", htmlString);
        if (responseBody && (!error || !*error))
            result = [NSJSONSerialization JSONObjectWithData:responseBody options:NSJSONReadingAllowFragments error:error];
        if (!result) {
            //*==
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView.window makeKeyAndOrderFront:self];
            [[self.webView mainFrame] loadHTMLString:htmlString baseURL:self.playerEndpoint];
            });
        }
    }
    return result;
}

- (NSDictionary *)POSTRequest:(NSURL *)url
{
    return [self POSTRequest:url withBody:@{} error:nil];
}

- (NSDictionary *)POSTRequest:(NSURL *)url withBody:(NSDictionary *)body
{
    return [self POSTRequest:url withBody:body error:nil];
}

- (NSDictionary *)POSTRequestURLString:(NSString *)urlString WithBody:(NSDictionary *)body error:(NSError **)error
{
    return [self POSTRequest:[NSURL URLWithString:urlString] withBody:body error:error];
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
    LYouTubeVideo *video = [LYouTubeVideo videoWithId:videoId];
    NSLog(@"%1@, %2@, %3@", self.name, self.version, videoId);
    NSDictionary *body = @{@"context": self.context, @"videoId": videoId, @"contentCheckOk": @"true", @"racyCheckOk": @"true"};
    
    NSError *error;
    NSDictionary *videoInfo = [self POSTRequest:self.nextEndpoint withBody:body error:&error];
    [self.parser addVideoData:videoInfo toVideo:video];
    NSDictionary *videoDetailsDict = [self POSTRequest:self.playerEndpoint withBody:body error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    [self.parser addVideoData:videoDetailsDict toVideo:video];
     
    return video;
}

- (NSDictionary *)getBrowseEndpoint:(NSString *)browseId
{
    NSDictionary *body = @{@"browseId": browseId, @"context": self.context};
    return [self POSTRequest:self.browseEndpoint withBody:body error:nil];
}

- (NSDictionary *)getBrowseEndpointWithContinuation:(LYContinuation *)continuation
{
    NSDictionary *body = @{@"context": self.context, @"continuation": continuation.token};
    return [self POSTRequest:self.browseEndpoint withBody:body error:nil];
}

- (NSArray *)getHome
{
//    NSString *browseId = self.isLoggedIn ? @"FEwhat_to_watch" : @"FEtrending";
    return [self isLoggedIn] ? [self getWhatToWatchVideos] : [self getTrendingVideos];
//    NSDictionary *data = [self getBrowseEndpoint:self.isLoggedIn ? @"FEwhat_to_watch" : @"FEtrending"];
//    return [self.parser parseVideosOnHomePage:data];
}

- (NSArray *)getWhatToWatchVideos
{
    return [self getVideosOnPage:@"FEwhat_to_watch"];
}

- (NSArray *)getTrendingVideos
{
    return [self getVideosOnPage:@"FEtrending"];
}

- (NSArray *)getVideosOnPage:(NSString *)page
{
    NSDictionary *data = [self getBrowseEndpoint:page];
    return [self.parser parseVideosOnHomePage:data];
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
    NSDictionary *requestBody = @{@"client_id": self.clientId, @"scope": self.scope};
    NSDictionary *responseBody = [self POSTRequest:self.deviceAuthorizationEndpoint withBody:requestBody error:nil];
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
        tokenBody = [self POSTRequest:self.tokenEndpoint withBody:data error:nil];
        [self saveAuthCredentials: tokenBody];
    }
    return tokenBody;
}

- (NSString *)getAccessTokenHeader
{
    return [NSString stringWithFormat:@"%1@ %2@", self.tokenType, self.accessToken];
}

- (id)requestContinuation:(LYContinuation *)continuation
{
    id result;
    NSURL *endpoint;
    if ([continuation.request isEqualToString:LYContinuationRequestTypeBrowse]) endpoint = self.browseEndpoint;
    NSDictionary *dat = @{@"context": self.context, @"continuation": continuation.token};//@{@"request": continuation.request, @"token": continuation.token};
    NSLog(@"%@", dat);
    if (endpoint) result = [self POSTRequest:endpoint withBody:dat];
    return result;
}

- (NSArray *)getHomeWithContinuation:(LYContinuation *)continuation
{
    return [self.parser parseVideosOnHomePage:[self requestContinuation:continuation]];
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
        authenticated = [self saveAuthCredentials:[self POSTRequest:self.tokenEndpoint withBody:data error:nil]];
    }// else credentials =
    if (authenticated) self.isLoggedIn = YES;
    return authenticated || self.isLoggedIn;
}
-(NSString *)description
{
    return self.name;
}

- (LYouTubeProfile *)getUserInfo
{
    NSDictionary *body = @{@"context": self.context};
    NSDictionary *userInfo = [self POSTRequest:self.accountAccountMenuEndpoint withBody:body];
    [userInfo writeToFile:@"user2.plist" atomically:YES];
    NSLog(@"%@, %@", body, userInfo);
    return [self.parser parseProfile:userInfo];
}

+ (LYouTubeClient *)client
{
    return [[LYouTubeClient alloc] init];
}

@end
