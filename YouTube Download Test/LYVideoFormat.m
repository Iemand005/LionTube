//
//  LYVideoFormat.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 10/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYVideoFormat.h"

@implementation LYVideoFormat

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.url = [dict objectForKey:@"url"];
        self.fps = [dict objectForKey:@"fps"];
        self.width = [dict objectForKey:@"width"];
        self.height = [dict objectForKey:@"height"];
        self.mimeType = [dict objectForKey:@"mimeType"];
        self.qualityLabel = [dict objectForKey:@"qualityLabel"];
        NSLog([dict objectForKey:@"qualityLabel"]);
    }
    return self;
}

+ (LYVideoFormat *)formatWithDictionary:(NSDictionary *)dict
{
    return [[LYVideoFormat alloc] initWithDictionary:dict];
}

@end
