//
//  LYContinuation.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 12/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LYContinuationRequestTypeBrowse;

@interface LYContinuation : NSObject

@property NSString *request;
@property NSString *token;
@property NSDictionary *body;

+ (LYContinuation *)continuation;

@end
