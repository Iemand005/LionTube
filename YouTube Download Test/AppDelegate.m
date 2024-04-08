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
    
    [[self movieView] setMovie:[self.video getMovieWithFormat:format]];
    [self.movieView play:nil];
}

- (IBAction)start:(id)sender
{
//    LYouTubeVideo *video = [LYouTubeVideo videoWithId:self.urlField.stringValue];
//    [video requestVideoWithClient:self.client];
//    
//    [self.videoDescription setStringValue:video.description];
//    
//    for (LVideoFormat *format in video.formats)
//        [self.formatTable addFormat:format];
//    
//    for (LVideoFormat *format in video.adaptiveFormats)
//        [self.formatTable addFormat:format];
//    
//    LVideoFormat *format = [video.formats objectAtIndex:0];
//    
//    self.video = video;
//    
//    [[self movieView] setMovie:[video getMovieWithFormat:format]];
//    //[self.movieView needsDisplay];
//    [self.movieView play:sender];
//    [self.movieView relo]
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
    [[self movieView] setMovie:[self.video getMovieWithFormat:format]];
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

@end
