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
        self.clientName = @"MWEB";
        self.clientVersion = @"2.20220918";
    }
    return self;
}

+ (LYouTubeClient *)client
{
    return [[LYouTubeClient alloc] init];
}

@end
