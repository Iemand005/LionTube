//
//  AppController.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 9/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "AppController.h"

@implementation AppController

-(void)awakeFromNib
{
    self.videos = [NSMutableArray array];
    LYouTubeVideo *video = [LYouTubeVideo videoWithId:@"fart"];
    video.title = @"sprat";
//    video.thu
    [self.videoListController addObject:video];
}

@end
