//
//  LYTools.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 11/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYTools.h"

@implementation LYTools

+ (NSDictionary *)dictionaryWithQueryFromURL:(NSURL *)url
{
    NSString *query = url.query;
    NSArray *queryParameterStrings = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionaryWithCapacity:queryParameterStrings.count];
    for (NSString *queryParameterString in queryParameterStrings) {
        NSArray *queryParameterComponents = [queryParameterString componentsSeparatedByString:@"="];
        [queryParameters setObject:[queryParameterComponents objectAtIndex:1] forKey:[queryParameterComponents objectAtIndex:0]];
    }
    return queryParameters;
}

+ (NSURL *)addParameters:(NSDictionary *)parameters toURL:(NSURL *)url
{
    NSDictionary *oldParameters = [LYTools dictionaryWithQueryFromURL:url];
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:oldParameters];
    [newParams addEntriesFromDictionary:parameters];
    NSString *newUrlString = [LYTools stringByRemovingQueryFromURL:url];
    if (newParams.count) {
        newUrlString = [newUrlString stringByAppendingString:@"?"];
        [newParams enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop){
            [newUrlString stringByAppendingFormat:@"%@=%@", key, value];
        }];
    }
    return [NSURL URLWithString:newUrlString];
}

+ (NSString *)stringByRemovingQueryFromURL:(NSURL *)url
{
    return [[url.path componentsSeparatedByString:@"?"] objectAtIndex:0];
}

@end
