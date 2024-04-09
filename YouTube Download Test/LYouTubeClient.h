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

@property NSString *cookieString;
@property NSArray *cookieArray;

@property NSDictionary *clientContext;

@property NSString *clientName;
@property NSString *clientVersion;
@property NSString *deviceCode;

@property NSString *accessToken;
@property NSString *refreshToken;
@property NSString *tokenExpiresIn;

@property NSString *clientId;
@property NSString *clientSecret;

@property NSString *pageTitle;

@property IBOutlet WebView *webView;

- (NSDictionary *)POSTRequest:(NSURL *)url WithBody:(NSDictionary *)body error:(NSError **)error;
- (LYouTubeVideo *)getVideoWithId:(NSString *)videoId;
- (NSDictionary *)getBrowseEndpoint:(NSString *)browseId;
- (NSDictionary *)getHome;
- (NSArray *)getTrendingVideos;

- (void)logIn;
- (NSDictionary *)getBearerAuthCode;
- (BOOL)getBearerToken;

+ (LYouTubeClient *)client;

@end
