//
//  DateViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 7/8/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import "DateViewController.h"
#import "MEStringSearcher.h"
#import "AudioViewController.h"
@interface DateViewController()
@end

@implementation DateViewController{

}
@synthesize date,dateURL, teacher,tableView,theGateLogo,ibcLogo,graceCommunityLogo,bluePrintLogo;

NSMutableArray *titleList;
NSMutableArray *urlList;
NSMutableArray *jumpToArray;
BOOL doneLoadin;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    titleList = [NSMutableArray array];
    urlList = [NSMutableArray array];
    jumpToArray = [NSMutableArray array];
	
    //NSLog(@"%@%@",date,dateURL);
    doneLoadin = FALSE;
    self.navigationItem.title = teacher;
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(update:) userInfo:nil repeats:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if([teacher isEqualToString:@"Voddie Baucham"]){
        [graceCommunityLogo setHidden:FALSE];
    }
    else if ([teacher isEqualToString:@"Kenny Petty"]){
        [theGateLogo setHidden:FALSE];
    }
    else if([teacher isEqualToString:@"Ryan Fullerton"]){
        [ibcLogo setHidden:FALSE];
    }
    else if([teacher isEqualToString:@"John Onwuchekwa"]){
        [bluePrintLogo setHidden:FALSE];
    }
   
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
                           if([teacher isEqualToString:@"Ryan Fullerton"]){
                               MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                               [searcher moveToString:@"multimedia-posts"];
                               BOOL done = false;
                               while (!done) {
                                   NSString *website = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                                   NSString *title = [searcher getStringWithLeftBound:@"title=\"" rightBound:@"\""];
                                   NSString *teach;
                                   if([title isEqualToString:@"Gospel Community Groups: Cultivating Lives of Gospel Love"]){
                                       teach = @"Ryan Fullerton";
                                   }
                                   else{
                                       [searcher moveToString:@"\"tag\""];
                                       teach = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                                   }
                                   
                                   if(title == nil)
                                       done = true;
                                   else{
                                       if([teach isEqualToString:@"Ryan Fullerton"]){
                                           title = [self parseTitle:title];
                                           [titleList addObject:title];
                                           [urlList addObject:website];
                                       }
                                       [searcher moveToString:@"</article>"];
                                   }
                                   
                               }
                               [searcher moveToString:@"Older Items"];
                               [searcher moveBack:100];
                               NSString* olderItems =[searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                               //NSLog(@"%@",olderItems);
                               if(![olderItems isEqualToString:@"http://feeds.feedburner.com/ibclouisville-sermons"]){
                                   [self olderItems:olderItems old:dateURL];
                               }
                               
                           }
                           if([teacher isEqualToString:@"John Onwuchekwa"]){
                               MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                               [searcher moveToString:@"MAIN CONTENT START"];
                               BOOL done = false;
                               while (!done) {
                                   NSString* theSite = [searcher getStringWithLeftBound:@"title\"><a href=\"" rightBound:@"\""];
                                   NSString* title = [searcher getStringWithLeftBound:@">" rightBound:@"</a>"];
                                   
                                   if(theSite == nil){
                                       done = true;
                                       //NSLog(@"%@",title);
                                   }
                                   else{
                                       
                                       title = [self parseTitle:title];
                                       [titleList addObject:title];
                                       [urlList addObject:theSite];
                                   }
                               }
                               [searcher moveToString:@"older-posts"];
                               NSString* olderItems =[searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                               [self olderItems:olderItems old:dateURL];
                        
                           }
                           if([teacher isEqualToString:@"Voddie Baucham"]||[teacher isEqualToString:@"Kenny Petty"]){
                               
                               MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                               [searcher moveToString:@"<b><a class=ser"];
                               BOOL done = false;
                               while (!done) {
                                   NSString *slit = [searcher getStringWithLeftBound:@"monlink href=\"" rightBound:@"\""];
                                   NSString *title = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                                   NSString *website = [NSString stringWithFormat:@"%@%@",@"http://www.sermonaudio.com/",slit];
                                   
                                   if(title == nil)
                                       done = true;
                                   else{
                                       
                                       title = [self parseTitle:title];
                                       [titleList addObject:title];
                                       [urlList addObject:website];
                                       [searcher moveToString:@"<b><a class=ser"];
                                   }
                                   
                               }
                               [searcher moveToString:@"to Page"];
                               BOOL done2 = FALSE;
                               while (!done2){
                                   NSString *tile = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                                   NSString *site = [NSString stringWithFormat:@"%@%@", @"http://www.sermonaudio.com/",tile];
                                   [searcher moveToString:@"</a>"];
                                   NSString *num = [searcher getStringWithLeftBound:@"<" rightBound:@" "];
                                   if(![num isEqualToString:@"a"]){
                                       [jumpToArray addObject:site];
                                       done2 = true;
                                   }
                                   else{
                                       [jumpToArray addObject:site];
                                   }
                               
                               }
                               if([jumpToArray count] > 0){
                                   for(int i = 0; i< [jumpToArray count]; i++){
                                       [self olderItems:[jumpToArray objectAtIndex:i] old:dateURL];
                                   }
                               
                               }
                               
                               
                               
                               
                           }
                       }
                       
                       for(int i = 0; i < [titleList count];i++){
                           NSLog(@"%@",[titleList objectAtIndex:i]);
                       }
                       NSLog(@"%d",[titleList count]);
                       
                       //dispatch back to the main (UI) thread to stop the activity indicator
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          doneLoadin = TRUE;
                                          [timer invalidate];
                                          
                                      });
                   });
    
    
    
}

