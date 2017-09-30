//
//  DesiringGodViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 7/16/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import "DesiringGodViewController.h"
#import "MEStringSearcher.h"
#import "AudioViewController.h"
#import "2DGViewController.h"
@interface DesiringGodViewController()
@end

@implementation DesiringGodViewController{
    
}
@synthesize segmentControl,apjPickerView,currentViewButton,poemPickerView,sermonPickerView, listenToButton,bioPickerView;

NSArray* sermonViewArray;
NSMutableArray* apjViewArray;
NSMutableArray* apjSiteArray;
NSMutableArray* poemViewArray;
NSMutableArray* poemSiteArray;
NSMutableArray* spaceArray;
NSMutableArray* enterArray;
NSMutableArray* bioViewArray;
NSMutableArray* bioSiteArray;
NSTimer* timer;
NSString*tit;
NSString*web;
NSString*randomSermon;
NSString*randomSermonLink;

bool ddd = false;

BOOL stopRecursion = NO;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(self.isMovingFromParentViewController){
        NSLog(@"See Ya");
        stopRecursion = YES;
    }
    else{
        NSLog(@"Haro");
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    stopRecursion = NO;
    ddd = false;
    
    sermonViewArray = [[NSArray alloc] initWithObjects:@"By Date", @"By Topic",@"By Scripture", nil];
    apjViewArray = [NSMutableArray array];
    apjSiteArray = [NSMutableArray array];
    poemViewArray = [NSMutableArray array];
    poemSiteArray = [NSMutableArray array];
    spaceArray = [NSMutableArray array];
    enterArray = [NSMutableArray array];
    bioViewArray = [NSMutableArray array];
    bioSiteArray = [NSMutableArray array];
    
    [self loadDates];
    
    dispatch_queue_t queue = dispatch_queue_create("com.yourdomain.yourappname", NULL);
    dispatch_async(queue, ^{
        //code to be executed in the background
        
        NSURL *url = [NSURL URLWithString:@"http://www.desiringgod.org/ask-pastor-john"];
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
            
            BOOL done = false;
            while (!done) {
                [searcher moveToString:@"EPISODE <span"];
                NSString* tilt = [searcher getStringWithLeftBound:@"class='" rightBound:@"'"];
                if([tilt isEqualToString:@"tile-title"]){
                    NSString* theSite = [searcher getStringWithLeftBound:@"<a href=\"" rightBound:@"\""];
                    NSString* site = [NSString stringWithFormat: @"%@%@", @"http://www.desiringgod.org",theSite];
                    NSString* title = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                    
                    title = [self parseTitle:title];
                    [apjViewArray addObject:title];
                    [apjSiteArray addObject:site];
                    
                }
                if(tilt == nil){
                    done = true;
                    ////NSLog(@"%@",title);
                }
            }
            
            [searcher moveToBeginning];
            [searcher moveToString:@"Load More Episodes"];
            [searcher moveBack:90];
            NSString* moreURL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            NSString* ss = [NSString stringWithFormat:@"%@%@",@"http://www.desiringgod.org",moreURL];
            [self oldAPJ:ss old:ss];
            
        }
        
        
    });
    
    
    
    
    
    NSURL *urlP = [NSURL URLWithString:@"http://www.desiringgod.org/poems"];
    NSString *webDataP = [NSString stringWithContentsOfURL:urlP];
    NSError *errorP;
    if (webDataP == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              urlP, [errorP localizedFailureReason]);
        // implementation continues ...
    }
    else{
        MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webDataP];
        BOOL done = false;
        while(!done){
            [searcher moveToString:@"\"card__inner\""];
            NSString*check = [searcher getStringWithLeftBound:@"<title>" rightBound:@"</title>"];
            if([check isEqualToString:@"Video"] || [check isEqualToString:@"Audio"]){
                [searcher moveToString:@"card--resource__body"];
                [searcher moveToString:@"card--resource__title"];
                NSString *title = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                
                NSString *subTitle = [searcher getStringWithLeftBound:@"class='" rightBound:@"'"];
                if([subTitle isEqualToString:@"card--resource__subtitle"]){
                    NSString *sT = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                    title = [NSString stringWithFormat:@"%@%@%@%@", title, @" (",sT,@")"];
                }
                NSString *site = [searcher getStringWithLeftBound:@"link=\"" rightBound:@"\""];
                if(site == nil || title == nil){
                    done = true;
                }else{
                    title = [self parseTitle:title];
                    NSLog(@"%@", title);
                    [poemSiteArray addObject:site];
                    [poemViewArray addObject:title];
                }
            }
            if(check == nil){
                done = true;
            }
        }
        [searcher moveToBeginning];
        [searcher moveToString:@"pagination"];
        [searcher moveToString:@"page current"];
        NSString* moreItems = [searcher getStringWithLeftBound:@"<span class=\"n" rightBound:@"t\""];
        //NSLog(@"%@",moreItems);
        if([moreItems isEqualToString:@"ex"]){
            //NSLog(@"here we go");
            NSString* moreURL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            NSString* ss = [NSString stringWithFormat:@"%@%@",@"http://www.desiringgod.org",moreURL];
            [self olderItems:ss old:ss ty:@"poem"];
        }
        
        
    }
    
    
    
    NSURL *urlP2 = [NSURL URLWithString:@"http://www.desiringgod.org/topics/christian-biography/messages"];
    NSString *webDataP2 = [NSString stringWithContentsOfURL:urlP2];
    NSError *errorP2;
    if (webDataP2 == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              urlP2, [errorP2 localizedFailureReason]);
        // implementation continues ...
    }
    else{
        MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webDataP2];
        BOOL done = false;
        while(!done){
            [searcher moveToString:@"\"card__inner\""];
            NSString*check = [searcher getStringWithLeftBound:@"<title>" rightBound:@"</title>"];
            if([check isEqualToString:@"Video"] || [check isEqualToString:@"Audio"]){
                [searcher moveToString:@"card--resource__body"];
                [searcher moveToString:@"card--resource__title"];
                NSString *title = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                
                NSString *subTitle = [searcher getStringWithLeftBound:@"class='" rightBound:@"'"];
                if([subTitle isEqualToString:@"card--resource__subtitle"]){
                    NSString *sT = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                    title = [NSString stringWithFormat:@"%@%@%@%@", title, @" (",sT,@")"];
                }
                NSString *site = [searcher getStringWithLeftBound:@"link=\"" rightBound:@"\""];
                if(site == nil || title == nil){
                    done = true;
                }else{
                    title = [self parseTitle:title];
                    NSLog(@"%@", title);
                    [bioSiteArray addObject:site];
                    [bioViewArray addObject:title];
                }
            }
            if(check == nil){
                done = true;
            }
        }
        [searcher moveToBeginning];
        [searcher moveToString:@"pagination"];
        [searcher moveToString:@"page current"];
        NSString* moreItems = [searcher getStringWithLeftBound:@"<span class=\"n" rightBound:@"t\""];
        //NSLog(@"%@",moreItems);
        if([moreItems isEqualToString:@"ex"]){
            //NSLog(@"here we go");
            NSString* moreURL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            NSString* ss = [NSString stringWithFormat:@"%@%@",@"http://www.desiringgod.org",moreURL];
            [self olderItems:ss old:ss ty:@"bio"];
        }
        
        
    }
    //NSLog(@"%d",[poemViewArray count]);
    for(int i = 0;i <[apjViewArray count];i++)
    {
        //NSLog(@"%@",[apjViewArray objectAtIndex:i]);
    }
    
    //[currentViewButton setTitle:[apjViewArray objectAtIndex:0] forState:UIControlStateNormal];
    //Everything Is Awesome When You're A Part of A Team
    NSString* st = [self resizeTheTitle:randomSermon];
    [currentViewButton setTitle:st forState:UIControlStateNormal];
    currentViewButton.titleLabel.numberOfLines = 0;
    currentViewButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [currentViewButton sizeToFit];
    currentViewButton.center = CGPointMake([self view].center.x, 162 + (currentViewButton.frame.size.height / 2));
    if([st length] > 70){
        currentViewButton.center = CGPointMake(160, 138 + (currentViewButton.frame.size.height / 2));
        listenToButton.center = CGPointMake([self view].center.x, 126);
    }
    //138
    
    //[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(update:) userInfo:nil repeats:YES];
    
    timer = [NSTimer timerWithTimeInterval:0.2
                                    target:self
                                  selector:@selector(update:)
                                  userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)update: (NSTimer*) timer {
    [self.apjPickerView reloadAllComponents];
    //NSLog(@"%d",[apjSiteArray count]);
    if(ddd)
    {
        [timer invalidate];
    }
}

