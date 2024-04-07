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
{
//    NSError *error;
}

@property NSURL *endPoint;
@property NSDictionary *clientDetails;

@property NSString *clientName;
@property NSString *clientVersion;

@property LYouTubeVideo *masterVideo;

- (LYouTubeVideo *)getVideoWithId:(NSString *)videoId;

+ (LYouTubeClient *)client;

@end

@interface LYClientDetails : NSObject

@property context: @{
@"client": @{
@"clientName": @"MWEB",
@"clientVersion": @"2.20220918",
}
},
@"videoId": @"",
@"contentCheckOk": @"true",
@"racyCheckOk": @"true"
};

@end
