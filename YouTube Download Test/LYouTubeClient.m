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
        self.endPoint = [NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/player"];
        self.clientDetails = @{
                               @"context": @{
                                       @"client": @{
                                               @"clientName": @"MWEB",
                                               @"clientVersion": @"2.20220918",
                                               }
                                       },
                               @"videoId": @"",
                               @"contentCheckOk": @"true",
                               @"racyCheckOk": @"true"
                               };
    }
    return self;
}



- (LYouTubeVideo *)getVideoWithId:(NSString *)videoId
{
    self.masterVideo = [LYouTubeVideo videoWithId:videoId];
    
    return self.masterVideo;
}///Users/Lasse/Documents/Projects/YouTube Download Test/YouTube Download Test/LYouTubeClient.h

+ (LYouTubeClient *)client
{
    return [[LYouTubeClient alloc] init];
}

@end

@implementation LYClientDetails



@end
