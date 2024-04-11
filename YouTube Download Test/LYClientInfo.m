//
//  LYClientInfo.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 11/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYClientInfo.h"

@implementation LYClientInfo

-(id)init
{
    self = [super init];
    if (self) {
        self.name = @"MWEB";
    }
    return self;
}

-(NSString *)description
{
    return self.name;
}

@end
