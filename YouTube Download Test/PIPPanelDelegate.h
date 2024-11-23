//
//  PIPPanelDelegate.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>

@class AppDelegate;

@interface PIPPanelDelegate : NSObject <NSWindowDelegate>

@property (assign) IBOutlet NSPanel *panel;
@property IBOutlet QTMovieView *movieView;
@property IBOutlet QTMovieView *pipMovieView;
@property IBOutlet AppDelegate *appDelegate;

@end