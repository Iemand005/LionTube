//
//  LYPlaybackTracker.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 10/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "LYPlaybackTracker.h"

@implementation LYPlaybackTracker

- (void)updateWatchtime
{
    [self pollTracker:self.watchtimeUrl];
}

- (void)startTracking
{
    [self pollTracker:self.playbackUrl];
    [self updateWatchtime];
}

- (void)pauseTracking
{
    [self pollTracker:self.delayplayUrl];
}

- (void)continueTracking
{
//    [self pollTracker:self.watchtimeUrl];
    [self updateWatchtime];
}

- (void)pollTracker:(NSURL *)endpoint
{
    NSURLRequest *request = [NSURLRequest requestWithURL:endpoint];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSInteger result){}];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

- (void)playbackUrlGen
{
    /*
     
     Using InnerTube API is not always easy due to a complete lack of documentation.
     Here is my attempt at deciphering the things based on the info I can find:
     
     https://forums.anandtech.com/threads/how-does-youtube-track-your-viewing-activity.2522111/
     https://stackoverflow.com/questions/64900350/youtube-api-stats-qoe-metrics
     https://www.blackhatworld.com/seo/how-to-sent-http-request-to-youtube-stats-server.873021/
     https://www.blackhatworld.com/seo/interesting-script-to-get-youtube-views.1052157/
     https://unixforum.org/viewtopic.php?t=138376
     
     -- every 10 seconds? proably doesn4t matter. that means youtube has a max 10 second deviation on watch time in case of sudden shutdown it probably registers on reload more accurately/
     
     https://s.youtube.com/api/stats/watchtime?
     cl=621014728&
     docid=tpAugZVbZKY&
     ei=h-cSZpGNGbW46dsP5ZSskAM&
     fexp=
     ns=yt                              -- (name server) yt for youtube
     plid=AAYVhfVbHWI8tiZe&
     el=detailpage&
     len=1381&
     of=eGDgs4NW9AVjheAFzToDdg&
     vm=CAEQARgEOjJBSHFpSlRKSHlnanZ6Rl9UTlM5QU5BU2hza09EVFpiYnA0c05WWlRRNWJvVVh6RXp4UWJsQVBta0tETEMwQkt4S2JVOGpQU05HMExVNTFVMzl3MFNCSzVMbFVocC1vQzlrVlc5c2xSMTA4SGt3SnZrTHh2SnEzSEtpbEg0WjNZb3pBMkVaM0p2ZExBQXlQdV85VEhNa05hVzlDRy1ZdkpjaAI
     
     el=leanback                        -- !! leanback, detailpage
     cpn=pHI_kIxZU60G7s9O               -- random?
     docid=s8etPjZUDqA                  -- !! (document id) Youtube video ID. videoId
     ver=2                              -- ?? some version
     referrer=https://www.example.com/  -- The referrer url.
     
     --> c stands for client?
     --> t stands for time?
     --> br stands for browser.
     --> os stands for operating system.
     --> ver stands for version.
     --> pl stands for player.
     --> mt?? something with time
     --> hl stands for host language
     c=TVHTML5                          -- Name of the client.
     cver=5.20160729                    -- Version of the client. (client version) --> major.YYMMDD.minor.patch
     cplayer=UNIPLAYER                  -- Name of the player. (client player), type of the player, UNIPLAYER --> WEB  
     cbr=Firefox                        -- Name of the browser. (client browser)
     cbrver=61.0                        -- (client browser version)
     cos=Windows                        -- Operating system of the client (client operating system)
     cosver=10.0                        -- (client operating system version)
     
     cmt=5                              -- ?? client mean time ?? custom machine type??
     plid=AAV0SnP6Z3iATk9B              -- is this the user id? player ID ?
     ei=A2O1suGlUhr9gN5YtjjHZu          -- !! not necessary?
     fmt=244                            -- ?? is the same for all requests, example: 244
     fs=0
     rt=10
     of=pp2cCVN4J3hdMWZP-Fb8dw          -- !!
     euri                               -- (europe innertube?)
     lact=3809
     cl=209783907
     state=playing                      -- (state) playing if the player is playing
     vm=CAIQABgE...                     -- !! base64 encoded: 6 bytes - : - encrypted data
     volume=55                          -- (volume) the volume at which the video is playing

     hl=en_US                           -- (host language)
     cr=TR
     len=175                            -- !! Length of the video in seconds. (length)
     rtn=15
     afmt=251
     idpj=-6
     ldpj=-1
     rti=4
     muted=0                            -- BOOLEAN (muted) -> is the video muted?
     st=0                               -- (start time?)
     et=5
     fexp=...                           -- Frame experience ??
     seq                                -- for qoe Not required, Sequence number for packets
     bwe                                -- for qoe ?? the time the page was open ??
     
    ?? stationary values
     fmt: 244
     len=175 ?
    // playback
    cmt: 0                              -- this one seems to increase witht he watch time!
    
    // delayplay
     cmt=10.299
     afmt               -- the same for both delayplay and playback, example: 251
     
    // watchtime 1
     
     et                                 -- This is the time at which the video is currently played! only for watchtime api
     st                                 -- works together wtih et? perhaps start time and end time, the intervals of the video play
     cmt                                -- asme value as et? 
     // watchtime 2
     
     st             -- if the previous watchtime request had et 5, the st of this one is also 5.
     rti            -- if rt of the delayplay is 15, rti of the next watchtime is also 15
     rtn            -- both values seem to increase over time, rtn increases more than rti
     
     
     Let's watch the interesting values between two requets:
     
     - Playback
     
     cmt=0          -- cmt is 0 at start of video
     rt=5
     lact=-1        -- lact is probably -1 on all playback requests. this suggest that it is latency?
     rtn=5          -- rtn and rt match
     
     - Delayplay
     
     cmt=10.299
     rt=15
     lact=605
     
     - Watchtime 1
     
     cmt=5
     rt=10
     lact=3809
     rtn=15
     rti=4
     st=0
     et=5
     
     - Watchtime 2
     
     cmt=154
     rt=159
     lact=971
     rtn=199
     rti=159
     st=5
     et=154
     
     */
    id query = System.Web.HttpUtility.ParseQueryString(url);
    
    id cl = query.Get(query.AllKeys[0]);
    id ei = query.Get("ei");
    id of = query.Get("of");
    id vm = query.Get("vm");
    id cpn = GetCPN();
    
    id start = DateTime.UtcNow;
    
    id st = random.Next(1000, 10000);
    id et = GetCmt(start);
    id lio = GetLio(start);
    
    id rt = random.Next(10, 200);
    
    id lact = random.Next(1000, 8000);
    id rtn = rt + 300;
    
    id args = new Dictionary<string, string>
    {
        ["ns"] = "yt",
        ["el"] = "detailpage",
        ["cpn"] = cpn,
        ["docid"] = id,
        ["ver"] = "2",
        ["cmt"] = et.ToString(),
        ["ei"] = ei,
        ["fmt"] = "243",
        ["fs"] = "0",
        ["rt"] = rt.ToString(),
        ["of"] = of,
        ["euri"] = "",
        ["lact"] = lact.ToString(),
        ["live"] = "dvr",
        ["cl"] = cl,
        ["state"] = "playing",
        ["vm"] = vm,
        ["volume"] = "100",
        ["cbr"] = "Firefox",
        ["cbrver"] = "83.0",
        ["c"] = "WEB",
        ["cplayer"] = "UNIPLAYER",
        ["cver"] = "2.20201210.01.00",
        ["cos"] = "Windows",
        ["cosver"] = "10.0",
        ["cplatform"] = "DESKTOP",
        ["delay"] = "5",
        ["hl"] = "en_US",
        ["rtn"] = rtn.ToString(),
        ["aftm"] = "140",
        ["rti"] = rt.ToString(),
        ["muted"] = "0",
        ["st"] = st.ToString(),
        ["et"] = et.ToString(),
        ["lio"] = lio.ToString()
    };
}

+ (LYPlaybackTracker *)tracker
{
    return [[LYPlaybackTracker alloc] init];
}

@end
