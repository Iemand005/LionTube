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

@property NSDictionary *clientContext;

@property NSString *clientName;
@property NSString *clientVersion;

@property IBOutlet WebView *webView;

- (LYouTubeVideo *)getVideoWithId:(NSString *)videoId;

+ (LYouTubeClient *)client;

@end
