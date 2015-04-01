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
NSTimer* timer;
BOOL downloading;
NSURL *mpurl;
long long totalFileSize;
NSURLConnection *conn;
BOOL downed;
NSString* playerURL;

@synthesize theTitle, websiteURL, currentSermon, startTime,endTime, pauseButton,minuteLabel,minuteText,secondLabel,secondText,hourLabel,hourText, undoButton,goButton,teacher,showProgress;

- (void)viewDidLoad
{
    [super viewDidLoad];
    fileData = [NSMutableData data];
    downed = false;
	// Do any additional setup after loading the view, typically from a nib.
    UIImage *img = [UIImage imageNamed:@"slider.png"];
    
    [_slider setThumbImage:img forState:UIControlStateNormal];
    
    currentSermon.text = theTitle;
    currentSermon.numberOfLines = 0;
    currentSermon.textAlignment = NSTextAlignmentCenter;
    [currentSermon sizeToFit];
    currentSermon.center = CGPointMake(160, 134);
    
    NSLog(@"%@", websiteURL);
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
        if([teacher isEqualToString:@"Ryan Fullerton"]){
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            [searcher moveToString:@"audio-player"];
            mp3URL = [searcher getStringWithLeftBound:@"src=\"" rightBound:@"\""];
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
            [searcher moveBack:100];
            NSString* str = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            playerURL = [NSString stringWithFormat:@"%@%@",@"http://www.sermonaudio.com/",str];
            [searcher moveToString:@"Download MP3"];
            [searcher moveBack:100];
            mp3URL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            NSLog(@"%@", mp3URL);
        }
        
    }
    
    mpurl = [NSURL URLWithString:@"https://e9ba59974a12f3689b8f1aed539387d3307d6855.googledrive.com/host/0By3E1JDeQzF6VGhNOW5TQVRmWDA/MARK.mp3"];
    audioPlayer = [AVPlayer playerWithURL:mpurl];
    [audioPlayer setVolume: 1.0];
    [audioPlayer play];
    
    
    CMTime duration = audioPlayer.currentItem.asset.duration;
    totalSeconds = CMTimeGetSeconds(duration);
    
    CMTime currentTime = audioPlayer.currentTime;
    currentSeconds = CMTimeGetSeconds(currentTime);
    NSLog(@"duration: %.2f", totalSeconds);
    
    isPaused = false;
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

- (void)update: (NSTimer*) timer {
    //NSLog(@"hello");
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
    
        //NSLog(@"%@",[NSString stringWithFormat:@"%d%@%d%@%@",remainingHour,@":", remainingMinute,@":",rseconds]);
        //NSLog(@"%f",totalSeconds);
        
    }
    
}

- (IBAction)sliderChanged:(id)sender {
    //[audioPlayer pause];
    Float64 sec = (_slider.value) * totalSeconds;
    int16_t intt = 600;
    CMTime theTime = CMTimeMakeWithSeconds(sec, intt);
    [audioPlayer seekToTime:theTime];
    //[audioPlayer play];

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
            NSURL *url = [NSURL URLWithString:playerURL];
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
                NSURL* strURL = [NSURL URLWithString:str];
                NSURLRequest* req = [NSURLRequest requestWithURL:strURL];
                NSLog(@"%@", str);
                conn = [NSURLConnection connectionWithRequest:req delegate:self];
            }
            
        }
        else{
        
            NSURLRequest* req = [NSURLRequest requestWithURL:mpurl];
            NSLog(@"%@", mpurl);
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
    NSLog(@"%f",progressive);
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
    //NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,    NSUserDomainMask, YES);
    //NSLog(@"%@", [dirArray objectAtIndex:0]);
    
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
        
        [prefs setObject:titles forKey:@"sermonTitles"];
        [prefs setObject:teacherNames forKey:@"teacherNames"];
        [prefs synchronize];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Audio Downloaded Successfully"
                                                       delegate:nil
                                              cancelButtonTitle:@"Great"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)tweeted:(id)sender {
    NSString *tweet=[NSString stringWithFormat:@"%@%@", @"\"\" - ",teacher];
    
    SLComposeViewController *tweeter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweeter setInitialText: tweet];
    [self presentViewController:tweeter animated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [audioPlayer pause];
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

@end
