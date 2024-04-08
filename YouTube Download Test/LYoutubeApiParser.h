//
//  LYoutubeApiParser.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYoutubeApiParser : NSObject

+ (NSURL *)getLoginURLFromBody:(NSDictionary *)body;

@end
