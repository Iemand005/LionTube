//
//  LYVideoFormat.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 10/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYVideoFormat : NSObject

@property NSNumber *itag;
@property NSString *url;
@property NSString *mimeType;
@property int bitrate;
@property NSNumber *width;
@property NSNumber *height;
@property int lastModified;
@property int contentLength;
@property NSString *quality;
@property NSNumber *fps;
@property NSString *qualityLabel;
@property NSString *projectionType;
@property int averageBitrate;
@property NSString *audioQuality;
@property int approxDurationMs;
@property int audioSampleRate;
@property int audioChannels;

- (id)initWithDictionary:(NSDictionary *)dict;

+ (LYVideoFormat *)formatWithDictionary:(NSDictionary *)dict;

@end
