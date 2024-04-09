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
    
//    [self.homeCollectionView insertText:@"hello"];
    NSCollectionViewItem *item;
    self.homeCollectionView.itemPrototype = item;
    
//    self.window.contentView = self.mainView;
    //[self openVideoPageForVideoWithId:@"dw-sHMTsMVs"];
    
    [self.controller.videoListController add:self];
    LYouTubeVideo *video = [LYouTubeVideo videoWithId:@"prat"];
//    [self.controller.videoListController.videos ]
    [self.controller.videoListController addObject:video];
    
    [self.client setCredentialFile:@"auth.plist"];
    if ([self.client refreshAuthCredentials]) {
        NSLog(@"Authenticated.");
        [self.client getUserInfo];
        [self.client getHome];
    } else NSLog(@"Token invalid");
    //[self logIn:nil];
}

- (void)openVideoPageForVideoWithId:(NSString *)videoId
{
    [self.videoLoadingIndicator startAnimation:self];
    self.window.contentView = self.mainView;
    [self loadVideoWithId:videoId];
}

- (void)windowDidResize:(NSNotification *)notification
{
    [self.mainSplitView setPosition:self.videoParentView.frame.size.width / self.videoWidth * self.videoHeight ofDividerAtIndex:0];
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
    self.video = [self.client getVideoWithId:videoId];
    
    [self.videoDescription setStringValue:self.video.description];
    [self.videoTitle setStringValue:self.video.title];
    
    for (LVideoFormat *format in self.video.formats)
        [self.formatTable addFormat:format];
    
    LVideoFormat *format = [self.video.formats objectAtIndex:0];
    
    self.movie = [self.video getMovieWithFormat:format];
    [[self movieView] setMovie:self.movie];
    [self.videoLoadingIndicator stopAnimation:self];
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

- (IBAction)stardt
{
    [self.movieView enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
}

- (IBAction)startPictureInPictureMode:(id)sender
{
    [self.PiPPanel setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [self.PiPPanel makeKeyAndOrderFront:self];
    [self.PiPPanel setAspectRatio:NSMakeSize(16, 9)];
    [self.movieView setMovie:nil];
    [self.pipMovieView setMovie:self.movie];
}

@end
