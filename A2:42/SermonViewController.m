//
//  FirstViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 6/24/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import "SermonViewController.h"
#import "IBCViewController.h"
#import "DateViewController.h"
#import "DesiringGodViewController.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "MoreViewController.h"
#import "AppDelegate.h"
#import "MEStringSearcher.h"
@interface SermonViewController ()

@end

@implementation SermonViewController
@synthesize seen;

SermonViewController *th;

NSTimer*timer;
NSTimer*timer2;
bool added;
bool attempted = false;
UIView *original;


-(void) viewWillAppear:(BOOL)animated{
    
    
    AppDelegate *appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    appDel.sharedItem = @"2";
    [self.view setUserInteractionEnabled:YES];
    [self.navigationController setNavigationBarHidden:FALSE];
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
   
    self.revealViewController.delegate = self;
   
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
   
    added = true;
    
    self.navigationController.navigationBar.topItem.title = @"Preachers";
    self.navigationController.navigationBar.topItem.leftBarButtonItem = _barButton;
    self.navigationController.navigationBar.topItem.rightBarButtonItem = _infoButton;
    
    th = self;
    
    [super viewWillAppear:YES];
    
    
    timer2 = [NSTimer timerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(update3:)
                                   userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
}

- (void)update3: (NSTimer*) timer {
    if(!attempted){
        attempted = true;
        @try {
            NSURL *url = [NSURL URLWithString:@"https://sites.google.com/site/atwofourtwo/"];
            NSString *webData = [NSString stringWithContentsOfURL:url];
            NSError *error;
            if (webData == nil) {
                // an error occurred
                NSLog(@"Error reading file at %@\n%@",
                      url, [error localizedFailureReason]);
                // implementation continues ...
            }
            else{
                MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                NSString* notification = [searcher getStringWithLeftBound:@"Notification *" rightBound:@"*"];
                NSLog(@"%@", notification);
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSString *savedNotif = [prefs stringForKey:@"notification"];
                if(![notification isEqualToString:savedNotif]){
                    UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Notification" message:notification delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [warningAlert show];
                    [prefs setObject:notification forKey:@"notification"];
                    [prefs synchronize];
                }
            }
            
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
    }
    if([self.view isEqual:original]){
       
    }
    
    AppDelegate *appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSString *receivingObj = appDel.sharedItem;
    
    if(![receivingObj isEqualToString:@"3"]){
        
       
        
        
    }
    
    if([receivingObj isEqualToString:@"3"]){
        added = false;
    }
    if([receivingObj isEqualToString:@"2"] && added == false &&[self.view isEqual:original]){
        added = true;
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    if([receivingObj isEqualToString:@"2"]){
        [self.view setUserInteractionEnabled:YES];
        
        
    }
    else{
        [self.view setUserInteractionEnabled:NO];
    }
    
}
-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position{
    
    if (th.isViewLoaded && th.view.window) {
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        AppDelegate *appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
        appDel.sharedItem = @"3";
        
    }
    
    
    
    if (position == FrontViewPositionLeft){
        
        [self.view setUserInteractionEnabled:YES];
        
    }
    else{
        
        [self.view setUserInteractionEnabled:NO];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    original = self.view;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    self.navigationController.navigationBar.topItem.title = @"Preachers";
    self.navigationController.navigationBar.topItem.leftBarButtonItem = _barButton;
    
    th = self;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    @try {
        NSURL *url = [NSURL URLWithString:@"https://sites.google.com/site/atwofourtwo/"];
        NSString *webData = [NSString stringWithContentsOfURL:url];
        NSError *error;
        if (webData == nil) {
            // an error occurred
            NSLog(@"Error reading file at %@\n%@",
                  url, [error localizedFailureReason]);
            // implementation continues ...
        }
        else{
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            NSString* notification = [searcher getStringWithLeftBound:@"Notification *" rightBound:@"*"];
            NSLog(@"%@", notification);
            
            NSString *savedNotif = [prefs stringForKey:@"notification"];
            if(![notification isEqualToString:savedNotif]){
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Notification" message:notification delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
                [prefs setObject:notification forKey:@"notification"];
                [prefs synchronize];
            }
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    NSLog([prefs boolForKey:@"lock"] ? @"Yes" : @"No");
    if(![prefs boolForKey:@"lock"]){
        [self performSegueWithIdentifier:@"lock" sender:self];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:(@"washer")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"Paul Washer";
        date.date = @"Paul Washer";
        date.dateURL = @"http://illbehonest.com/author/paul-washer";
    }
    
    if([segue.identifier isEqualToString:(@"conway")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"Tim Conway";
        date.date = @"Tim Conway";
        date.dateURL = @"http://illbehonest.com/author/tim-conway";
    }
    
    if([segue.identifier isEqualToString:(@"voddie")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"Voddie Baucham";
        date.date = @"Voddie Baucham";
        date.dateURL = @"http://www.sermonaudio.com/search.asp?speakeronly=true&currsection=sermonsspeaker&keyword=Voddie_Baucham";
    }
    if([segue.identifier isEqualToString:(@"petty")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"Kenny Petty";
        date.date = @"Kenny Petty";
        date.dateURL = @"http://www.sermonaudio.com/search.asp?speakeronly=true&currsection=sermonsspeaker&keyword=Kenny_Petty";
    }
    if([segue.identifier isEqualToString:(@"mershon")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"Jason Lancaster";
        date.date = @"Jason Lancaster";
        date.dateURL = @"http://ebfchurch.org/resources/sermons";
    }
    if([segue.identifier isEqualToString:(@"azurdia")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"Art Azurdia";
        date.date = @"Art Azurdia";
        date.dateURL = @"http://www.trinityportland.com/sermons/preacher/u/3/art-azurdia";
    }
    /*if([segue.identifier isEqualToString:(@"onwuchekwa")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"John Onwuchekwa";
        date.date = @"John Onwuchekwa";
        date.dateURL = @"http://blueprintchurch.org/speaker/john-onwuchekwa/";
    }*/
    if([segue.identifier isEqualToString:(@"harmon")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"Spencer Harmon";
        date.date = @"Spencer Harmon";
        date.dateURL = @"http://www.vinestreetbaptist.org/sermons/?sermon_speaker=sharmon&sermon_series&sermon_service&sermon_topic&submit=Filter+Sermons";
    }
    if([segue.identifier isEqualToString:(@"trip")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"Shai Linne";
        date.date = @"Shai Linne";
        date.dateURL = @"https://rcfphilly.com/weekly-sermons/preacher/shai-linne/";
    }
    if([segue.identifier isEqualToString:(@"piper")]){
        DesiringGodViewController *desiring = [[DesiringGodViewController alloc]init];
        desiring = [segue destinationViewController];
    }
    if([segue.identifier isEqualToString:(@"powell")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"Brian Powell";
        date.date = @"Brian Powell";
        date.dateURL = @"http://www.holycitychurch.net/sermons/";
    }
    if([segue.identifier isEqualToString:(@"gundersen")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"Gunner Gundersen";
        date.date = @"Gunner Gundersen";
        date.dateURL = @"http://www.bridgepointbible.org/media/audio";
    }
    
}

- (IBAction)fullertonPressed:(id)sender {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [self.view setUserInteractionEnabled:NO];
    HUD.labelText = @"Loading";
    HUD.labelFont = [UIFont fontWithName:@"Georgia" size:18];
    HUD.delegate = self;
    [HUD show:YES];
    
    timer = [NSTimer timerWithTimeInterval:0.1
                                    target:self
                                  selector:@selector(update:)
                                  userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (IBAction)piperPressed:(id)sender {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [self.view setUserInteractionEnabled:NO];
    HUD.labelText = @"Loading";
    HUD.labelFont = [UIFont fontWithName:@"Georgia" size:18];
    HUD.delegate = self;
    [HUD show:YES];
    
    timer = [NSTimer timerWithTimeInterval:0.1
                                    target:self
                                  selector:@selector(update2:)
                                  userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (IBAction)unlock:(id)sender {
}

- (void)update: (NSTimer*) timer {
    [self performSegueWithIdentifier:@"ibc" sender:self];
    [timer invalidate];
}
- (void)update2: (NSTimer*) timer {
    [self performSegueWithIdentifier:@"piper" sender:self];
    [timer invalidate];
}

-(void)viewDidDisappear:(BOOL)animated{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.view setUserInteractionEnabled:NO];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    AppDelegate *appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSString *receivingObj = appDel.sharedItem;
    
}


@end
