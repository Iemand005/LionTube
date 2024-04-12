//
//  LYContinuation.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 12/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYContinuation.h"

NSString * const LYContinuationRequestTypeBrowse = @"CONTINUATION_REQUEST_TYPE_BROWSE";

@implementation LYContinuation

+ (LYContinuation *)continuation
{
    return [[LYContinuation alloc] init];
}

@end
