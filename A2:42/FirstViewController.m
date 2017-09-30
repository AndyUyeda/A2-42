//
//  FirstViewController.m
//  Immanuel
//
//  Created by Andy Uyeda on 9/18/15.
//  Copyright © 2015 Andy Uyeda. All rights reserved.
//

#import "FirstViewController.h"
#import "MEStringSearcher.h"
#import "AudioViewController.h"
#import "DateViewController.h"

@interface FirstViewController ()

@end
NSString* currentSermonLink;
NSString* currentSermonTitle;
NSString* currentSermonTeacher;
FirstViewController *th;

NSTimer*timer;
NSTimer*timer2;
bool added;
UIView *original;
NSMutableArray* enterArray;
NSMutableArray* spaceArray;



@implementation FirstViewController

@synthesize currentSermonButton, barButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Immanuel";
    NSLog(@"jump");
    // Do any additional setup after loading the view, typically from a nib.
    spaceArray = [NSMutableArray array];
    enterArray = [NSMutableArray array];
    
    NSURL *url = [NSURL URLWithString:@"http://www.ibclouisville.org/sermons/"];
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
        [searcher moveToString:@"multimedia-posts"];
        currentSermonLink = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
        currentSermonTitle = [searcher getStringWithLeftBound:@"title=\"" rightBound:@"\""];
        [searcher moveToString:@"\"tag\""];
        currentSermonTeacher = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
        currentSermonTitle = [self parseTitle:currentSermonTitle];
        NSString* st= [self resizeTheTitle:currentSermonTitle];
        [currentSermonButton setTitle:st forState:UIControlStateNormal];
        
    }
    
    
    int width = [[UIScreen mainScreen] bounds].size.width;;
    int height = [[UIScreen mainScreen] bounds].size.height;;
    
    //print(bounds.width)
    
    int scaleY = height / 480;
    int scaleX = width / 320;
    NSLog(@"%d",width);
    
    currentSermonButton.titleLabel.numberOfLines = 0;
    [currentSermonButton sizeToFit];
    currentSermonButton.center = CGPointMake(160 * scaleX, 160 * scaleY);
    currentSermonButton.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)currentSermonSelected:(id)sender {
    //[self performSegueWithIdentifier:@"cur" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:(@"cur")]){
        AudioViewController *audio = [[AudioViewController alloc]init];
        audio = [segue destinationViewController];
        audio.theTitle = currentSermonTitle;
        audio.teacher = currentSermonTeacher;
        audio.imman = @"Immanuel";
        audio.websiteURL = currentSermonLink;
        
    }
    if([segue.identifier isEqualToString:(@"date")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.type = @"By Date";
        date.dateURL = @"http://www.ibclouisville.org/sermons/";
        
    }
    if([segue.identifier isEqualToString:(@"speaker")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.type = @"By Speaker";
        date.dateURL = @"http://www.ibclouisville.org/sermons/";
        
    }
    if([segue.identifier isEqualToString:(@"tag")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.type = @"By Tag";
        date.dateURL = @"http://www.ibclouisville.org/sermons/";
        
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
-(NSString *)parseTitle: (NSString *)theTitle
{
    BOOL elipDone = false;
    BOOL aposDone = false;
    BOOL apos2Done = false;
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
    BOOL amper2Done = false;
    BOOL tiltedQuoteDone = false;
    BOOL tiltedQuote2Done = false;
    
    
    while(!elipDone){
        NSRange range = [theTitle rangeOfString:@"&#8230;"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@…%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            elipDone = true;
        }
    }
    
    while(!apos2Done){
        NSRange range = [theTitle rangeOfString:@"‚Äôs"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@'s%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            apos2Done = true;
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
    while(!amper2Done){
        NSRange range = [theTitle rangeOfString:@"&#038;"];
        if(range.location != NSNotFound)
        {
            theTitle = [NSString stringWithFormat:@"%@&%@",
                        [theTitle substringToIndex:range.location],
                        [theTitle substringFromIndex:range.location+range.length]];
        }
        else{
            amper2Done = true;
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
@end
