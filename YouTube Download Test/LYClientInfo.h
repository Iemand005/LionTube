//
//  LYClientInfo.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 11/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYClientInfo : NSObject

@property NSString *name;
@property NSString *version;
@property NSString *browser;
@property NSString *browserVersion;
@property NSString *operatingSystem;
@property NSString *operatingSystemVersion;
@property NSString *platform;
@property NSString *player;

@end
