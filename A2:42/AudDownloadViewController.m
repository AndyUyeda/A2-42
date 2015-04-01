//
//  AudDownloadViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 7/5/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import "AudDownloadViewController.h"
#import "Social/Social.h"

@interface AudDownloadViewController ()

@end

@implementation AudDownloadViewController{

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

@synthesize theTitle, websiteURL, currentSermon, startTime,endTime, pauseButton,minuteLabel,minuteText,secondLabel,secondText,hourLabel,hourText, undoButton,goButton,teacher;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initPlayer
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    NSError *err;
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    
    audioSession.delegate = self;
    
    [audioSession setActive:YES error:&err];
    
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",theTitle,@".mp3"]]] error:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIImage *img = [UIImage imageNamed:@"slider.png"];
    
    [_slider setThumbImage:img forState:UIControlStateNormal];
    
    currentSermon.text = theTitle;
    currentSermon.numberOfLines = 0;
    currentSermon.textAlignment = NSTextAlignmentCenter;
    [currentSermon sizeToFit];
    currentSermon.center = CGPointMake(160, 134);
    
    [self initPlayer];
    [player play];
    
    NSTimeInterval duration = player.duration;
    totalSeconds = duration;
    
    NSTimeInterval currentTime = player.currentTime;
    currentSeconds = currentTime;
    NSLog(@"duration: %.2f", totalSeconds);
    
    isPaused = false;
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

- (void)update: (NSTimer*) timer {
    //NSLog(@"hello");
    NSTimeInterval currentTime = player.currentTime;
    currentSeconds = currentTime;
    
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
    Float64 sec = (_slider.value) * totalSeconds;
    //int16_t intt = 600;
    //CMTime theTime = CMTimeMakeWithSeconds(sec, intt);
    [player setCurrentTime:sec];
    
}

- (IBAction)paused:(id)sender {
    if(!isPaused){
        isPaused = true;
        [player pause];
        UIImage *img = [UIImage imageNamed:@"play-disabled-1.png"];
        [pauseButton setImage:img forState:UIControlStateNormal];
        
    }
    else{
        UIImage *img = [UIImage imageNamed:@"pause-disabled.png"];
        [pauseButton setImage:img forState:UIControlStateNormal];
        isPaused = false;
        [player play];
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
   
    [player setCurrentTime:totSec];
    
    
}

- (IBAction)tweeted:(id)sender {
    NSString *tweet=[NSString stringWithFormat:@"%@%@", @"\"\" - ",teacher];
    
    SLComposeViewController *tweeter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweeter setInitialText: tweet];
    [self presentViewController:tweeter animated:YES completion:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [player pause];
}

@end
