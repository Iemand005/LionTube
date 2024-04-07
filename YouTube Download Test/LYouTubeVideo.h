//
//  LYouTubeVideo.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

enum audioQuality {
    AUDIO_QUALITY_LOW
};

enum projectionType {
    RECTANGULAR
};

enum quality {
    MEDIUM
};

@interface LYouTubeVideo : NSObject

@property NSString *videoId;

- (id)initWithId:(NSString *)videoId;

+ (LYouTubeVideo *)videoWithId:(NSString *)videoId;

@end

@interface LVideoFormat : NSObject

@property int itag;
@property NSString *url;
@property char *mimeType;
@property int bitrate;
@property int width;
@property int height;
@property int lastModified;
@property int contentLength;
@property enum quality quality;
@property NSNumber *fps;
@property char *qualityLabel;
@property enum projectionType projectionType;
@property int averageBitrate;
@property enum audioQuality audioQuality;
@property int approxDurationMs;
@property int audioSampleRate;
@property int audioChannels;

- (id)initWithDictionary:(NSDictionary *)dict;

+ (LVideoFormat *)formatWithDictionary:(NSDictionary *)dict;

@end// videoFormat;



//struct videoFormat {
//    int itag;
//    const char *url;
//    char *mimeType;
//    int bitrate;
//    int width;
//    int height;
//    int lastModified;
//    int contentLength;
//    enum quality quality;
//    short fps;
//    char *qualityLabel;
//    enum projectionType projectionType;
//    int averageBitrate;
//    enum audioQuality audioQuality;
//    int approxDurationMs;
//    int audioSampleRate;
//    int audioChannels;
//};
