//
//  AudioViewController.h
//  A2:42
//
//  Created by Andy Uyeda on 6/30/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>

@interface AudioViewController : UIViewController <NSURLConnectionDelegate,UIWebViewDelegate>{
    AVPlayer *audioPlayer;
    NSTimer* timer;
    NSMutableData *fileData;
}


@property (strong, nonatomic)  NSString *theTitle;
@property (strong, nonatomic)  NSString *teacher;
@property (strong, nonatomic)  NSString *tye;
@property (strong, nonatomic)  NSString *corner;
@property (strong, nonatomic)  NSString *imman;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic)  NSString *websiteURL;
@property (weak, nonatomic) IBOutlet UILabel *currentSermon;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UITextField *hourText;
@property (weak, nonatomic) IBOutlet UITextField *minuteText;
@property (weak, nonatomic) IBOutlet UITextField *secondText;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIProgressView *showProgress;
@property (weak, nonatomic) IBOutlet UIButton *favoriteStar;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;


- (IBAction)sliderChanged:(id)sender;
- (IBAction)paused:(id)sender;
- (IBAction)seekPosition:(id)sender;
- (IBAction)undid:(id)sender;
- (IBAction)sought:(id)sender;
- (IBAction)downloaded:(id)sender;
- (IBAction)tweeted:(id)sender;
- (IBAction)favorited:(id)sender;
- (IBAction)copyLink:(id)sender;



@end
