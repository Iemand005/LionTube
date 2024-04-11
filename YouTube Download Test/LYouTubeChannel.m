//
//  LYouTubeChannel.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 9/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYouTubeChannel.h"

@implementation LYouTubeChannel

-(id)init
{
    self = [super init];
    if (self) {
        self.thumbnailUrl = [NSURL URLWithString:@""];
    }
    return self;
}

- (void)setThumbnailWithURL:(NSURL *)url
{
//    self.thumbnailUrl = url;
    NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    NSString *fileName = [url.pathComponents lastObject];
    [download setDestination:fileName allowOverwrite:NO];
    NSURL *kurl = [NSURL URLWithString:fileName];
    self.thumbnailUrl = kurl;
//    self.thumbnail = [[NSImage alloc] initByReferencingURL:url];
    
}

- (void)downloadDidFinish:(NSURLDownload *)download
{
//    [download fi]
    NSLog(@"Finished downloading channel thumbnail!");
}

+ (LYouTubeChannel *)channel
{
    return [[LYouTubeChannel alloc] init];
}

@end
