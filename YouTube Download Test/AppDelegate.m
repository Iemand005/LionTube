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
    self.videoWidth = 16;
    self.videoHeight = 9;
    
//    id a = @[@"spartakruts", @"isgekraaktkwijtdekluts"];
//    NSString *varken = [a objectForKey:@1];
//    NSLog(varken);
    
    self.track = YES;
    
    [self.client setCredentialFile:@"auth.plist"];
    BOOL isAuthenticated = [self.client refreshAuthCredentials];
    if (isAuthenticated) {
        NSLog(@"Authenticated.");
//        [self loadHomePage];
        if ([self.client applyUserProfile]) {
            NSLog(@"%@", self.client.profile.pictureUrl);
            [self.client saveUserProfilePicture:@"profile.png"];
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:@"profile.jpg"];
            [self.toolbarProfileItem setImage:image];//self.client.profile.picture];
        }
    } else {
        NSLog(@"Token invalid");
//        [self loadTrendingPage];
    }
    [self loadHomePage];//:isAuthenticated];
}

- (IBAction)goHome:(id)sender
{
    [self.movieView pause:sender];
    [self loadView:self.homeView];
    [self loadHomePage];
}

- (IBAction)changeVideoLikedState:(id)sender
{
    
    NSSegmentedControl *control = sender;
    if (self.lastSelection != control.selectedSegment) {
        self.lastSelection = control.selectedSegment;
        if (control.selectedSegment == 0) [self.video like];
        else [self.video dislike];
    } else {
        self.lastSelection = -1;
        [control setSelectedSegment:-1];
        [self.video removeLike];
    }// else
}

//- (void)likeVideo
//{
//    NSLog(@"video liked");
//}
//
//- (void)dislikeVideo
//{
//    NSLog(@"video NOT liked");
//}
//
//- (void)removeVideoLike
//{
//    NSLog(@"video like delete");
//}

- (void)loadHomePage
{
    [self.homeSpinner startAnimation:self];
    [self.homeSpinner setIndeterminate:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSArray *videos = [self.client getHome]; //isAuthenticated ? [self.client getHome] : [self.client getTrendingVideos];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.homeSpinner setDoubleValue:0];
            [self.homeSpinner setMaxValue:videos.count];
            [self.homeSpinner setIndeterminate:NO];
            for (LYouTubeVideo *video in videos) {
                [self.controller.videoListController addObject:video];
                self.homeSpinner.doubleValue++;//`
            }
            [self.homeSpinner stopAnimation:self];
            [self.homeSpinner setIndeterminate:YES];
        });
    });
}

- (void)loadTrendingPage
{
    
}

- (void)loadView:(NSView *)view
{
    [self.window setContentView:view];
}

- (void)openVideoPageForVideoWithId:(NSString *)videoId
{
    [self.videoLoadingIndicator startAnimation:self];
    [self loadView:self.mainView];
    [self loadVideoWithId:videoId];
}

- (void)windowDidResize:(NSNotification *)notification
{
        if (!(self.videoWidth && self.videoHeight)) {
            self.videoWidth = 16;
            self.videoHeight = 9;
        }
    {
        double weirdMeow = self.videoParentView.frame.size.width / self.videoWidth * self.videoHeight;
        [self.mainSplitView setPosition:weirdMeow ofDividerAtIndex:0];
    }
}

- (IBAction)logIn:(id)sender
{
    [NSApp beginSheet:self.authPanel modalForWindow:self.window modalDelegate:self didEndSelector:nil contextInfo:nil];
    if (![self.client loadAuthCredentials])
        [self refreshAuthCode:sender];
}

- (IBAction)refreshAuthCode:(id)sender
{
    [self.authTimeIndicator setIndeterminate:YES];
    [self.authTimeIndicator startAnimation:sender];
    [self.authTimer invalidate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *bearerData = [self.client getBearerAuthCode];
        if (![bearerData objectForKey:@"error"]) {
            NSString *verificationUrl = [bearerData objectForKey:@"verification_url"];
            NSString *userCode = [bearerData objectForKey:@"user_code"];
            NSNumber *expiresIn = [bearerData objectForKey:@"expires_in"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.authCodeURLField setStringValue:verificationUrl];
                [self.authCodeField setStringValue:userCode];
                [self.authTimeIndicator setMaxValue:expiresIn.doubleValue+0.1f];
                [self.authTimeIndicator setDoubleValue:expiresIn.doubleValue];
                [self.authTimeIndicator setIndeterminate:NO];
                self.authTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(decrementAuthTimer) userInfo:nil repeats:YES];
            });
        } else [self handleAuthError:bearerData];
    });
}

- (void)decrementAuthTimer
{
    if (self.authTimeIndicator.doubleValue) self.authTimeIndicator.doubleValue--;
    else [self refreshAuthCode:self];
}

- (IBAction)authCodeCancel:(id)sender
{
    [self.authPanel orderOut:sender];
    [self.authTimer invalidate];
    [self.authTimeIndicator stopAnimation:sender];
}

- (IBAction)authCodeConfirm:(id)sender
{
    [self.authTimeIndicator setIndeterminate:YES];
    NSDictionary *bearerData = [self.client getBearerToken];
    if (![bearerData objectForKey:@"error"]) [self authCodeCancel:sender];
    else [self handleAuthError:bearerData];
}

- (IBAction)polltest:(id)sender
{
    [self.video.tracker updateWatchtime];
}

