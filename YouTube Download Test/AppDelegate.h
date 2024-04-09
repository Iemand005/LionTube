//
//  AppDelegate.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>
#import "LYouTubeClient.h"
#import "FormatTableDataSource.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSDrawer *drawer;
@property (assign) IBOutlet NSPanel *PiPPanel;
@property (assign) IBOutlet NSPanel *authPanel;
@property (assign) IBOutlet NSView *mainView;

@property (assign) IBOutlet NSView *homeView;
@property (assign) IBOutlet NSCollectionView *homeCollectionView;

@property IBOutlet NSSplitView *mainSplitView;
@property IBOutlet NSView *videoParentView;
@property NSInteger videoWidth;
@property NSInteger videoHeight;

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

@property IBOutlet NSTextField *authCodeURLField;
@property IBOutlet NSTextField *authCodeField;
@property IBOutlet NSProgressIndicator *authTimeIndicator;

@property NSTimer *authTimer;

@property IBOutlet FormatTableDataSource *formatTable;

@property IBOutlet LYouTubeClient *client;
@property LYouTubeVideo *video;

- (IBAction)search:(id)sender;
- (IBAction)logIn:(id)sender;
- (IBAction)trySelectedVideoFormat:(id)sender;

@end
