//
//  SecondViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 6/24/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"http://www.renovationchurch.com/wp-content/files_mf/1395241431BlindSighted.mp3"];
    //http://media.sermonaudio.com/sermons038/62314193995c.m3u"];
    audioPlayer = [AVPlayer playerWithURL:url];
    //audioPlayer.play;
    [self initPlayer];
    [player play];
    
}

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
    
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/audio.mp3"]] error:nil];
    
}


@end
