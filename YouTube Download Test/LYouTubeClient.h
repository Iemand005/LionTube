//
//  LYClient.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

#import "LYouTubeVideo.h"
#import "LYoutubeApiParser.h"

@interface LYouTubeClient : NSObject

@property NSURL *baseAddress;
@property NSURL *alternativeBaseAddress;
@property NSURL *playerEndpoint;
@property NSURL *browseEndpoint;
@property NSURL *nextEndpoint;
@property NSURL *likeEndpoint;
@property NSURL *searchEndpoint;
@property NSURL *discoveryDocumentUrl;
@property NSURL *deviceAuthorizationEndpoint;
@property NSURL *tokenEndpoint;
@property NSURL *userInfoEndpoint;

@property NSString *credentialFile;

@property NSString *cookieString;
@property NSArray *cookieArray;

@property NSDictionary *clientContext;

@property NSString *clientName;
@property NSString *clientVersion;
@property NSString *deviceCode;

@property NSString *accessToken;
@property NSString *refreshToken;
@property NSNumber *tokenExpiresIn;
@property NSDate *tokenCreatedOn;
@property NSString *tokenType;

@property NSString *clientId;
@property NSString *clientSecret;

@property NSString *pageTitle;

@property BOOL logAuthCredentials;
@property NSString *credentialLogPath;
@property NSArray *credentialLog;

@property LYoutubeApiParser *parser;

@property IBOutlet WebView *webView;

- (NSDictionary *)POSTRequest:(NSURL *)url WithBody:(NSDictionary *)body error:(NSError **)error;
- (LYouTubeVideo *)getVideoWithId:(NSString *)videoId;
- (NSDictionary *)getBrowseEndpoint:(NSString *)browseId;
- (NSArray *)getHome;
- (NSArray *)getTrendingVideos;

- (NSDictionary *)getBearerAuthCode;
- (NSDictionary *)getBearerToken;

//- (NSDictionary *)loadAuthCredentials;
- (BOOL)loadAuthCredentials;
- (BOOL)saveAuthCredentials:(NSDictionary *)credentials;
- (BOOL)applyAuthCredentials:(NSDictionary *)credentials;
- (BOOL)refreshAuthCredentials;

- (void)getUserInfo;

+ (LYouTubeClient *)client;

@end
