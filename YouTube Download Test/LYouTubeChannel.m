//
//  LYouTubeChannel.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 9/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYouTubeChannel.h"

@implementation LYouTubeChannel

- (void)setThumbnailWithURL:(NSURL *)url
{
    self.thumbnailUrl = url;
    self.thumbnail = [[NSImage alloc] initByReferencingURL:url];
}

+ (LYouTubeChannel *)channel
{
    return [[LYouTubeChannel alloc] init];
}

@end
