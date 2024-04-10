//
//  LYTools.h
//  YouTube Lion Static Toolkit
//
//  Created by Lasse Lauwerys on 11/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYTools : NSObject

+ (NSDictionary *)dictionaryWithQueryFromURL:(NSURL *)url;
+ (NSURL *)addParameters:(NSDictionary *)parameters toURL:(NSURL *)url;
+ (NSString *)stringByRemovingQueryFromURL:(NSURL *)url;

@end