-(void)loadDates{
    //NSLog(@"hello");
    NSMutableArray *dates = [NSMutableArray array];
    NSMutableArray *links = [NSMutableArray array];
    
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *links2 = [NSMutableArray array];
    
    NSURL *url = [NSURL URLWithString:@"http://www.desiringgod.org/dates/with-messages"];
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
        [searcher moveToString:@"grouping-index__years"];
        BOOL done = false;
        while(!done){
            NSString*link = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            NSString*date = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
            NSLog(@"%@", date);
            if(date.length == 4){
                [links addObject:link];
                [dates addObject:date];
                
            }
            else{
                done = true;
            }
        }
        int rndValue = 0 + arc4random() % ((dates.count - 1) - 0);
        NSString *s = [NSString stringWithFormat:@"%@%@",@"http://www.desiringgod.org",[links objectAtIndex:rndValue]];
        
        NSLog(@"%@", s);
        
        
        //NSLog(@"%@", s);
        NSURL *url2 = [NSURL URLWithString:s];
        NSString *webData2 = [NSString stringWithContentsOfURL:url2];
        NSError *error;
        if (webData2 == nil) {
            // an error occurred
            NSLog(@"Error reading file at %@\n%@",
                  url2, [error localizedFailureReason]);
            // implementation continues ...
        }
        else{
            //NSLog(@"%@", webData2);
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData2];
            BOOL done = false;
            while(!done){
                [searcher moveToString:@"card--resource__body"];
                [searcher moveToString:@"card--resource__title"];
                NSString *title = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                [searcher moveToString:@"card__author-image"];
                NSString *author = [searcher getStringWithLeftBound:@"div>\n" rightBound:@"\n<"];
                NSString *site = [searcher getStringWithLeftBound:@"link=\"" rightBound:@"\""];
                NSLog(@"%@",author);
                
                if([author isEqualToString:@"John Piper"]){
                    title = [self parseTitle:title];
                    NSLog(@"%@", title);
                    [links2 addObject:site];
                    [titles addObject:title];
                }
                if(site == nil){
                    done = true;
                }
            }
            int rndValue2;
            NSLog(@"%@", titles);
            NSLog(@"%@", links2);
            if(titles.count == 1){
                rndValue2 = 0;
            }
            else{
                rndValue2 = 0 + arc4random() % ((titles.count - 1) - 0);
            }
            randomSermonLink = [links2 objectAtIndex:rndValue2];
            
            randomSermonLink = [randomSermonLink stringByReplacingOccurrencesOfString:@" " withString:@"-"];
            randomSermon = [titles objectAtIndex:rndValue2];
            
            
        }
        
    }
}


