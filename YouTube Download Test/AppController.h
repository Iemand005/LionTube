//
//  AppController.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 9/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LYouTubeVideo.h"

@interface AppController : NSObject

@property IBOutlet NSArrayController *videoListController;
@property IBOutlet NSObjectController *videoChannelController;
@property IBOutlet NSObjectController *videoPlayerController;

@property (strong) NSMutableArray *videos;
@property (strong) LYouTubeVideo *video;

@end
