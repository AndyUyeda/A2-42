//
//  AudDownloadViewController.h
//  A2:42
//
//  Created by Andy Uyeda on 7/5/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudDownloadViewController : UIViewController{
    AVAudioPlayer *player;
}

@property (weak, nonatomic)  NSString *imman;
@property (weak, nonatomic)  NSString *type;
@property (weak, nonatomic)  NSString *theTitle;
@property (weak, nonatomic)  NSString *teacher;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic)  NSString *websiteURL;
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
@property (weak, nonatomic) IBOutlet UIButton *favoriteStar;
@property (weak, nonatomic) IBOutlet UIButton *startTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cropButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *copButton;



- (IBAction)sliderChanged:(id)sender;
- (IBAction)paused:(id)sender;
- (IBAction)seekPosition:(id)sender;
- (IBAction)undid:(id)sender;
- (IBAction)sought:(id)sender;
- (IBAction)tweeted:(id)sender;
- (IBAction)favorited:(id)sender;
- (IBAction)crop:(id)sender;
- (IBAction)backToStart:(id)sender;
- (IBAction)shareClip:(id)sender;
- (IBAction)copied:(id)sender;
- (IBAction)editCroppedTitle:(id)sender;



@end
