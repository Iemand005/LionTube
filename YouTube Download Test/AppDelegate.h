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
@property (assign) IBOutlet NSDrawer *drawer;
@property (assign) IBOutlet NSPanel *PiPPanel;
@property (assign) IBOutlet NSView *mainView;

@property IBOutlet QTMovieView *movieView;
@property IBOutlet QTMovieView *pipMovieView;
@property QTMovie *movie;

@property IBOutlet NSTextField *urlField;
@property IBOutlet NSTextField *videoTitle;
@property IBOutlet NSTextField *videoDescription;
@property IBOutlet NSTextField *channelName;
@property IBOutlet NSImageView *channelPicture;
@property IBOutlet NSTableView *formatTableView;
//@property IBOutlet NSView *videoParentView;

@property IBOutlet FormatTableDataSource *formatTable;

@property IBOutlet LYouTubeClient *client;
@property LYouTubeVideo *video;

- (IBAction)Ikhaatou:(id)sender;

//- (IBAction)start;

//- (IBAction)startFullScreen;

//- (IBAction)a:(id)sender;
- (IBAction)search:(id)sender;

- (IBAction)trySelectedVideoFormat:(id)sender;

@end
