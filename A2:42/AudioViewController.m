//
//  AudioViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 6/30/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import "AudioViewController.h"
#import "MEStringSearcher.h"
#import "Social/Social.h"
#import "SermonViewController.h"
#import "NoteViewController.h"
#import "ToastView.h"


@interface AudioViewController ()

@end


@implementation AudioViewController{
    
}
NSString *mp3URL;
float totalSeconds;
float currentSeconds;
NSString* seconds;
NSString* rseconds;
NSString* hourMinute;
NSString* rhourMinute;
BOOL isPaused;
NSMutableArray *titles;
NSMutableArray *teacherNames;
NSMutableArray *webSitesP;
NSTimer* timer;
double psd;
BOOL downloading;
NSURL *mpurl;
float rate;
long long totalFileSize;
NSURLConnection *conn;
BOOL downed;
NSString* playerURL;
NSTimer* timer;
BOOL note;
BOOL favorited = FALSE;

@synthesize theTitle, websiteURL, currentSermon, startTime,endTime, pauseButton,minuteLabel,minuteText,secondLabel,secondText,hourLabel,hourText, undoButton,goButton,teacher,showProgress,favoriteStar,tye,imman,corner;


-(void)bck{
    //HomeNavigationController
    note = FALSE;
    SermonViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sermon"];
    [self.navigationController setNavigationBarHidden:TRUE];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    note = TRUE;
    rate = 1.0;
    if([tye isEqualToString:@"Back"]){
        self.navigationController.navigationBar.topItem.leftBarButtonItem = _barButton;
        _barButton.target = self;
        _barButton.action = @selector(bck);
        
    }
    
    fileData = [NSMutableData data];
    downed = false;
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *img = [UIImage imageNamed:@"slider.png"];
    
    [_slider setThumbImage:img forState:UIControlStateNormal];
    
    currentSermon.text = theTitle;
    currentSermon.numberOfLines = 0;
    currentSermon.textAlignment = NSTextAlignmentCenter;
    [currentSermon sizeToFit];
    currentSermon.center = CGPointMake([self view].center.x, 134);
    NSLog(@"%@", websiteURL);
    
    
    if([teacher isEqualToString:@"Jason Lancaster"]){
        
        mp3URL = websiteURL;
        playerURL = [NSURL URLWithString:mp3URL];
        
    }
    
    else if([teacher isEqualToString:@"Shai Linne"]){
        mp3URL = websiteURL;
        playerURL = [NSURL URLWithString:mp3URL];
    }
    else if([teacher isEqualToString:@"Brian Powell"]){
        mp3URL = websiteURL;
        playerURL = [NSURL URLWithString:mp3URL];
    }
    else if([teacher isEqualToString:@"Gunner Gundersen"]){
        mp3URL = websiteURL;
        playerURL = [NSURL URLWithString:mp3URL];
    }
    else if([teacher isEqualToString:@"Art Azurdia"]){
        
        mp3URL = websiteURL;
        playerURL = [NSURL URLWithString:mp3URL];
        
        AVURLAsset *asset = [AVURLAsset assetWithURL: playerURL];
        Float64 duration = CMTimeGetSeconds(asset.duration);
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
        audioPlayer = [[AVPlayer alloc] initWithPlayerItem: item];
    }
    else{
        
        NSURL *url = [NSURL URLWithString:websiteURL];
        NSString *webData = [NSString stringWithContentsOfURL:url];
        NSError *error;
        //NSLog(@"%@", webData);
        
        downloading = FALSE;
        if (webData == nil) {
            // an error occurred
            NSLog(@"Error reading file at %@\n%@",
                  url, [error localizedFailureReason]);
            // implementation continues ...
        }
        else{
            if([teacher isEqualToString:@"Ryan Fullerton"] || [imman isEqualToString:@"Immanuel"]){
                //NSLog(@"%@", webData);
                MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                [searcher moveToString:@"audio/mpeg"];
                mp3URL = [searcher getStringWithLeftBound:@"src=\"" rightBound:@"\""];
                NSLog(@"%@", mp3URL);
                if([mp3URL isEqualToString:@"http://www.ibclouisville.org/new/wordpress/wp-content/uploads/2012/08/immanuel_header_logo.png"]){
                    [searcher moveToString:@"Show Audio Player"];
                    NSString* st = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                    NSString*link = [NSString stringWithFormat:@"%@%@",@"http://www.ibclouisville.org",st];
                    NSLog(@"%@",link);
                    [self fullertonShowAudio:link];
                    
                }
                
            }
            if([teacher isEqualToString:@"Spencer Harmon"]){
                MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                [searcher moveToString:@"audio_player"];
                mp3URL = [searcher getStringWithLeftBound:@"src=\"" rightBound:@"\""];
                playerURL = [NSURL URLWithString:mp3URL];
                
            }
            if([teacher isEqualToString:@"Paul Washer"] || [teacher isEqualToString:@"Tim Conway"]){
                //NSLog(@"%@", webData);
                MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                [searcher moveToString:@"MP3"];
                [searcher moveBack:100];
                mp3URL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                NSLog(@"%@", mp3URL);
                playerURL = [NSURL URLWithString:mp3URL];
            }
            if([teacher isEqualToString:@"John Piper"]){
                MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                [searcher moveToString:@"<span>Download</span>"];
                mp3URL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                if(![mp3URL containsString:@"mp3"]){
                    [searcher moveToBeginning];
                    [searcher moveToString:@"<span>Download</span>"];
                    [searcher moveToString:@"Audio (MP3)"];
                    [searcher moveBack:150];
                    mp3URL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                }
                mp3URL = [mp3URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"%@", mp3URL);
                playerURL = [NSURL URLWithString:mp3URL];
            }
            if([teacher isEqualToString:@"John Onwuchekwa"]){
                MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                [searcher moveToString:@"title=\"Play"];
                [searcher moveBack:130];
                mp3URL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                playerURL = [NSURL URLWithString:mp3URL];
                
            }
            
            if([teacher isEqualToString:@"Voddie Baucham"]||[teacher isEqualToString:@"Kenny Petty"]){
                MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                [searcher moveToString:@"mediaplayer"];
                [searcher moveToString:@"mediaplayer"];
                [searcher moveBack:100];
                NSString* str = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                playerURL = [NSString stringWithFormat:@"%@%@",@"http://www.sermonaudio.com/",str];
                [searcher moveToString:@"Download MP3"];
                [searcher moveBack:100];
                mp3URL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                NSLog(@"%@", mp3URL);
            }
            
        }
    }
    
    //AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
    //AVAudioSession.sharedInstance().[setActive(true, error: nil)
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:true error:nil];
    
    
    mpurl = [NSURL URLWithString:mp3URL];
    audioPlayer = [AVPlayer playerWithURL:mpurl];
    [audioPlayer setVolume: 1.0];
    [audioPlayer play];
    
    
    CMTime duration = audioPlayer.currentItem.asset.duration;
    totalSeconds = CMTimeGetSeconds(duration);
    
    CMTime currentTime = audioPlayer.currentTime;
    currentSeconds = CMTimeGetSeconds(currentTime);
    
    
    
    
    
    
    
    isPaused = false;
    timer = [NSTimer timerWithTimeInterval:0.2
                                    target:self
                                  selector:@selector(update:)
                                  userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //NSLog(@"%f", totalSeconds);
    if(totalSeconds == 0){
        [timer invalidate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR: 316"
                                                        message:@"Audio Does Not Exist"
                                                       delegate:nil
                                              cancelButtonTitle:@"Alright"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self see];
    NSLog(@"duration: %.2f", totalSeconds);
    NSLog(@"time: %.2f", currentSeconds);
    NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
    [songInfo setObject:theTitle forKey:MPMediaItemPropertyTitle];
    [songInfo setObject:teacher forKey:MPMediaItemPropertyArtist];
    [songInfo setObject:@"A2:42" forKey:MPMediaItemPropertyAlbumTitle];
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"iTunesArtwork.png"]];
    [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

}
-(void) see{
    NSString* fff = [NSString stringWithFormat:@"%@%@%@",teacher,theTitle,@"favorite"];
    NSString* ttt = [NSString stringWithFormat:@"%@%@%@",teacher,theTitle,@"time"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    favorited = [prefs boolForKey:fff];
    float fl = [prefs floatForKey:ttt];
    int16_t intt = 600;
    CMTime theTime = CMTimeMakeWithSeconds(fl, intt);
    [audioPlayer seekToTime:theTime];
    
    UIImage *img;
    if(favorited){
        img = [UIImage imageNamed:@"star.png"];
    }
    else{
        img = [UIImage imageNamed:@"starGray.png"];
    }
    [favoriteStar setImage:img forState:UIControlStateNormal];
    
    
    
    NSMutableArray *recentTitleArray = [[prefs objectForKey:@"recentTitles"] mutableCopy];
    NSMutableArray *recentURLArray = [[prefs objectForKey:@"recentSites"] mutableCopy];
    NSMutableArray *recentTeachersArray = [[prefs objectForKey:@"recentTeachers"] mutableCopy];
    
    if(recentTitleArray == nil){
        NSLog(@"nillllll");
        
        recentTitleArray = [NSMutableArray array];
        recentTeachersArray = [NSMutableArray array];
        recentURLArray = [NSMutableArray array];
    }
    NSLog(@"%@",theTitle);
    NSLog(@"%@",websiteURL);
    NSLog(@"%@",teacher);
    [recentTitleArray insertObject:theTitle atIndex:0];
    [recentURLArray insertObject:websiteURL atIndex:0];
    [recentTeachersArray insertObject:teacher atIndex:0];
    
    NSLog(@"%@",recentTitleArray);
    
    for(int i = [recentTitleArray count] -1; i >= 1; i--){
        if([[recentTitleArray objectAtIndex:i] isEqualToString:theTitle]){
            [recentTitleArray removeObjectAtIndex:i];
            [recentTeachersArray removeObjectAtIndex:i];
            [recentURLArray removeObjectAtIndex:i];
        }
    }
    
    for(int i = [recentTitleArray count] -1; i >= 0; i--){
        if(i >9){
            [recentTitleArray removeObjectAtIndex:i];
            
            
            [recentTeachersArray removeObjectAtIndex:i];
            [recentURLArray removeObjectAtIndex:i];
        }
    }
    
    
    if([imman isEqualToString:@"Immanuel"]){
        NSString *iii = [NSString stringWithFormat:@"immanuel%@%@",teacher,theTitle];
        [prefs setBool:true forKey:iii];
    }
    
    [prefs setObject:recentTitleArray forKey:@"recentTitles"];
    [prefs setObject:recentURLArray forKey:@"recentSites"];
    [prefs setObject:recentTeachersArray forKey:@"recentTeachers"];
    
    [prefs synchronize];
    
    
}

- (void)update: (NSTimer*) timer {
    CMTime duration = audioPlayer.currentItem.asset.duration;
    totalSeconds = CMTimeGetSeconds(duration);
    
    CMTime currentTime = audioPlayer.currentTime;
    currentSeconds = CMTimeGetSeconds(currentTime);
    
    float percent = currentSeconds / totalSeconds;
    [_slider setValue:percent];
    
    float remainingSeconds = totalSeconds - currentSeconds;
    if(totalSeconds < 3600){
        int currentMinute = currentSeconds / 60;
        int currentSec = (int)currentSeconds % 60;
        
        if(currentSec < 10){
            seconds = [NSString stringWithFormat:@"%@%d",@"0",currentSec];
        }
        else{
            seconds = [NSString stringWithFormat:@"%d", currentSec];
        }
        startTime.text = [NSString stringWithFormat:@"%d%@%@", currentMinute,@":",seconds];
        
        int remainingMinute = remainingSeconds / 60;
        int remainingSec = (int)remainingSeconds % 60;
        
        if(remainingSec < 10){
            rseconds = [NSString stringWithFormat:@"%@%d",@"0",remainingSec];
        }
        else{
            rseconds = [NSString stringWithFormat:@"%d", remainingSec];
        }
        endTime.text = [NSString stringWithFormat:@"%d%@%@", remainingMinute,@":",rseconds];
    }
    else{
        int currentHour = currentSeconds / 3600;
        int currentMinute = (currentSeconds - (currentHour * 3600))/ 60;
        int currentSec = (int)(currentSeconds - (currentHour * 3600)) % 60;
        
        if(currentSec < 10){
            seconds = [NSString stringWithFormat:@"%@%d",@"0",currentSec];
        }
        else{
            seconds = [NSString stringWithFormat:@"%d", currentSec];
        }
        if(currentMinute < 10){
            hourMinute = [NSString stringWithFormat:@"%@%d",@"0",currentMinute];
        }
        else{
            hourMinute = [NSString stringWithFormat:@"%d",currentMinute];
        }
        startTime.text = [NSString stringWithFormat:@"%d%@%@%@%@",currentHour,@":", hourMinute,@":",seconds];
        
        int remainingHour = remainingSeconds / 3600;
        int remainingMinute = (remainingSeconds - (remainingHour * 3600))/ 60;
        int remainingSec = (int)(remainingSeconds - (remainingHour * 3600)) % 60;
        
        if(remainingSec < 10){
            rseconds = [NSString stringWithFormat:@"%@%d",@"0",remainingSec];
        }
        else{
            rseconds = [NSString stringWithFormat:@"%d", remainingSec];
        }
        if(remainingMinute < 10){
            rhourMinute = [NSString stringWithFormat:@"%@%d",@"0", remainingMinute];
        }
        else{
            rhourMinute = [NSString stringWithFormat:@"%d",remainingMinute];
        }
        endTime.text = [NSString stringWithFormat:@"%d%@%@%@%@",remainingHour,@":", rhourMinute,@":",rseconds];
    }
    
    NSString* ttt = [NSString stringWithFormat:@"%@%@%@",teacher,theTitle,@"time"];
    NSString* lll = [NSString stringWithFormat:@"%@%@%@",teacher,theTitle,@"heard"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:currentSeconds-2 forKey:ttt];
    [prefs setBool:true forKey:lll];
    [prefs synchronize];
    
    
}

- (IBAction)sliderChanged:(id)sender {
    //[audioPlayer pause];
    Float64 sec = (_slider.value) * totalSeconds;
    int16_t intt = 600;
    CMTime theTime = CMTimeMakeWithSeconds(sec, intt);
    [audioPlayer seekToTime:theTime];
    [audioPlayer pause];
    UIImage *img = [UIImage imageNamed:@"play-disabled-1.png"];
    [pauseButton setImage:img forState:UIControlStateNormal];
    isPaused = true;
    
}

- (IBAction)paused:(id)sender {
    if(!isPaused){
        isPaused = true;
        [audioPlayer pause];
        UIImage *img = [UIImage imageNamed:@"play-disabled-1.png"];
        [pauseButton setImage:img forState:UIControlStateNormal];
        
    }
    else{
        UIImage *img = [UIImage imageNamed:@"pause-disabled.png"];
        [pauseButton setImage:img forState:UIControlStateNormal];
        isPaused = false;
        [audioPlayer play];
    }
}

- (IBAction)seekPosition:(id)sender {
    
    hourText.text = @"";
    minuteText.text = @"";
    secondText.text = @"";
    
    
    [undoButton setHidden:FALSE];
    [goButton setHidden:FALSE];
    [secondText setHidden:FALSE];
    [secondLabel setHidden:FALSE];
    [minuteText setHidden:FALSE];
    [minuteLabel setHidden:FALSE];
    [hourText setHidden:FALSE];
    [hourLabel setHidden:FALSE];
    [hourText becomeFirstResponder];
    
}

- (IBAction)undid:(id)sender {
    [hourText resignFirstResponder];
    [minuteText resignFirstResponder];
    [secondText resignFirstResponder];
    
    [undoButton setHidden:TRUE];
    [goButton setHidden:TRUE];
    [secondText setHidden:TRUE];
    [secondLabel setHidden:TRUE];
    [minuteText setHidden:TRUE];
    [minuteLabel setHidden:TRUE];
    [hourText setHidden:TRUE];
    [hourLabel setHidden:TRUE];
}

- (IBAction)sought:(id)sender {
    [hourText resignFirstResponder];
    [minuteText resignFirstResponder];
    [secondText resignFirstResponder];
    
    [undoButton setHidden:TRUE];
    [goButton setHidden:TRUE];
    [secondText setHidden:TRUE];
    [secondLabel setHidden:TRUE];
    [minuteText setHidden:TRUE];
    [minuteLabel setHidden:TRUE];
    [hourText setHidden:TRUE];
    [hourLabel setHidden:TRUE];
    
    NSString *ht = hourText.text;
    NSString *mt = minuteText.text;
    NSString *st = secondText.text;
    int hour;
    int minute;
    int second;
    
    if(ht.length < 1){
        hour = 0;
    }
    else{
        hour = [ht intValue];
    }
    if(mt.length < 1){
        minute = 0;
    }
    else{
        minute = [mt intValue];
    }
    if(st.length < 1){
        second = 0;
    }
    else{
        second = [st intValue];
    }
    //NSLog(@"%d%d",hour,minute);
    Float64 totSec = (hour*3600) + (minute * 60) + second;
    
    if(totSec > totalSeconds){
        totSec = totalSeconds;
    }
    if(totSec <= 0){
        totSec = 0;
    }
    int16_t intt = 600;
    CMTime theTime = CMTimeMakeWithSeconds(totSec, intt);
    [audioPlayer seekToTime:theTime];
    
    
}

- (IBAction)downloaded:(id)sender {
    
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    titles = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"sermonTitles"]];
    teacherNames = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"teacherNames"]];
    webSitesP = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"webSitesP"]];
    BOOL alreadyExists = FALSE;
    
    for(int i = 0; i < [titles count];i++){
        if([[titles objectAtIndex:i] isEqualToString:theTitle]){
            alreadyExists = TRUE;
        }
    }
    
    if(!alreadyExists && !downed){
        downloading = true;
        downed = true;
        if([teacher isEqualToString:@"Voddie Baucham"]||[teacher isEqualToString:@"Kenny Petty"]){
            /*NSURL *url = [NSURL URLWithString:playerURL];
            NSString *webData = [NSString stringWithContentsOfURL:url];
            NSError *error;
            //NSLog(@"%@", webData);
            
            if (webData == nil) {
                // an error occurred
                NSLog(@"Error reading file at %@\n%@",
                      url, [error localizedFailureReason]);
                // implementation continues ...
            }
            else{
                [showProgress setHidden: FALSE];
                MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                [searcher moveToString:@"file:"];
                NSString* str = [searcher getStringWithLeftBound:@"'" rightBound:@"'"];
                NSURL* strURL = [NSURL URLWithString:@"http://playmp3.sa-media.com/media/51016816561/51016816561.mp3"];
                NSURLRequest* req = [NSURLRequest requestWithURL:strURL];
                //NSLog(@"%@", str);
                conn = [NSURLConnection connectionWithRequest:req delegate:self];
            }*/
            
        }
        else{
            
            NSURLRequest* req = [NSURLRequest requestWithURL:mpurl];
            //NSLog(@"%@", mpurl);
            conn = [NSURLConnection connectionWithRequest:req delegate:self];
        }
    }
}
-(void)connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse *)response{
    [showProgress setHidden: FALSE];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [fileData setLength:0];
    totalFileSize = [response expectedContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [fileData appendData:data];
    float progressive = (float)[fileData length] / (float)totalFileSize;
    [showProgress setProgress:progressive];
    //NSLog(@"%f",progressive);
}
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:    (NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",theTitle,@".mp3"]];
    [showProgress setHidden: TRUE];
    
    if ([fileData writeToFile:path options:NSAtomicWrite error:nil] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"Audio Could Not Download"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        downloading = false;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [titles addObject:theTitle];
        [teacherNames addObject:teacher];
        [webSitesP addObject:websiteURL];
        
        if([imman isEqualToString:@"Immanuel"]){
            NSString *iii = [NSString stringWithFormat:@"immanuel%@%@",teacher,theTitle];
            [prefs setBool:true forKey:iii];
        }
        [prefs setObject:titles forKey:@"sermonTitles"];
        [prefs setObject:teacherNames forKey:@"teacherNames"];
        [prefs setObject:webSitesP forKey:@"webSitesP"];
        [prefs synchronize];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Audio Downloaded Successfully"
                                                       delegate:nil
                                              cancelButtonTitle:@"Great"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:(@"notes")]){
        NoteViewController *note = [[NoteViewController alloc]init];
        note = [segue destinationViewController];
        note.theTitle = theTitle;
        note.teacher = teacher;
    }
    
}
- (IBAction)tweeted:(id)sender {
    NSString *tweet=[NSString stringWithFormat:@"%@%@", @"\"\" - ",teacher];
    
    SLComposeViewController *tweeter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweeter setInitialText: tweet];
    [self presentViewController:tweeter animated:YES completion:nil];
}