-(void)oldAPJ:(NSString*) site old:(NSString*)oldsite{
    
    if(stopRecursion)
        return;
    
    NSURL *urlP = [NSURL URLWithString:site];
    NSString *webDataP = [NSString stringWithContentsOfURL:urlP];
    NSError *errorP;
    if (webDataP == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              urlP, [errorP localizedFailureReason]);
        // implementation continues ...
    }
    else{
        
        MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webDataP];
        BOOL done = false;
        while (!done) {
            
            [searcher moveToString:@"EPISODE <span"];
            NSString* tilt = [searcher getStringWithLeftBound:@"class='" rightBound:@"'"];
            if([tilt isEqualToString:@"tile-title"]){
                NSString* theSite = [searcher getStringWithLeftBound:@"<a href=\"" rightBound:@"\""];
                NSString* site = [NSString stringWithFormat: @"%@%@", @"http://www.desiringgod.org",theSite];
                NSString* title = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                
                title = [self parseTitle:title];
                if(![title isEqual:[apjViewArray objectAtIndex:0]]){
                    [apjViewArray addObject:title];
                    [apjSiteArray addObject:site];
                }
                
            }
            if(tilt == nil){
                done = true;
                ////NSLog(@"%@",title);
            }
        }
        [searcher moveToBeginning];
        [searcher moveToString:@"Load More Episodes"];
        
        [searcher moveBack:90];
        NSString* moreURL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
        NSString* ss = [NSString stringWithFormat:@"%@%@",@"http://www.desiringgod.org",moreURL];
        [self oldAPJ:ss old:ss];
    }
    ddd = true;
}

