//
//  LYCollectionView.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 9/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYCollectionView.h"

@implementation LYCollectionView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent
{
//    self.view
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"clicked!");
    NSCollectionView *collectionView = (NSCollectionView *)[self superview];
    NSInteger index = [[collectionView subviews]  indexOfObject:self];
    LYouTubeVideo *video = [[collectionView content] objectAtIndex:index];
    NSLog(@"%@", video.title);
//    NSLog(@"%@", theEvent.mouseLocation);
}

@end
