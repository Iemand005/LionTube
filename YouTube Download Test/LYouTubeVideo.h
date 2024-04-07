//
//  LYouTubeVideo.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYouTubeVideo : NSObject

@property NSString *videoId;

- (id)initWithId:(NSString *)videoId;

+ (LYouTubeVideo *)videoWithId:(NSString *)videoId;

@end

enum audioQuality {
    AUDIO_QUALITY_LOW
};

enum projectionType {
    RECTANGULAR
};

enum quality {
    MEDIUM
};

struct videoFormat {
    int itag;
    char *url;
    char *mimeType;
    int bitrate;
    int width;
    int height;
    int lastModified;
    int contentLength;
    enum quality quality;
    int fps;
    char *qualityLabel;
    enum projectionType projectionType;
    int averageBitrate;
    enum audioQuality audioQuality;
    int approxDurationMs;
    int audioSampleRate;
    int audioChannels;
};
