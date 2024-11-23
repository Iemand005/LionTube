//
//  LYouTubeProfile.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 10/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYouTubeProfile : NSObject

@property NSString *name;
@property NSString *givenName;
@property NSString *familyName;
@property NSLocale *locale;
@property NSString *sub;

@property NSURL *pictureUrl;
@property NSImage *picture;

+ (LYouTubeProfile *)profile;

@end