- (void)handleAuthError:(NSDictionary *)errorBody
{
    NSString *error = [errorBody objectForKey:@"error"];
    [self.authTimeIndicator setIndeterminate:NO];
    if ([error isEqualToString: @"authorization_pending"])
        [self shakeWindow:2 timesWithDuration:0.3f andVigurousity:0.05f];
    else if ([error isEqualToString: @"slow_down"])
        [self shakeWindow:4 timesWithDuration:0.6f andVigurousity:0.07f];
}

- (void)shakeWindow:(NSInteger)shakeCount timesWithDuration:(double)duration andVigurousity:(double)vigour
{
    CGRect frame = self.window.frame;
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
    
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
    for (NSInteger index = 0; index < shakeCount; index++){
        CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * vigour, NSMinY(frame));
        CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * vigour, NSMinY(frame));
    }
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = duration;
    
    [self.window setAnimations:[NSDictionary dictionaryWithObject: shakeAnimation forKey:@"frameOrigin"]];
    [self.window.animator setFrameOrigin:frame.origin];
}

- (void)loadVideoWithId:(NSString *)videoId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        LYouTubeVideo *video = [self.client getVideoWithId:videoId];
        dispatch_async(dispatch_get_main_queue(), ^{
            video.client = self.client;
            video.videoId = videoId;
            video.tracker.video = video;
//            video.movie = 
            self.video = video;
            self.controller.video = video;
            
            if (video.description) [self.videoDescription setStringValue:video.description];
            if (video.title) [self.videoTitle setStringValue:video.title];
            
//            video.movie
            
            LYVideoFormat *format = [self.video.formats objectAtIndex:0];
            
            self.movie = [self.video getMovieWithFormat:format];
            self.video.movie = self.movie;
            QTTime time = self.video.movie.currentTime;
            NSLog(@"%li, %li, %lli", time.flags, time.timeScale, time.timeValue);
            [[self movieView] setMovie:self.movie];
            [self.videoLoadingIndicator stopAnimation:self];
            [self.movieView play:self];
            [self startTracking];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:QTMovieRateDidChangeNotification object:nil];
            
//            [self.movie setRate:0.5];
            
            for (LYVideoFormat *format in self.video.formats) {
                [self.formatTable addFormat:format];
                NSLog(@"kanker %@",format.qualityLabel);
                if (format.qualityLabel) {
                    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[format.qualityLabel stringByAppendingFormat:@"%@", format.fps] action:@selector(changeVideoFormat:) keyEquivalent:@""];
                    [self.codecSelection addItem:item];
                }
            }
//            [self.movie au]
        });
    });
}

- (void)handleNotification:(NSNotification*)note {
    NSLog(@"Got notified: %@", note);
    if (self.track) {
        NSNumber *rate = [[note userInfo] objectForKey:QTMovieRateDidChangeNotificationParameter];
        if (rate.integerValue) {
            NSLog(@"the video s");
            [self.video play];
        } else [self.video pause];
    }
//    else
//     [self.movie setRate:0.5];
}

- (void)startTracking
{
    if (self.track) {
        NSInteger interval = 10;
        [self.video.tracker startTracking];
        [self setTrackingTimer:[NSTimer timerWithTimeInterval:interval target:self selector:@selector(updateTracker) userInfo:nil repeats:YES]];
        [[NSRunLoop currentRunLoop] addTimer:self.trackingTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)updateTracker
{
//    LYPlaybackTracker *tracker = self.video.tracker;
//    [tracker setv]
    [self.video updateTracker];
}

- (void)changeVideoFormat:(id)sender
{
    NSInteger index = [self.codecSelection indexOfItem:sender];
    [self loadVideoWithFormat:[self.video.formats objectAtIndex:index]];
}

- (void)loadVideoWithFormat:(LYVideoFormat *)format
{
    [self.videoLoadingIndicator startAnimation:self];
    self.movie = [self.video getMovieWithFormat:format];
    [[self movieView] setMovie:self.movie];
    [self.videoLoadingIndicator stopAnimation:self];
    [self.movieView play:self];
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
    LYVideoFormat *format = [self.video.formats objectAtIndex:index];
    self.movie = [self.video getMovieWithFormat:format];
    [[self movieView] setMovie:self.movie];
}

- (IBAction)setVideoRate:(id)sender
{
    NSSlider *slider = sender;
    [self.movie setRate:slider.floatValue];
}

- (IBAction)knex:(id)sender
{
    [self.movieView setFillColor:[NSColor blackColor]];
    [self.movieView enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
}

- (IBAction)startPictureInPictureMode:(id)sender
{
    [self.PiPPanel setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [self.PiPPanel makeKeyAndOrderFront:self];
    NSSize videoRatio = self.movieView.frame.size;
//    NSLog(@"%f",videoRatio.width, self.PiPPanel.frame.size.width);
//    [self.PiPPanel setAspectRatio:videoRatio];//NSMakeSize(16, 9)];
//    NSLog(@"%f, %f", self.movieView.frame.size.height, self.PiPPanel.frame.size.height);
//    CGRect ractal = self.PiPPanel.frame;
    [self.PiPPanel setContentAspectRatio:NSMakeSize(16, 9)];
    [self.movieView setVolumeButtonVisible:NO];
    [self.movieView setControllerVisible:NO];
//    self.movieView set
//    ractal.size.width = self.PiPPanel.con;
//    ractal.size.height = self.movieView.frame.size.height;
    
//    [self.PiPPanel setFrame:ractal display:YES animate:YES];
    [self.movieView setMovie:nil];
    [self.pipMovieView setMovie:self.movie];
}

@end
