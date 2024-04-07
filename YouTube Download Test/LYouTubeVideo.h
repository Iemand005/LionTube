//
//  LYouTubeVideo.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>
#import "LYouTubeClient.h"

enum audioQuality {
    AUDIO_QUALITY_LOW
};

enum projectionType {
    RECTANGULAR
};

enum quality {
    MEDIUM
};

@interface LVideoFormat : NSObject

@property int itag;
@property NSString *url;
@property NSString *mimeType;
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

@end

@interface LYouTubeVideo : NSObject

@property NSString *videoId;
@property NSArray *formats;
@property NSArray *adaptiveFormats;
@property NSString *description;
@property NSNumber *viewCount;

- (id)initWithId:(NSString *)videoId;

- (void)requestVideoWithClient:(LYouTubeClient *)client;

- (QTMovie *)getMovieWithFormat:(LVideoFormat *)format;
+ (LYouTubeVideo *)videoWithId:(NSString *)videoId;

@end
