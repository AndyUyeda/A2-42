//
//  ArchiveViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 7/8/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import "DateViewController.h"
#import "MEStringSearcher.h"
#import "AudioViewController.h"
#import "ArchiveViewController.h"
@interface ArchiveViewController()
@end

@implementation ArchiveViewController{
    
}
@synthesize date,dateURL, teacher,tableView, type;

NSMutableArray *titleList_;
NSMutableArray *urlList_;
NSMutableArray *jumpToArray;

BOOL doneLoadin;
BOOL stopRecurrsion;
int counter;


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(self.isMovingFromParentViewController){
        NSLog(@"See Ya");
        stopRecurrsion = YES;
    }
    else{
        NSLog(@"Haro");
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [tableView reloadData];
    self.navigationItem.title = @"Immanuel";
}
- (void)viewDidLoad
{
    doneLoadin = FALSE;
    [super viewDidLoad];
    //self.navigationController.navigationBar.translucent = NO;
    stopRecurrsion = NO;
    counter = 0;
    titleList_ = [NSMutableArray array];
    urlList_ = [NSMutableArray array];
    jumpToArray = [NSMutableArray array];
    
    
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.001
                                             target:self
                                           selector:@selector(update:)
                                           userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       //do something expensive
                       NSURL *url = [NSURL URLWithString:dateURL];
                       NSString *webData = [NSString stringWithContentsOfURL:url];
                       NSError *error;
                       if (webData == nil) {
                           // an error occurred
                           NSLog(@"Error reading file at %@\n%@",
                                 url, [error localizedFailureReason]);
                           // implementation continues ...
                           
                       }
                       else{
                           //NSLog(@"%@",webData);
                           
                           MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                           if([type isEqualToString:@"By Speaker"]){
                               [searcher moveToString:@"Sermon Speakers"];
                               [searcher moveToString:@"Select One"];
                               BOOL done = false;
                               while (!done) {
                                   NSString *title = [searcher getStringWithLeftBound:@"\">" rightBound:@"&nbsp;&"];
                                   NSString *spaces = [title stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                                   NSString *periods = [spaces stringByReplacingOccurrencesOfString:@"." withString:@"-"];
                                   NSString* link = [NSString stringWithFormat:@"%@%@",@"http://www.ibclouisville.org/multimedia-speaker/",periods];
                                   NSLog(@"%@",link);
                                   if(title == nil)
                                       done = true;
                                   else{
                                       [titleList_ addObject:title];
                                       [urlList_ addObject:link];
                                       
                                   }
                                   
                               }
                           }
                           
                           if([type isEqualToString:@"By Date"]){
                               [searcher moveToBeginning];
                               [searcher moveToString:@"Sermon Archives"];
                               BOOL done = false;
                               while (!done) {
                                   NSString *dateUR = [searcher getStringWithLeftBound:@"href='" rightBound:@"'"];
                                   NSString *dat = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                                   if(dateUR == nil)
                                       done = true;
                                   else{
                                       [titleList_ addObject:dat];
                                       [urlList_ addObject:dateUR];
                                   }
                               }
                           }
                           if([type isEqualToString:@"By Tag"]){
                               [searcher moveToString:@"All Sermon Tags"];
                               [searcher moveToString:@"Select One"];
                               BOOL done = false;
                               int c = 0;
                               while (!done) {
                                   NSString *title = [searcher getStringWithLeftBound:@"\">" rightBound:@"&nbsp;&"];
                                   NSString *spaces = [title stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                                   NSString *periods = [spaces stringByReplacingOccurrencesOfString:@"." withString:@"-"];
                                   NSString* link = [NSString stringWithFormat:@"%@%@",@"http://www.ibclouisville.org/multimedia-tag/",periods];
                                   NSLog(@"%@",link);
                                   c++;
                                   NSString* fst = [title substringToIndex:1];
                                   if([fst isEqualToString:@"<"] && c >=20)
                                       done = true;
                                   else{
                                       [titleList_ addObject:title];
                                       [urlList_ addObject:link];
                                       
                                   }
                                   
                               }
                           }
                       }
                       NSLog(@"%@",type);
                       
                       
                       
                       for(int i = 0; i < [titleList_ count];i++){
                           //NSLog(@"%@",[titleList_ objectAtIndex:i]);
                       }
                       //NSLog(@"%d",[titleList_ count]);
                       
                       //dispatch back to the main (UI) thread to stop the activity indicator
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          doneLoadin = TRUE;
                                          [timer invalidate];
                                          [tableView reloadData];
                                          
                                      });
                   });
    
    
    
}

- (void)update: (NSTimer*) timer {
    //if([type isEqualToString:@"By Scripture"]){
    counter++;
    if(counter > 100){
        counter=0;
        [tableView reloadData];
    }
    /*}
     else{
     [tableView reloadData];
     }*/
    //NSLog(@"%d",[titleList_ count]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [titleList_ count]; //change
    
}
- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableViews dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    cell.textLabel.text = [titleList_ objectAtIndex:indexPath.row];
    
    
    
    
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    //cell.imageView.image = [images objectAtIndex:indexPath.row];
    
    
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = @"Date";
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:12.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return 30;
}
- (NSString *)tableView:(UITableView *)tableViews titleForHeaderInSection:(NSInteger)section
{
    
    NSString *title = date;
    if(!doneLoadin){
        title = @"Loading...";
    }
    else if([titleList_ count] == 0){
        title = @"No Sermons Found";
    }
    else{
        if([type isEqualToString:@"By Date"]){
            title = [NSString stringWithFormat:@"%@%@%lu%@", @"Dates", @" - (",(unsigned long)[titleList_ count],@")"];
        }
        else if([type isEqualToString:@"By Speaker"]){
            title = [NSString stringWithFormat:@"%@%@%lu%@", @"Speakers", @" - (",(unsigned long)[titleList_ count],@")"];
        }
        else{
            title = [NSString stringWithFormat:@"%@%@%lu%@", @"Tags", @" - (",(unsigned long)[titleList_ count],@")"];
        }
        
    }
    return title;
}
- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",@"Selected");
    [self performSegueWithIdentifier:@"archive" sender:self];
    [tableViews deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ////NSLog(@"%@", text);
    
    DateViewController *audio = [[DateViewController alloc]init];
    NSIndexPath *path = [tableView indexPathForSelectedRow];
    audio = [segue destinationViewController];
    audio.date = [titleList_ objectAtIndex:path.row];
    audio.imman = @"Immanuel";
    NSLog(@"%@",[urlList_ objectAtIndex:path.row]);
    audio.dateURL = [urlList_ objectAtIndex:path.row];
    
    
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
