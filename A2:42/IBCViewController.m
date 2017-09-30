//
//  IBCViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 6/24/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import "IBCViewController.h"
#import "MEStringSearcher.h"
#import "AudioViewController.h"
#import "DateViewController.h"
@interface IBCViewController ()

@end

@implementation IBCViewController{
    
}
NSString *text;
NSString *websiteURL;
int selectedInex;
bool onOurHearts;
NSMutableArray* spaceArray;
NSMutableArray* enterArray;

@synthesize pickerView, pickerViewArray, currentSermon, dateWebsiteArray,selectButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Georgia" size:14.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    onOurHearts = false;
    //NSLog(@"still");
    pickerViewArray = [NSMutableArray array];
    dateWebsiteArray = [NSMutableArray array];
    spaceArray = [NSMutableArray array];
    enterArray = [NSMutableArray array];
    
    //NSLog(@"%d", [pickerViewArray count]);
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Ryan Fullerton";
    
    NSURL *url = [NSURL URLWithString:@"http://www.ibclouisville.org/multimedia-speaker/ryan-fullerton/"];
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
        [pickerViewArray addObject:@"All Sermons"];
        [dateWebsiteArray addObject:@"http://www.ibclouisville.org/multimedia-speaker/ryan-fullerton/"];
        MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
        [searcher moveToString:@"Sermons by Ryan Fullerton"];
        websiteURL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
        text = [searcher getStringWithLeftBound:@"title=\"" rightBound:@"\">"];
        NSLog(@"%@",websiteURL);
        text = [self parseTitle:text];
        NSString* st = [self resizeTheTitle:text];
        [currentSermon setTitle:st forState:UIControlStateNormal];
        
        [searcher moveToString:@"Sermon Archives"];
        BOOL done = false;
        while (!done) {
            NSString *dateURL = [searcher getStringWithLeftBound:@"href='" rightBound:@"'"];
            NSString *date = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
            if(dateURL == nil)
                done = true;
            else{
                [dateWebsiteArray addObject:dateURL];
                [pickerViewArray addObject:date];
            }
        }
        
    }
    
    currentSermon.titleLabel.numberOfLines = 0;
    currentSermon.titleLabel.textAlignment = NSTextAlignmentCenter;
    [currentSermon sizeToFit];
    currentSermon.center = CGPointMake([self view].center.x, 192);
    
    //NSLog(@"%f",currentSermon.center.x);
    
    for(int i = 0; i < dateWebsiteArray.count; i++){
        //NSLog(@"%@", [dateWebsiteArray objectAtIndex:i]);
    }
    //NSLog(@"%d%d", [dateWebsiteArray count], [pickerViewArray count]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerViewArray count];
}
/*- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
 NSString *title = [pickerViewArray objectAtIndex:row];
 NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
 
 return attString;
 
 }*/
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        [tView setFont:[UIFont fontWithName:@"Georgia" size:23.0]];
        tView.textAlignment = NSTextAlignmentCenter;
        tView.textColor = [UIColor whiteColor];
    }
    // Fill the label text here
    tView.text = [pickerViewArray objectAtIndex:row];
    return tView;
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
    return theTitle;
    
}



- (IBAction)dateSelected:(id)sender {
    selectedInex = [pickerView selectedRowInComponent:0];
    if(selectButton.isSelected){
        [self performSegueWithIdentifier:@"audio" sender:self];
    }
}

- (IBAction)onOurHearts:(id)sender {
    onOurHearts = true;
    [self performSegueWithIdentifier:@"date" sender:self];
}

- (IBAction)sermonTapped {
    if(currentSermon.isSelected){
        [self performSegueWithIdentifier:@"date" sender:self];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%@", text);
    if([segue.identifier isEqualToString:(@"audio")]){
        AudioViewController *audio = [[AudioViewController alloc]init];
        audio = [segue destinationViewController];
        audio.theTitle = text;
        audio.teacher = @"Ryan Fullerton";
        NSString *w = [NSString stringWithFormat:@"%@%@",websiteURL, @"?player=audio"];
        NSLog(@"%@",w);
        audio.websiteURL = [NSString stringWithFormat:@"%@%@",websiteURL, @"?player=audio"];
        
    }
    if([segue.identifier isEqualToString:(@"date")]){
        if(onOurHearts){
            DateViewController *datee = [[DateViewController alloc]init];
            datee = [segue destinationViewController];
            datee.date = @"On Our Hearts Podcast";
            datee.dateURL = @"http://www.ibclouisville.org/category/on-our-hearts/";
            datee.teacher = @"Ryan Fullerton";
        }
        else{
            DateViewController *datee = [[DateViewController alloc]init];
            datee = [segue destinationViewController];
            datee.date = [pickerViewArray objectAtIndex:selectedInex];
            datee.dateURL = [dateWebsiteArray objectAtIndex:selectedInex];
            datee.teacher = @"Ryan Fullerton";
        }
        onOurHearts = false;
    }
}
- (NSString *)resizeTheTitle: (NSString*) string1{
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
    
    return string;
}

@end
