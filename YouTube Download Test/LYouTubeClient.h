//
//  LYClient.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

#import "LYClientInfo.h"
#import "LYouTubeVideo.h"
#import "LYAPIParser.h"

@class LYAPIParser;

@interface LYouTubeClient : NSObject

@property NSURL *baseAddress;
@property NSURL *alternativeBaseAddress;
@property NSURL *playerEndpoint;
@property NSURL *browseEndpoint;
@property NSURL *nextEndpoint;
@property NSURL *likeEndpoint;
@property NSURL *likeLikeEndpoint;
@property NSURL *likeDislikeEndpoint;
@property NSURL *likeRemoveLikeEndpoint;
@property NSURL *searchEndpoint;
@property NSURL *discoveryDocumentUrl;
@property NSURL *deviceAuthorizationEndpoint;
@property NSURL *tokenEndpoint;
@property NSURL *userInfoEndpoint;
@property NSURL *accountAccountMenuEndpoint;

@property NSString *credentialFile;

@property NSString *cookieString;
@property NSArray *cookieArray;

@property NSDictionary *context;

@property NSString *deviceCode;

@property NSString *scope;

@property NSString *accessToken;
@property NSString *refreshToken;
@property NSNumber *tokenExpiresIn;
@property NSDate *tokenCreatedOn;
@property NSString *tokenType;

@property NSString *clientId;
@property NSString *clientSecret;

@property NSString *pageTitle;

@property NSString *name;
@property NSString *version;
@property NSString *browser;
@property NSString *browserVersion;
@property NSString *operatingSystem;
@property NSString *operatingSystemVersion;
@property NSString *platform;
@property NSString *player;

@property BOOL logAuthCredentials;
@property NSString *credentialLogPath;
@property NSArray *credentialLog;

@property BOOL isLoggedIn;

@property LYAPIParser *parser;

@property LYouTubeProfile *profile;

@property IBOutlet WebView *webView;

- (NSDictionary *)POSTRequest:(NSURL *)url withBody:(NSDictionary *)body error:(NSError **)error;
- (LYouTubeVideo *)getVideoWithId:(NSString *)videoId;
- (id)requestContinuation:(LYContinuation *)continuation;
- (NSDictionary *)getBrowseEndpoint:(NSString *)browseId;
- (NSArray *)getHome;
- (NSArray *)getHomeWithContinuation:(LYContinuation *)continuation;
- (NSArray *)getTrendingVideos;

- (NSDictionary *)getBearerAuthCode;
- (NSDictionary *)getBearerToken;

//- (NSDictionary *)loadAuthCredentials;
- (BOOL)loadAuthCredentials;
- (BOOL)saveAuthCredentials:(NSDictionary *)credentials;
- (BOOL)applyAuthCredentials:(NSDictionary *)credentials;
- (BOOL)refreshAuthCredentials;

//- (void)like;
//- (void)dislike;
//- (void)removeLike;

- (LYouTubeProfile *)getUserInfo;
- (BOOL)applyUserProfile;
- (void)saveUserProfilePicture:(NSString *)path;

+ (LYouTubeClient *)client;

@end
