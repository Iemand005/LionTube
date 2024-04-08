//
//  AppDelegate.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>
#import "LYouTubeClient.h"
#import "FormatTableDataSource.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property IBOutlet NSDrawer *drawer;

@property IBOutlet QTMovieView *movieView;
@property QTMovie *movie;

@property IBOutlet NSTextField *urlField;
@property IBOutlet NSTextField *descriptionField;
@property IBOutlet NSTableView *formatTableView;

@property IBOutlet FormatTableDataSource *formatTable;

@property LYouTubeClient *client;
@property LYouTubeVideo *video;

//- (IBAction)start;

//- (IBAction)startFullScreen;

- (IBAction)a:(id)sender;

- (IBAction)trySelectedVideoFormat:(id)sender;

@end
