//
//  AppDelegate.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/player?key=AIzaSyA8eiZmM1FaDVjRy-df2KTyQ_vz_yYM39w"]];
    
//    NSDictionary *dictionary = @{@"videoId": @"{{videoId}}",
//                                 @"context": @{
//                                     @"client": @{
//                                         @"clientName": @"ANDROID_TESTSUITE",
//                                         @"clientVersion": @"1.9",
//                                         @"androidSdkVersion": @30,
//                                         @"hl": @"en",
//                                         @"gl": @"US",
//                                         @"utcOffsetMinutes": @0
//                                     }
//                                     }};
    NSDictionary *dictionary2 = @{
        @"videoId": @"yIVRs6YSbOM",
        @"context": @{
            @"client": @{
                @"clientName": @"TVHTML5_SIMPLY_EMBEDDED_PLAYER",
                @"clientVersion": @"2.0",
                @"hl": @"en",
                @"gl": @"US",
                @"utcOffsetMinutes": @0
            },
            @"thirdParty": @{
                @"embedUrl": @"https://www.youtube.com"
            }
        },
        @"playbackContext": @{
            @"contentPlaybackContext": @{
                @"signatureTimestamp": @19369
            }
        }
    };
    
    NSDictionary *dictionary = @{@"context": @{@"client": @{@"clientName": @"IOS", @"clientVersion": @"17.33.2" }}, @"videoId": @"qcH2wgRLiV8", @"params": @"CgIQBg==", @"playbackContext": @{@"contentPlaybackContext": @{@"html5Preference": @"HTML5_PREF_WANTS"}}, @"contentCheckOk": @"true", @"racyCheckOk": @"true"};

    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request addValue:[NSString stringWithFormat:@"%li", data.length] forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"com.google.android.youtube/17.36.4 (Linux; U; Android 12; GB) gzip" forHTTPHeaderField:@"User-Agent"];
    [request addValue:@"www.youtube.com" forHTTPHeaderField:@"Host"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    
    NSString *rescont = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(rescont);
    // Insert code here to initialize your application
}

@end
