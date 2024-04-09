//
//  LYouTubeChannel.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 9/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYouTubeChannel : NSObject

@property NSImage *thumbnail;
@property NSString *browseId;
@property NSString *name;
@property NSString *tag;

- (void)setThumbnailWithURL:(NSURL *)url;

+ (LYouTubeChannel *)channel;

@end
