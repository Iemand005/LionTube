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
//    [self.client logIn];
//    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    //[cookieStorage cookie]
//    NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:@"https://www.youtube.com"]];
//    for (NSHTTPCookie *cookie in cookies) {
//        NSLog(@"%1@ value: %2@", cookie.name, cookie.value);
//    }
//    [self.client getHome];
    [self.client getBearer];
    //[self.drawer open];
    //self.client = [LYouTubeClient client];
}

- (void)logIn
{
    self.authPanel
    []
}

- (void)loadVideoWithId:(NSString *)videoId
{
    self.video = [self.client getVideoWithId:videoId];
//    [self.video requestVideoWithClient:self.client];
    
    [self.videoDescription setStringValue:self.video.description];
    [self.videoTitle setStringValue:self.video.title];
    
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
//
//- will
//
////- en
//- (IBAction)Ikhaatou:(id)sender
//{
//    [self.movieView enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
//}

- (IBAction)stardt
{
    [self.movieView enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
}

- (IBAction)startPictureInPictureMode:(id)sender
{
//    self set
//    [self.PiPPanel setMiniwindowImage:<#(NSImage *)#>] for thumbnail
    [self.PiPPanel setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [self.PiPPanel makeKeyAndOrderFront:self];
//    [self.PiPPanel setContentView:self.movieView];
//    [self.videoParentView seth]
//    self.videoParentView setas
//    NSInteger titleBarHeight = self.PiPPanel.frame.size.height - ((NSView *)self.PiPPanel.contentView).frame.size.height;
    [self.PiPPanel setAspectRatio:NSMakeSize(16, 9)];
    //[self.movieView setMovie:nil];
    //LVideoFormat *format = [self.video.formats objectAtIndex:0];
    //self.movie = [self.video getMovieWithFormat:format];
    //QTMovie *movie = [[QTMovie alloc] initWithFile:@"/Users/Lasse/Desktop/Tet-1.mp4" error:nil];
    [self.movieView setMovie:nil];
    
//    [self.movieView seti]
    [self.pipMovieView setMovie:self.movie];
//    [movie play];
}

@end
