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
     
     
     el=leanback
     cpn=pHI_kIxZU60G7s9O               -- random?
     docid=s8etPjZUDqA
     ver=2
     referrer=https://www.example.com/  -- The referrer url.
     
     --> c stands for client?
     c=TVHTML5                          -- Name of the client.
     cver=5.20160729                    -- Version of the client. (client version)
     cplayer=UNIPLAYER                  -- Name of the player. (client player)
     cbr=Firefox                        -- Name of the browser. (client browser)
     cbrver=61.0                        -- (client browser version)
     cos=Windows                        -- Operating system of the client (client operating system)
     cosver=10.0                        -- (client operating system version)
     
     cmt=5                              -- ?? client mean time ??
     plid=AAV0SnP6Z3iATk9B
     ei=A2O1suGlUhr9gN5YtjjHZu
     fmt=244
     fs=0
     rt=10
     of=pp2cCVN4J3hdMWZP-Fb8dw
     euri
     lact=3809
     cl=209783907
     state=playing
     vm=CAIQABgE
     volume=55

     hl=en_US                           -- (h... language)
     cr=TR
     len=175                            -- (length?) ?? length of the video ??
     rtn=15
     afmt=251
     idpj=-6
     ldpj=-1
     rti=4
     muted=0                            -- BOOLEAN (muted) -> is the video muted?
     st=0                               -- (start time?)
     et=5
     
     
    ?? stationary values
     fmt: 244
     len=175 ?
    // playback
    cmt: 0
    
    // delayplay
     cmt=10.299

     
    // watchtime 1
     
     // watchtime 2
     
     
     
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
