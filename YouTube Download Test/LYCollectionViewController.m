//
//  LYCollectionViewController.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 9/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYCollectionViewController.h"

@interface LYCollectionViewController ()

@end

@implementation LYCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"you farted on a thing! %@", theEvent);
}

@end