- (void)update: (NSTimer*) timer {
    [tableView reloadData];
    //NSLog(@"%d",[titleList count]);

}
- (void)olderItems: (NSString*) site old:(NSString*)oldsite{
   
    NSURL *url = [NSURL URLWithString:site];
    NSString *webData = [NSString stringWithContentsOfURL:url];
    NSError *error;
     //NSLog(@"hello");
    if (webData == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              url, [error localizedFailureReason]);
        // implementation continues ...
    }
    else{
        if([teacher isEqualToString:@"John Onwuchekwa"]){
            //NSLog(@"hello");
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            [searcher moveToString:@"MAIN CONTENT START"];
            BOOL done = false;
            while (!done) {
                NSString* theSite = [searcher getStringWithLeftBound:@"title\"><a href=\"" rightBound:@"\""];
                NSString* title = [searcher getStringWithLeftBound:@">" rightBound:@"</a>"];
                
                if(theSite == nil){
                    done = true;
                    //NSLog(@"%@",title);
                }
                else{
                    
                    title = [self parseTitle:title];
                    [titleList addObject:title];
                    [urlList addObject:theSite];
                }
            }
            [searcher moveToString:@"older-posts"];
            NSString* olderItems =[searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            NSString* keepGoing = [searcher getStringWithLeftBound:@"Old" rightBound:@"sts"];
            //NSLog(@"%@",keepGoing);
            if([keepGoing length] == 5){
                [self olderItems:olderItems old:site];
            }
            else{
            
            }
        
        }
        if([teacher isEqualToString:@"Ryan Fullerton"]){
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            [searcher moveToString:@"multimedia-posts"];
            BOOL done = false;
            while (!done) {
                NSString *website = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                NSString *title = [searcher getStringWithLeftBound:@"title=\"" rightBound:@"\""];
                NSString *teach;
                if([title isEqualToString:@"Gospel Community Groups: Cultivating Lives of Gospel Love"]){
                    teach = @"Ryan Fullerton";
                }
                else{
                    [searcher moveToString:@"\"tag\""];
                    teach = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                }
                
                if(title == nil)
                    done = true;
                else{
                    if([teach isEqualToString:@"Ryan Fullerton"]){
                        title = [self parseTitle:title];
                        [titleList addObject:title];
                        [urlList addObject:website];
                        
                        
                    }
                    [searcher moveToString:@"</article>"];
                }
                
            }
            [searcher moveToString:@"Newer Items"];
            [searcher moveToString:@"Older Items"];
            [searcher moveBack:100];
            NSString* olderItems =[searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
           // NSLog(@"%@",olderItems);
            if(![olderItems isEqualToString:@"http://feeds.feedburner.com/ibclouisville-sermons"]&&![olderItems isEqualToString:oldsite]){
                [self olderItems:olderItems old:site];
            }
            else{
                NSLog(@"all good in the hood");
            }
        }
        if([teacher isEqualToString:@"Voddie Baucham"]||[teacher isEqualToString:@"Kenny Petty"]){
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            [searcher moveToString:@"<b><a class=ser"];
            BOOL done = false;
            while (!done) {
                NSString *slit = [searcher getStringWithLeftBound:@"monlink href=\"" rightBound:@"\""];
                NSString *title = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                NSString *website = [NSString stringWithFormat:@"%@%@",@"http://www.sermonaudio.com/",slit];
                
                if(title == nil)
                    done = true;
                else{
                    
                    title = [self parseTitle:title];
                    [titleList addObject:title];
                    [urlList addObject:website];
                    [searcher moveToString:@"<b><a class=ser"];
                }
                
            }
        
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleList count]; //change
}
- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableViews dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    cell.textLabel.text = [titleList objectAtIndex:indexPath.row];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    //cell.imageView.image = [images objectAtIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [titleList objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:12.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 20;
}
- (NSString *)tableView:(UITableView *)tableViews titleForHeaderInSection:(NSInteger)section
{
    NSString *title = date;
    if(!doneLoadin){
        title = @"Loading...";
    }
    else if([titleList count] == 0){
        title = @"No Sermons Found";
    }
    else{
        title = [NSString stringWithFormat:@"%@%@%d%@", date, @" - ",[titleList count], @" Sermons"];
    }
    return title;
}
- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"sermondate" sender:self];
    [tableViews deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%@", text);
    if([segue.identifier isEqualToString:(@"sermondate")]){
        AudioViewController *audio = [[AudioViewController alloc]init];
        NSIndexPath *path = [tableView indexPathForSelectedRow];
        audio = [segue destinationViewController];
        audio.theTitle = [titleList objectAtIndex:path.row];
        audio.teacher = teacher;
        audio.websiteURL = [urlList objectAtIndex:path.row];
        
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
    BOOL tiltedQuoteDone = false;
    BOOL tiltedQuote2Done = false;
    
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