- (void)olderItems: (NSString*) site old:(NSString*)oldsite ty:(NSString*)typ{
    NSURL *urlP = [NSURL URLWithString:site];
    NSString *webDataP = [NSString stringWithContentsOfURL:urlP];
    NSError *errorP;
    if (webDataP == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              urlP, [errorP localizedFailureReason]);
        // implementation continues ...
    }
    else{
        
        MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webDataP];
        BOOL done = false;
        
        
        while(!done){
            [searcher moveToString:@"\"card__inner\""];
            NSString*check = [searcher getStringWithLeftBound:@"<title>" rightBound:@"</title>"];
            if([check isEqualToString:@"Video"] || [check isEqualToString:@"Audio"]){
                [searcher moveToString:@"card--resource__body"];
                [searcher moveToString:@"card--resource__title"];
                NSString *title = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                
                NSString *subTitle = [searcher getStringWithLeftBound:@"class='" rightBound:@"'"];
                if([subTitle isEqualToString:@"card--resource__subtitle"]){
                    NSString *sT = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                    title = [NSString stringWithFormat:@"%@%@%@%@", title, @" (",sT,@")"];
                }
                NSString *site = [searcher getStringWithLeftBound:@"link=\"" rightBound:@"\""];
                if(site == nil || title == nil){
                    done = true;
                }else{
                    title = [self parseTitle:title];
                    if([typ isEqualToString:@"poem"]){
                        [poemSiteArray addObject:site];
                        [poemViewArray addObject:title];
                    }
                    else if([typ isEqualToString:@"bio"]){
                        [bioSiteArray addObject:site];
                        [bioViewArray addObject:title];
                    }
                }
            }
            if(check == nil){
                done = true;
            }
        }
        [searcher moveToBeginning];
        [searcher moveToString:@"pagination"];
        [searcher moveToString:@"page current"];
        NSString* moreItems = [searcher getStringWithLeftBound:@"<span class=\"n" rightBound:@"t\""];
        if([moreItems isEqualToString:@"ex"]){
            NSString* moreURL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            NSString* ss = [NSString stringWithFormat:@"%@%@",@"http://www.desiringgod.org",moreURL];
            [self olderItems:ss old:ss ty:typ];
        }
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segmentedControlAction:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    NSLog(@"Sender");
    if (selectedSegment == 0) {
        [sermonPickerView setHidden:NO];
        [poemPickerView setHidden:YES];
        [apjPickerView setHidden:YES];
        [bioPickerView setHidden:YES];
        NSString* st = [self resizeTheTitle:randomSermon];
        [currentViewButton setTitle:st forState:UIControlStateNormal];
        currentViewButton.titleLabel.numberOfLines = 0;
        currentViewButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [currentViewButton sizeToFit];
        currentViewButton.center = CGPointMake([self view].center.x, 162 + (currentViewButton.frame.size.height / 2));
        listenToButton.text = @"Random Sermon:";
        listenToButton.textAlignment = NSTextAlignmentCenter;
        if([st length] > 70){
            currentViewButton.center = CGPointMake([self view].center.x, 138 + (currentViewButton.frame.size.height / 2));
            listenToButton.center = CGPointMake([self view].center.x, 126);
        }
    }
    if (selectedSegment == 1) {
        [apjPickerView setHidden:NO];
        [poemPickerView setHidden:YES];
        [sermonPickerView setHidden:YES];
        [bioPickerView setHidden:YES];
        NSString* st = [self resizeTheTitle:[apjViewArray objectAtIndex:0]];
        [currentViewButton setTitle:st forState:UIControlStateNormal];
        currentViewButton.titleLabel.numberOfLines = 0;
        currentViewButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [currentViewButton sizeToFit];
        currentViewButton.center = CGPointMake([self view].center.x, 162 + (currentViewButton.frame.size.height / 2));
        listenToButton.text = @"Listen to:";
        listenToButton.textAlignment = NSTextAlignmentCenter;
        if([st length] > 70){
            currentViewButton.center = CGPointMake([self view].center.x, 138 + (currentViewButton.frame.size.height / 2));
            listenToButton.center = CGPointMake([self view].center.x, 126);
        }
    }
    if (selectedSegment == 2) {
        [poemPickerView setHidden:NO];
        [apjPickerView setHidden:YES];
        [sermonPickerView setHidden:YES];
        [bioPickerView setHidden:YES];
        NSString* st = [self resizeTheTitle:[poemViewArray objectAtIndex:0]];
        [currentViewButton setTitle:st forState:UIControlStateNormal];
        currentViewButton.titleLabel.numberOfLines = 0;
        currentViewButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [currentViewButton sizeToFit];
        currentViewButton.center = CGPointMake([self view].center.x, 162 + (currentViewButton.frame.size.height / 2));
        listenToButton.text = @"Listen to:";
        listenToButton.textAlignment = NSTextAlignmentCenter;
        if([st length] > 70){
            currentViewButton.center = CGPointMake([self view].center.x, 138 + (currentViewButton.frame.size.height / 2));
            listenToButton.center = CGPointMake([self view].center.x, 126);
        }
    }
    if (selectedSegment == 3) {
        [poemPickerView setHidden:YES];
        [apjPickerView setHidden:YES];
        [sermonPickerView setHidden:YES];
        [bioPickerView setHidden:NO];
        NSString* st = [self resizeTheTitle:[bioViewArray objectAtIndex:0]];
        [currentViewButton setTitle:st forState:UIControlStateNormal];
        currentViewButton.titleLabel.numberOfLines = 0;
        currentViewButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [currentViewButton sizeToFit];
        currentViewButton.center = CGPointMake([self view].center.x, 162 + (currentViewButton.frame.size.height / 2));
        listenToButton.text = @"Listen to:";
        listenToButton.textAlignment = NSTextAlignmentCenter;
        if([st length] > 70){
            currentViewButton.center = CGPointMake([self view].center.x, 138 + (currentViewButton.frame.size.height / 2));
            listenToButton.center = CGPointMake([self view].center.x, 126);
        }
    }
    
    
}

