//
//  LYouTubeVideo.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYouTubeVideo.h"

@implementation LYouTubeVideo

- (id)initWithId:(NSString *)videoId
{
    self = [super init];
    if (self) {
        self.videoId = videoId;
    }
    return self;
}

+ (LYouTubeVideo *)videoWithId:(NSString *)videoId
{
    return [[LYouTubeVideo alloc] initWithId:videoId];
}

@end
