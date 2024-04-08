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
    [self.drawer open];
    self.client = [LYouTubeClient client];
}

- (IBAction)sctart:(id)sender
{
//    NSString *url = @"https://rr7---sn-vg5obxcx-5oge.googlevideo.com/videoplayback?expire=1712536233&ei=SeYSZr6tEJmJ6dsP_LO2cA&ip=94.110.9.192&id=o-AD7CbvxPXFdeM7Fb9094WfzFyVZDaaLRGd_BtFSE5qBC&itag=18&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&mh=v2&mm=31%2C29&mn=sn-vg5obxcx-5oge%2Csn-5hnekn7l&ms=au%2Crdu&mv=m&mvi=7&pl=25&initcwndbps=1366250&bui=AaUN6a28-iE_ZhHAAKPJufBMBXDht44CkLwswcQjWt0JXBwIEMCdGpvKD1r-_akmoyVCRTVr5waLNLyT&spc=UWF9f1bQarNwgyJU2bEXd6CF_erxxoQNVtMhx4axam4FTsJNpkGEhYXckg&vprv=1&svpuc=1&mime=video%2Fmp4&ns=CpsMw-KiW5ByzAndEwEMZFcQ&cnr=14&ratebypass=yes&dur=1.137&lmt=1669819165164632&mt=1712514300&fvip=3&fexp=51141542&c=MWEB&sefc=1&txp=4430434&n=u5t7zlU3Or2kdLa8r&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cbui%2Cspc%2Cvprv%2Csvpuc%2Cmime%2Cns%2Ccnr%2Cratebypass%2Cdur%2Clmt&sig=AJfQdSswRgIhANhS2FzHFHtHXzH1WyuGnCcFxhqgdjwkh-Ij1dRx54WLAiEAnrbckThn0HOLYOOP1Bm5grlpWBYdyHkVtQqdzrI77zA%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=ALClDIEwRgIhAJ_hDTYEgB1t6NrDUhJSftgZ4F7VD-V-p-JYyhvnYwj4AiEAhJPLJfWAhrVqj-CWYN9niHDxZDMcM63jV-dDZI7Sq68%3D";
    
//    [self.client getVideoWithId:];
    LYouTubeVideo *video = [LYouTubeVideo videoWithId:self.urlField.stringValue];
    [video requestVideoWithClient:self.client];
    
    [self.descriptionField setStringValue:video.description];
    
    for (LVideoFormat *format in video.formats)
        [self.formatTable addFormat:format];
    
    for (LVideoFormat *format in video.adaptiveFormats)
        [self.formatTable addFormat:format];
    
    LVideoFormat *format = [video.formats objectAtIndex:0];
    
    self.video = video;
    
    [[self movieView] setMovie:[video getMovieWithFormat:format]];
    //[self.movieView needsDisplay];
    [self.movieView play:sender];
//    [self.movieView relo]
}

- (IBAction)trySelectedVideoFormat:(id)sender
{
    NSUInteger index = self.formatTableView.selectedRow;
    LVideoFormat *format = [self.video.formats objectAtIndex:index];
    [[self movieView] setMovie:[self.video getMovieWithFormat:format]];
}

- (IBAction)start
{
    [self.movieView enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
}

@end
