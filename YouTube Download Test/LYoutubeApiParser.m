//
//  LYoutubeApiParser.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYoutubeApiParser.h"

@implementation LYoutubeApiParser

+ (NSURL *)getLoginURLFromBody:(NSDictionary *)body
{
    NSDictionary *header = [body objectForKey:@"overlay"];
    NSDictionary *consentBumpV2Renderer = [header objectForKey:@"consentBumpV2Renderer"];
    NSDictionary *signInButton = [consentBumpV2Renderer objectForKey:@"signInButton"];
    
}

@end
