//
//  DesiringGodViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 7/16/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import "DesiringGodViewController.h"
#import "MEStringSearcher.h"
@interface DesiringGodViewController()
@end

@implementation DesiringGodViewController{

}
@synthesize segmentControl,apjPickerView,currentViewButton,poemPickerView,sermonPickerView, listenToButton;

NSArray* sermonViewArray;
NSMutableArray* apjViewArray;
NSMutableArray* apjSiteArray;
NSMutableArray* poemViewArray;
NSMutableArray* poemSiteArray;
NSMutableArray* spaceArray;
NSMutableArray* enterArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    sermonViewArray = [[NSArray alloc] initWithObjects:@"By Date", @"By Topic",@"By Scripture", nil];
    apjViewArray = [NSMutableArray array];
    apjSiteArray = [NSMutableArray array];
    poemViewArray = [NSMutableArray array];
    poemSiteArray = [NSMutableArray array];
    spaceArray = [NSMutableArray array];
    enterArray = [NSMutableArray array];
    
    NSURL *url = [NSURL URLWithString:@"http://www.desiringgod.org/interviews/by-series/ask-pastor-john"];
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
        [searcher moveToString:@"Interviews:"];
        BOOL done = false;
        while (!done) {
            NSString* tilt = [searcher getStringWithLeftBound:@"<h2 class='" rightBound:@"'"];
            if([tilt isEqualToString:@"title"]){
                NSString* theSite = [searcher getStringWithLeftBound:@"<a href='" rightBound:@"'"];
                NSString* site = [NSString stringWithFormat: @"%@%@", @"http://www.desiringgod.org",theSite];
                NSString* title = [searcher getStringWithLeftBound:@">\n" rightBound:@"\n<"];
                
                title = [self parseTitle:title];
                [apjViewArray addObject:title];
                [apjSiteArray addObject:site];
                
            }
            if(tilt == nil){
                done = true;
                //NSLog(@"%@",title);
            }
        }
    }
    
    NSURL *urlP = [NSURL URLWithString:@"http://www.desiringgod.org/poems/all"];
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
        [searcher moveToString:@"abbr-sermon"];
        BOOL done = false;
        while (!done) {
            NSString* tilt = [searcher getStringWithLeftBound:@"<h2 class='" rightBound:@"'>"];
            if([tilt isEqualToString:@"title"]){
                NSString* theSite = [searcher getStringWithLeftBound:@"<a href='" rightBound:@"'"];
                NSString* site = [NSString stringWithFormat: @"%@%@", @"http://www.desiringgod.org",theSite];
                NSString* title = [searcher getStringWithLeftBound:@">\n" rightBound:@"\n<"];
                
                title = [self parseTitle:title];
                [poemViewArray addObject:title];
                [poemSiteArray addObject:site];
                
            }
            if(tilt == nil){
                done = true;
                //NSLog(@"%@",title);
            }
        }
        [searcher moveToBeginning];
        [searcher moveToString:@"pagination"];
        [searcher moveToString:@"page current"];
        NSString* moreItems = [searcher getStringWithLeftBound:@"<span class=\"n" rightBound:@"t\""];
        NSLog(@"%@",moreItems);
        if([moreItems isEqualToString:@"ex"]){
            NSLog(@"here we go");
            NSString* moreURL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            NSString* ss = [NSString stringWithFormat:@"%@%@",@"http://www.desiringgod.org",moreURL];
            [self olderItems:ss old:ss];
        }
        
        
    }
    
    
    
    
    NSLog(@"%d",[poemViewArray count]);
    for(int i = 0;i <[apjViewArray count];i++)
    {
        NSLog(@"%@",[apjViewArray objectAtIndex:i]);
    }
    
    //[currentViewButton setTitle:[apjViewArray objectAtIndex:0] forState:UIControlStateNormal];
    //Everything Is Awesome When You're A Part of A Team
    NSString* st = [self resizeTheTitle:[poemViewArray objectAtIndex:0]];
    [currentViewButton setTitle:st forState:UIControlStateNormal];
    currentViewButton.titleLabel.numberOfLines = 0;
    currentViewButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [currentViewButton sizeToFit];
    currentViewButton.center = CGPointMake(160, 162 + (currentViewButton.frame.size.height / 2));
    if([st length] > 70){
        currentViewButton.center = CGPointMake(160, 138 + (currentViewButton.frame.size.height / 2));
        listenToButton.center = CGPointMake(160, 126);
    }
    //138
    
    
    
}
- (NSString *)resizeTheTitle: (NSString*) string1{
    NSLog(@"%@", string1);
    NSLog(@"%d", string1.length);
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
- (void)olderItems: (NSString*) site old:(NSString*)oldsite{
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
        [searcher moveToString:@"abbr-sermon"];
        BOOL done = false;
        while (!done) {
            NSString* tilt = [searcher getStringWithLeftBound:@"<h2 class='" rightBound:@"'>"];
            if([tilt isEqualToString:@"title"]){
                NSString* theSite = [searcher getStringWithLeftBound:@"<a href='" rightBound:@"'"];
                NSString* _site = [NSString stringWithFormat: @"%@%@", @"http://www.desiringgod.org",theSite];
                NSString* title = [searcher getStringWithLeftBound:@">\n" rightBound:@"\n<"];
                
                title = [self parseTitle:title];
                [poemViewArray addObject:title];
                [poemSiteArray addObject:_site];
                
            }
            if(tilt == nil){
                done = true;
                //NSLog(@"%@",title);
            }
        }
        [searcher moveToBeginning];
        [searcher moveToString:@"pagination"];
        [searcher moveToString:@"page current"];
        NSString* moreItems = [searcher getStringWithLeftBound:@"<span class=\"n" rightBound:@"t\""];
        if([moreItems isEqualToString:@"ex"]){
            NSString* moreURL = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            NSString* ss = [NSString stringWithFormat:@"%@%@",@"http://www.desiringgod.org",moreURL];
            [self olderItems:ss old:ss];
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
    
    if (selectedSegment == 0) {
        [sermonPickerView setHidden:NO];
        [poemPickerView setHidden:YES];
        [apjPickerView setHidden:YES];
    }
    if (selectedSegment == 1) {
        [apjPickerView setHidden:NO];
        [poemPickerView setHidden:YES];
        [sermonPickerView setHidden:YES];
        NSString* st = [self resizeTheTitle:[apjViewArray objectAtIndex:0]];
        [currentViewButton setTitle:st forState:UIControlStateNormal];
        currentViewButton.titleLabel.numberOfLines = 0;
        currentViewButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [currentViewButton sizeToFit];
        currentViewButton.center = CGPointMake(160, 162 + (currentViewButton.frame.size.height / 2));
        if([st length] > 70){
            currentViewButton.center = CGPointMake(160, 138 + (currentViewButton.frame.size.height / 2));
            listenToButton.center = CGPointMake(160, 126);
        }
    }
    if (selectedSegment == 2) {
        [poemPickerView setHidden:NO];
        [apjPickerView setHidden:YES];
        [sermonPickerView setHidden:YES];
        NSString* st = [self resizeTheTitle:[poemViewArray objectAtIndex:0]];
        [currentViewButton setTitle:st forState:UIControlStateNormal];
        currentViewButton.titleLabel.numberOfLines = 0;
        currentViewButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [currentViewButton sizeToFit];
        currentViewButton.center = CGPointMake(160, 162 + (currentViewButton.frame.size.height / 2));
        if([st length] > 70){
            currentViewButton.center = CGPointMake(160, 138 + (currentViewButton.frame.size.height / 2));
            listenToButton.center = CGPointMake(160, 126);
        }
    }
    
    
}
- (IBAction)sermonTapped:(id)sender{

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
    BOOL tiltedQuoteDone = false;
    BOOL tiltedQuote2Done = false;
    BOOL accentDone = false;
    
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