- (IBAction)favorited:(id)sender {
    
    NSString* fff = [NSString stringWithFormat:@"%@%@%@",teacher,theTitle,@"favorite"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    
    UIImage *img;
    if(favorited){
        img = [UIImage imageNamed:@"starGray.png"];
        [prefs setBool:false forKey:fff];
        favorited = FALSE;
        
        NSMutableArray *favoriteTitleArray = [[prefs objectForKey:@"favoriteTitles"] mutableCopy];
        NSMutableArray *favoriteURLArray = [[prefs objectForKey:@"favoriteSites"] mutableCopy];
        NSMutableArray *favoriteTeachersArray = [[prefs objectForKey:@"favoriteTeachers"] mutableCopy];
        
        if(favoriteTitleArray == nil){
            NSLog(@"nillllll");
            
            favoriteTitleArray = [NSMutableArray array];
            favoriteTeachersArray = [NSMutableArray array];
            favoriteURLArray = [NSMutableArray array];
        }
        int index = [favoriteTitleArray indexOfObject:theTitle];
        [favoriteTitleArray removeObject:theTitle];
        [favoriteURLArray removeObject:websiteURL];
        [favoriteTeachersArray removeObjectAtIndex:index];
        
        NSLog(@"%@",favoriteTitleArray);
        
        
        
        
        [prefs setObject:favoriteTitleArray forKey:@"favoriteTitles"];
        [prefs setObject:favoriteURLArray forKey:@"favoriteSites"];
        [prefs setObject:favoriteTeachersArray forKey:@"favoriteTeachers"];
    }
    else{
        img = [UIImage imageNamed:@"star.png"];
        [prefs setBool:true forKey:fff];
        favorited = TRUE;
        
        
        NSMutableArray *favoriteTitleArray = [[prefs objectForKey:@"favoriteTitles"] mutableCopy];
        NSMutableArray *favoriteURLArray = [[prefs objectForKey:@"favoriteSites"] mutableCopy];
        NSMutableArray *favoriteTeachersArray = [[prefs objectForKey:@"favoriteTeachers"] mutableCopy];
        
        if(favoriteTitleArray == nil){
            NSLog(@"nillllll");
            
            favoriteTitleArray = [NSMutableArray array];
            favoriteTeachersArray = [NSMutableArray array];
            favoriteURLArray = [NSMutableArray array];
        }
        
        [favoriteTitleArray insertObject:theTitle atIndex:0];
        [favoriteURLArray insertObject:websiteURL atIndex:0];
        [favoriteTeachersArray insertObject:teacher atIndex:0];
        
        NSLog(@"%@",favoriteTitleArray);
        
        
        
        
        [prefs setObject:favoriteTitleArray forKey:@"favoriteTitles"];
        [prefs setObject:favoriteURLArray forKey:@"favoriteSites"];
        [prefs setObject:favoriteTeachersArray forKey:@"favoriteTeachers"];
        
        
        
    }
    [favoriteStar setImage:img forState:UIControlStateNormal];
    [prefs synchronize];
    
}

- (IBAction)copyLink:(id)sender {
    UIPasteboard *generalPasteboard = [UIPasteboard generalPasteboard];
    generalPasteboard.string = mp3URL;
    [ToastView showToastInParentView:self.view withText:@"Link was Copied" withDuaration:4.0];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"DIS");
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    if(self.isMovingFromParentViewController || ([tye isEqualToString:@"Back"] && !note)){
        [audioPlayer pause];
        [timer invalidate];
        
        
        [conn cancel];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if(downloading){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR: 116"
                                                            message:@"Audio Could Not Download"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Alright"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }
    
}
-(void) fullertonShowAudio: (NSString*) link{
    NSURL *url = [NSURL URLWithString:link];
    NSString *webData = [NSString stringWithContentsOfURL:url];
    NSError *error;
    
    if (webData == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              url, [error localizedFailureReason]);
        // implementation continues ...
    }
    else{
        if([teacher isEqualToString:@"Ryan Fullerton"] || [imman isEqualToString:@"Immanuel"]){
            //NSLog(@"%@", webData);
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            [searcher moveToString:@"audio/mpeg"];
            mp3URL = [searcher getStringWithLeftBound:@"src=\"" rightBound:@"\""];
            NSLog(@"%@", mp3URL);
            playerURL = [NSURL URLWithString:mp3URL];
        }
    }
}
-(void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    NSLog(@"received event!");
    if (receivedEvent.type == UIEventTypeRemoteControl)
    {
        switch (receivedEvent.subtype)
        {
            case UIEventSubtypeRemoteControlPlay:
                //  play the video
                NSLog(@"play!");
                rate = 1.0;
                [audioPlayer setRate:rate];
                [audioPlayer play];
                break;
                
            case  UIEventSubtypeRemoteControlPause:
                // pause the video
                NSLog(@"pause!");
                [audioPlayer pause];
                break;
                
            case  UIEventSubtypeRemoteControlNextTrack:
                // to change the video
                if(rate < 3.0){
                    rate+=0.05;
                }
                [audioPlayer setRate:rate];
                break;
                
            case  UIEventSubtypeRemoteControlPreviousTrack:
                // to play the privious video
                if(rate > 0.1 ){
                    rate-=0.05;
                }
                [audioPlayer setRate:rate];
                break;
                
            default:
                break;
        }
    }
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}

@end
