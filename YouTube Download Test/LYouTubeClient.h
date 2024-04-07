//
//  LYClient.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYouTubeVideo.h"

@interface LYouTubeClient : NSObject

@property NSURL *endPoint;
@property NSDictionary *clientDetails;

@property NSString *clientName;
@property NSString *clientVersion;

+ (LYouTubeClient *)client;

@end