- (IBAction)selected:(id)sender {
    NSLog(@"Hit");
    
    if([segmentControl selectedSegmentIndex] == 0){
        
        [self performSegueWithIdentifier:@"dg" sender:self];
    }
    
    if([segmentControl selectedSegmentIndex] == 1){
        tit = [apjViewArray objectAtIndex:[apjPickerView selectedRowInComponent:0]];
        web = [apjSiteArray objectAtIndex:[apjPickerView selectedRowInComponent:0]];
        
        [self performSegueWithIdentifier:@"apj" sender:self];
    }
    if([segmentControl selectedSegmentIndex] == 2){
        tit = [poemViewArray objectAtIndex:[poemPickerView selectedRowInComponent:0]];
        web = [poemSiteArray objectAtIndex:[poemPickerView selectedRowInComponent:0]];
        
        [self performSegueWithIdentifier:@"apj" sender:self];
    }
    if([segmentControl selectedSegmentIndex] == 3){
        tit = [bioViewArray objectAtIndex:[bioPickerView selectedRowInComponent:0]];
        web = [bioSiteArray objectAtIndex:[bioPickerView selectedRowInComponent:0]];
        
        [self performSegueWithIdentifier:@"apj" sender:self];
    }
    
    
}
- (IBAction)sermonTapped:(id)sender{
    
    if([segmentControl selectedSegmentIndex] == 0){
        tit = randomSermon;
        web = randomSermonLink;
        
        [self performSegueWithIdentifier:@"apj" sender:self];
    }
    
    if([segmentControl selectedSegmentIndex] == 1){
        tit = [apjViewArray objectAtIndex:0];
        web = [apjSiteArray objectAtIndex:0];
        
        [self performSegueWithIdentifier:@"apj" sender:self];
    }
    if([segmentControl selectedSegmentIndex] == 2){
        tit = [poemViewArray objectAtIndex:0];
        web = [poemSiteArray objectAtIndex:0];
        
        [self performSegueWithIdentifier:@"apj" sender:self];
    }
    if([segmentControl selectedSegmentIndex] == 3){
        tit = [bioViewArray objectAtIndex:0];
        web = [bioSiteArray objectAtIndex:0];
        
        [self performSegueWithIdentifier:@"apj" sender:self];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:(@"apj")]){
        AudioViewController *audio = [[AudioViewController alloc]init];
        audio = [segue destinationViewController];
        audio.theTitle = tit;
        audio.teacher = @"John Piper";
        audio.websiteURL = web;
        
    }
    if([segue.identifier isEqualToString:(@"dg")]){
        _DGViewController *dg = [[_DGViewController alloc]init];
        dg = [segue destinationViewController];
        if([sermonPickerView selectedRowInComponent:0] == 0){
            NSLog(@"1");
            dg.type = @"By Date";
        }
        else if([sermonPickerView selectedRowInComponent:0] == 1){
            NSLog(@"2");
            dg.type = @"By Topic";
        }
        else{
            NSLog(@"3");
            dg.type = @"By Scripture";
        }
        
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == apjPickerView){
        return [apjViewArray count];
    }
    else if(pickerView == poemPickerView){
        return [poemViewArray count];
    }
    else if(pickerView == bioPickerView){
        return [bioViewArray count];
    }
    else{
        return [sermonViewArray count];
    }
    
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == apjPickerView){
        NSString *title = [apjViewArray objectAtIndex:row];
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else if(pickerView == poemPickerView){
        NSString *title = [poemViewArray objectAtIndex:row];
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else if(pickerView == bioPickerView){
        NSString *title = [bioViewArray objectAtIndex:row];
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else{
        NSString *title = [sermonViewArray objectAtIndex:row];
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if(pickerView == apjPickerView){
        UILabel* tView = (UILabel*)view;
        if (!tView){
            tView = [[UILabel alloc] init];
            CGRect frame = CGRectMake(0,0,265,40);
            tView = [[UILabel alloc] initWithFrame:frame];
            [tView setFont:[UIFont systemFontOfSize:12]];
            [tView setTextColor:[UIColor whiteColor]];
            
            [tView setLineBreakMode:UILineBreakModeWordWrap];
            [tView setTextAlignment:UITextAlignmentCenter];
            [tView setNumberOfLines:0];
        }
        tView.text = [apjViewArray objectAtIndex:row];
        
        return tView;
    }
    else if(pickerView == poemPickerView){
        UILabel* tView = (UILabel*)view;
        if (!tView){
            tView = [[UILabel alloc] init];
            CGRect frame = CGRectMake(0,0,265,40);
            tView = [[UILabel alloc] initWithFrame:frame];
            [tView setFont:[UIFont systemFontOfSize:12]];
            [tView setTextColor:[UIColor whiteColor]];
            
            [tView setLineBreakMode:UILineBreakModeWordWrap];
            [tView setTextAlignment:UITextAlignmentCenter];
            [tView setNumberOfLines:0];
        }
        tView.text = [poemViewArray objectAtIndex:row];
        
        return tView;
    }
    else if(pickerView == bioPickerView){
        UILabel* tView = (UILabel*)view;
        if (!tView){
            tView = [[UILabel alloc] init];
            CGRect frame = CGRectMake(0,0,265,40);
            tView = [[UILabel alloc] initWithFrame:frame];
            [tView setFont:[UIFont systemFontOfSize:12]];
            [tView setTextColor:[UIColor whiteColor]];
            
            [tView setLineBreakMode:UILineBreakModeWordWrap];
            [tView setTextAlignment:UITextAlignmentCenter];
            [tView setNumberOfLines:0];
        }
        tView.text = [bioViewArray objectAtIndex:row];
        
        return tView;
    }
    else{
        UILabel* tView = (UILabel*)view;
        if (!tView){
            tView = [[UILabel alloc] init];
            CGRect frame = CGRectMake(0,0,265,40);
            tView = [[UILabel alloc] initWithFrame:frame];
            [tView setFont:[UIFont systemFontOfSize:12]];
            [tView setTextColor:[UIColor whiteColor]];
            
            [tView setLineBreakMode:UILineBreakModeWordWrap];
            [tView setTextAlignment:UITextAlignmentCenter];
            [tView setNumberOfLines:0];
        }
        tView.text = [sermonViewArray objectAtIndex:row];
        
        return tView;
    }
}



//Make sure that the title has the correct amount of lines
- (NSString *)resizeTheTitle: (NSString*) string1{
    //NSLog(@"%@", string1);
    //NSLog(@"%d", string1.length);
    NSMutableString* string = [string1 mutableCopy];
    NSString* stng = [string1 mutableCopy];
    BOOL done = FALSE;
    NSUInteger oldloc = 0;
    NSUInteger add = 0;
    NSRange ranger = [stng rangeOfString:@" "];
    if (ranger.location != NSNotFound)
    {
        while(!done){
            NSRange range = [stng rangeOfString:@" "];
            if (range.location != NSNotFound)
            {
                if(range.location >= [stng length]){
                    done = TRUE;
                }
                else{
                    add+= oldloc;
                    [spaceArray addObject:[NSNumber numberWithInteger: (range.location + add)]];
                    oldloc = range.location + 1;
                    NSRange ran = NSMakeRange(oldloc, [stng length] - oldloc);
                    stng = [stng substringWithRange:ran];
                }
            }
            else{
                done = TRUE;
            }
        }
        [spaceArray addObject:[NSNumber numberWithInteger: [string1 length]]];
        [enterArray addObject:[NSNumber numberWithInteger: 0]];
        
        for(int i = 0; i< [spaceArray count];i++){
            NSRange rag = NSMakeRange([[enterArray objectAtIndex:[enterArray count]-1] integerValue], [[spaceArray objectAtIndex:i] integerValue] - [[enterArray objectAtIndex:[enterArray count]-1] integerValue]);
            NSString* str = [string1 substringWithRange:rag];
            CGSize textSize = [str sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Georgia-Bold" size:23.0] }];
            if(textSize.width >= 270){
                if(i==0){
                    for(int j = 0; j < [str length];j++){
                        NSRange rag2 = NSMakeRange(0, j);
                        NSString* str2 = [string1 substringWithRange:rag2];
                        CGSize textSize2 = [str2 sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Georgia-Bold" size:23.0] }];
                        if(textSize2.width >= 270){
                            [enterArray addObject:[NSNumber numberWithInteger:j]];
                            [string insertString:@"-" atIndex:j-1];
                            break;
                        }
                    }
                    
                }
                else{
                    [enterArray addObject: [spaceArray objectAtIndex:i-1]];
                }
            }
            
        }
        
        for(int k = [enterArray count] - 1; k > 0 ;k--){
            [string insertString:@"\n" atIndex:[[enterArray objectAtIndex:k] integerValue]];
        }
    }
    else{
        [enterArray addObject:[NSNumber numberWithInteger: 0]];
        for(int i = 0; i < [string length];i++){
            NSRange rag = NSMakeRange([[enterArray objectAtIndex:[enterArray count]-1] integerValue], i - [[enterArray objectAtIndex:[enterArray count]-1] integerValue]);
            NSString* str = [string1 substringWithRange:rag];
            CGSize textSize = [str sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Georgia-Bold" size:23.0] }];
            if(textSize.width >= 270){
                [enterArray addObject:[NSNumber numberWithInteger:i]];
            }
            
        }
        for(int i = [enterArray count] - 1; i > 0 ;i--){
            [string insertString:@"-\n" atIndex:[[enterArray objectAtIndex:i] integerValue]];
        }
        
    }
    [enterArray removeAllObjects];
    [spaceArray removeAllObjects];
    
    return string;
}



-(NSString *)parseTitle: (NSString *)theTitle
{
    BOOL aposDone = false;
    BOOL begQuoDone = false;
    BOOL endQuoDone = false;
    BOOL strongDone = false;
    BOOL endStrongDone = false;
    BOOL indentDone = false;
    BOOL enterDone = false;
    BOOL breakDone = false;
    BOOL divDone = false;
    BOOL ltrDone = false;
    BOOL nbspDone = false;
    BOOL backdivDone = false;
    BOOL backBreakDone = false;
    BOOL dotDone = false;
    BOOL italDone = false;
    BOOL ital1Done = false;
    BOOL amperDone = false;
    BOOL apsDone = false;
    BOOL aps2Done = false;
    BOOL aps3Done = false;
    BOOL tiltedQuoteDone = false;
    BOOL tiltedQuote2Done = false;
    BOOL accentDone = false;
    BOOL longDash = false;
    BOOL dotdotdot = false;
    
    while(!accentDone){
        NSRange range = [theTitle rangeOfString:@"√©?"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@é%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            accentDone = true;
        }
        
    }
    
    while(!longDash){
        NSRange range = [theTitle rangeOfString:@"‚Äî"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@—%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            longDash = true;
        }
        
    }
    
    while(!dotdotdot){
        NSRange range = [theTitle rangeOfString:@"&#8230;"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@...%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            dotdotdot = true;
        }
        
    }
    
    while(!aps3Done){
        NSRange range = [theTitle rangeOfString:@"&#39;"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@'%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            aps3Done = true;
        }
        
    }
    
    while(!aposDone){
        NSRange range = [theTitle rangeOfString:@"&#8217;"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@'%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            aposDone = true;
        }
        
    }
    while(!apsDone){
        NSRange range = [theTitle rangeOfString:@"‚Äô"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@'%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            apsDone = true;
        }
        
    }
    while(!aps2Done){
        NSRange range = [theTitle rangeOfString:@"‚Äò"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@'%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            aps2Done = true;
        }
        
    }
    while(!begQuoDone){
        NSRange range = [theTitle rangeOfString:@"&#8220;"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@\"%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            begQuoDone = true;
        }
    }
    
    while(!endQuoDone){
        NSRange range = [theTitle rangeOfString:@"&#8221;"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@\"%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            endQuoDone = true;
        }
    }
    while(!strongDone){
        NSRange range = [theTitle rangeOfString:@"<strong>"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            strongDone = true;
        }
        
    }
    while(!endStrongDone){
        NSRange range = [theTitle rangeOfString:@"</strong>"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            endStrongDone = true;
        }
    }
    while(!indentDone){
        NSRange range = [theTitle rangeOfString:@"<p>"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@\t%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            indentDone = true;
        }
    }
    while(!enterDone){
        NSRange range = [theTitle rangeOfString:@"</p>"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@\n%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            enterDone = true;
        }
    }
    while(!enterDone){
        NSRange range = [theTitle rangeOfString:@"</p>"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@\n%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            enterDone = true;
        }
    }
    while(!breakDone){
        NSRange range = [theTitle rangeOfString:@"<br>"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            breakDone = true;
        }
    }
    while(!amperDone){
        NSRange range = [theTitle rangeOfString:@"&amp;"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@&%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            amperDone = true;
        }
    }
    while(!divDone){
        NSRange range = [theTitle rangeOfString:@"<div>"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@\t%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            divDone = true;
        }
    }
    while(!ltrDone){
        NSRange range = [theTitle rangeOfString:@"<p dir=\"ltr\">"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@\t%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            ltrDone = true;
        }
    }
    while(!nbspDone){
        NSRange range = [theTitle rangeOfString:@"&nbsp;"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            nbspDone = true;
        }
    }
    while(!backBreakDone){
        NSRange range = [theTitle rangeOfString:@"<br />"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            backBreakDone = true;
        }
    }
    while(!backdivDone){
        NSRange range = [theTitle rangeOfString:@"</div>"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            backdivDone = true;
        }
    }
    while(!dotDone){
        NSRange range = [theTitle rangeOfString:@" "];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@ %@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            dotDone = true;
        }
    }
    while(!italDone){
        NSRange range = [theTitle rangeOfString:@"<em>"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            italDone = true;
        }
    }
    
    while(!ital1Done){
        NSRange range = [theTitle rangeOfString:@"</em>"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            ital1Done = true;
        }
    }
    while(!tiltedQuoteDone){
        NSRange range = [theTitle rangeOfString:@"‚Äú"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@\"%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            tiltedQuoteDone = true;
        }
    }
    while(!tiltedQuote2Done){
        NSRange range = [theTitle rangeOfString:@"‚Äù"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@\"%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            tiltedQuote2Done = true;
        }
    }
    return theTitle;
}

@end
