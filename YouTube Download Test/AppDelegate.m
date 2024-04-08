//
//  AppDelegate.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //[self.drawer open];
    self.client = [LYouTubeClient client];
}

- (void)loadVideoWithId:(NSString *)videoId
{
    self.video = [LYouTubeVideo videoWithId:videoId];
    [self.video requestVideoWithClient:self.client];
    
    [self.videoDescription setStringValue:self.video.description];
    
    for (LVideoFormat *format in self.video.formats)
        [self.formatTable addFormat:format];
    
    LVideoFormat *format = [self.video.formats objectAtIndex:0];
    
    self.movie = [self.video getMovieWithFormat:format];
    [[self movieView] setMovie:self.movie];
    [self.movieView play:nil];
}

- (IBAction)search:(id)sender
{
    NSSearchField *field = sender;
    NSString *maybe = [[field cell] stringValue];
    [self loadVideoWithId:maybe];
}

- (IBAction)trySelectedVideoFormat:(id)sender
{
    NSUInteger index = self.formatTableView.selectedRow;
    LVideoFormat *format = [self.video.formats objectAtIndex:index];
    self.movie = [self.video getMovieWithFormat:format];
    [[self movieView] setMovie:self.movie];
}

//- en
- (IBAction)Ikhaatou:(id)sender
{
    [self.movieView enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
}

- (IBAction)stardt
{
    [self.movieView enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
}

- (IBAction)startPictureInPictureMode:(id)sender
{
    [self.PiPPanel makeKeyAndOrderFront:self];
    NSInteger titleBarHeight = self.PiPPanel.frame.size.height - ((NSView *)self.PiPPanel.contentView).frame.size.height;
    [self.PiPPanel setAspectRatio:NSMakeSize(256, 144 + (self.PiPPanel.frame.size.height - ((NSView *)self.PiPPanel.contentView).frame.size.height))];
    NSView *q = self.PiPPanel.contentView;
    NSLog(@"%f end inner %f", self.PiPPanel.frame.size.height, q.frame.size.height);
    [self.movieView setMovie:nil];
    LVideoFormat *format = [self.video.formats objectAtIndex:0];
    self.movie = [self.video getMovieWithFormat:format];
    [self.pipMovieView setMovie:[[QTMovie alloc] initWithFile:@"/Users/Lasse/Desktop/Tet-1.mp4" error:nil]];
}

@end
