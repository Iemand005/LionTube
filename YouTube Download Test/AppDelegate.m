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
    self.lastSelection = -1;
    playerMode = -1;
    self.track = YES;
    
    NSLog(@"%@", self.client.hostLanguage);
    NSLocale *spratje = [NSLocale systemLocale];
    NSString *d = spratje.localeIdentifier;
        NSLog(@"%@", d);
    
    NSArray *q = [NSLocale preferredLanguages];
    spratje = [q objectAtIndex:0];
    NSLocale *knakker = [NSLocale currentLocale];
    NSLog(@"%@", knakker.localeIdentifier);
    
    [self.client setCredentialFile:@"auth.plist"];
    BOOL isAuthenticated = [self.client refreshAuthCredentials];
    if (isAuthenticated) {
        NSLog(@"Authenticated.");
        if ([self.client applyUserProfile]) {
            NSLog(@"%@", self.client.profile.pictureUrl);
            [self.client saveUserProfilePicture:@"profile.png"];
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:@"profile.jpg"];
            [self.toolbarProfileItem setImage:image];
        }
    } else {
        NSLog(@"Token invalid");
    }
    [self loadHomePage];
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

- (void)loadHomePage
{
    [self.homeSpinner startAnimation:self];
    [self.homeSpinner setIndeterminate:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSArray *videos = [self.client getHome];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.homeSpinner setDoubleValue:0];
            [self.homeSpinner setMaxValue:videos.count];
            [self.homeSpinner setIndeterminate:NO];
            for (id video in videos) {
                if ([video isMemberOfClass:[LYouTubeVideo class]])
                    [self.controller.videoListController addObject:video];
                else if ([video isMemberOfClass:[LYContinuation class]]) self.videoContinuation = video;
                self.homeSpinner.doubleValue++;
            }
            [self.homeSpinner stopAnimation:self];
            [self.homeSpinner setIndeterminate:YES];
        });
    });
}

- (void)continuationTest:(id)sender
{
    [self loadMoreVideos];
}

- (void)loadMoreVideos
{
    if (self.videoContinuation) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSArray *videos = [self.client getHomeWithContinuation:self.videoContinuation];
            dispatch_async(dispatch_get_main_queue(), ^{
                for (id video in videos) {
                    if ([video isMemberOfClass:[LYouTubeVideo class]])
                        [self.controller.videoListController addObject:video];
                    else if ([video isMemberOfClass:[LYContinuation class]]) self.videoContinuation = video;
                    self.homeSpinner.doubleValue++;
                }
            });
        });
    }
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

- (void)authCodeConfirm:(id)sender
{
    [self.authTimeIndicator setIndeterminate:YES];
    NSDictionary *bearerData = [self.client getBearerToken];
    if (![bearerData objectForKey:@"error"]) [self authCodeCancel:sender];
    else [self handleAuthError:bearerData];
}

- (void)polltest:(id)sender
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
            self.video = self.controller.video = video.tracker.video = video;
            
            if (self.video.description) [self.videoDescription setStringValue:self.video.description];
            if (self.video.title) [self.videoTitle setStringValue:self.video.title];
            
            LYVideoFormat *format = [self.video.formats objectAtIndex:0];
            
            self.movie = [self.video getMovieWithFormat:format];
            self.video.movie = self.movie;
            [[self movieView] setMovie:self.movie];
            [self.videoLoadingIndicator stopAnimation:self];
            [self.movieView play:self];
            [self startTracking];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:QTMovieRateDidChangeNotification object:nil];
            
            for (LYVideoFormat *format in self.video.formats) {
                [self.formatTable addFormat:format];
                if (format.qualityLabel)
                    [self.codecSelection addItem:[[NSMenuItem alloc] initWithTitle:[format.qualityLabel stringByAppendingFormat:@"%@", format.fps] action:@selector(changeVideoFormat:) keyEquivalent:@""]];
            }
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
//    [self.movieView setFillColor:[NSColor blackColor]];
    [self.movieView enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
}

- (void)endFullScreen
{
    [[self movieView] exitFullScreenModeWithOptions:nil];
}

- (IBAction)startPictureInPictureMode:(id)sender
{
    [self.PiPPanel setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [self.PiPPanel makeKeyAndOrderFront:self];
    [self.PiPPanel setContentAspectRatio:NSMakeSize(16, 9)];
//    [self.movieView setVolumeButtonVisible:NO];
    [self.movieView setControllerVisible:NO];
    [self.movieView setMovie:nil];
    [self.pipMovieView setMovie:self.movie];
}

- (IBAction)endPictureInPictureMode:(id)sender
{
//    [self.panel orderOut:sender];
//    QTMovie *movie = self.pipMovieView.movie;
//    [self.pipMovieView setMovie:nil];
//    [self.movieView setMovie:movie];
    [self.PiPPanel close];
}

- (void)togglePlayerMode:(id)sender
{
    if ([sender isMemberOfClass:[NSSegmentedControl class]]) {
        NSInteger selected = [sender selectedSegment];
        if (playerMode == selected) 
//            selected = -1;
            [sender setSelectedSegment:-1];
//            -1;
        else if (selected == 0) {
            [self endPictureInPictureMode:sender];
            [self knex:sender];
        }
        else if (selected == 1) {[self endFullScreen];[self startPictureInPictureMode:sender];
        }
            playerMode = selected;
    }
}

- (void)clearVideoList:(id)sender
{
    [self.controller.videos removeAllObjects];
}

@end
