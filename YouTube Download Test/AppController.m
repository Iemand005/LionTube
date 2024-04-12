//
//  AppController.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 9/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "AppController.h"

@implementation AppController

- (void)awakeFromNib
{
    self.videos = [NSMutableArray array];
    LYouTubeVideo *video = [LYouTubeVideo video];
    video.title = @"boobies";
    [self.videoPlayerController setContent:video];
}


@end
