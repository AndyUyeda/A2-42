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
@synthesize date,dateURL, teacher,tableView,theGateLogo,ibcLogo,graceCommunityLogo,bluePrintLogo,type,dglogo,hwlogo,gccLogo,heartCryLogo,imman,trinityLogo,cornerStoneLogo, holyCityLogo, bridgepointLogo;

NSMutableArray *titleList;
NSMutableArray *teacherList;
NSMutableArray *urlList;
NSMutableArray *jumpToArray;
NSMutableArray *churchChangeList;
NSMutableArray *churchChangeLinks;

NSMutableArray *chaptersArray;
NSMutableArray *arrayOfTitleArrays;
NSMutableArray *arrayOfLinkArrays;
BOOL doneLoadin;
BOOL stopRecurrsion;
BOOL corner;
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
-(void)viewDidAppear:(BOOL)animated{
    [tableView reloadData];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    stopRecurrsion = NO;
    counter = 0;
    teacherList = [NSMutableArray array];
    titleList = [NSMutableArray array];
    urlList = [NSMutableArray array];
    churchChangeList = [NSMutableArray array];
    churchChangeLinks = [NSMutableArray array];
    jumpToArray = [NSMutableArray array];
    
    chaptersArray = [NSMutableArray array];
    arrayOfTitleArrays = [NSMutableArray array];
    arrayOfLinkArrays = [NSMutableArray array];
    ////NSLog(@"%@%@",date,dateURL);
    doneLoadin = FALSE;
    if([teacher isEqualToString:@"John Piper"]){
        self.navigationItem.title = type;
    }
    else{
        self.navigationItem.title = teacher;
    }
    if([imman isEqualToString:@"Immanuel"]){
        self.navigationItem.title = @"Immanuel";
    }
    if([type isEqualToString:@"By Scripture"]){
        self.navigationItem.title = date;
    }
    //NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(update:) userInfo:nil repeats:YES];
    
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.001
                                             target:self
                                           selector:@selector(update:)
                                           userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
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
    else if([teacher isEqualToString:@"Spencer Harmon"]){
        [bluePrintLogo setHidden:FALSE]; // changed to Vine Street Baptist
    }
    else if([teacher isEqualToString:@"John Piper"]){
        [dglogo setHidden:FALSE];
    }
    else if([teacher isEqualToString:@"Jason Lancaster"]){
        [hwlogo setHidden:FALSE];
    }
    
    else if([teacher isEqualToString:@"Tim Conway"]){
        [gccLogo setHidden:FALSE];
    }
    
    else if([teacher isEqualToString:@"Paul Washer"]){
        [heartCryLogo setHidden:FALSE];
    }
    else if([teacher isEqualToString:@"Art Azurdia"]){
        [trinityLogo setHidden:FALSE];
    }
    else if([teacher isEqualToString:@"Shai Linne"]){
        [cornerStoneLogo setHidden:FALSE];
    }
    else if([teacher isEqualToString:@"Brian Powell"]){
        [holyCityLogo setHidden:FALSE];
    }
    else if([teacher isEqualToString:@"Gunner Gundersen"]){
        [bridgepointLogo setHidden:FALSE];
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
                           if([teacher isEqualToString:@"John Piper"]){
                               if([type isEqualToString:@"By Scripture"]){
                                   NSString* l = [NSString stringWithFormat:@"%@%@%@",@"http://www.desiringgod.org/sermons/by-scripture/",date,@"/2"];
                                   [self nextScripture:l withNext:2];
                                   
                               }
                               
                               
                           }
                       }
                       else{
                           //NSLog(@"%@",webData);
                           if([teacher isEqualToString:@"Shai Linne"]){
                               MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                               BOOL done = false;
                               while (!done) {
                                   [searcher moveToString:@"preacher_name"];
                                   NSString *title = [searcher getStringWithLeftBound:@"sermon-title\">" rightBound:@"<"];
                                   [searcher moveToString:@"download="];
                                   NSString *website = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                                   if(title == nil){
                                       done = true;
                                   }
                                   else{
                                       [titleList addObject:title];
                                       [urlList addObject:website];
                                   }
                                   
                                   
                               }
                               [searcher moveToBeginning];
                               [searcher moveToString:@"Older Entries"];
                               [searcher moveBack:100];
                               NSString *s = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                               
                               [self olderItems:s old:s];
                               
                           }
                           if([teacher isEqualToString:@"Art Azurdia"]){
                               MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                               [searcher moveToString:@"=\"all-sermons"];
                               BOOL done = false;
                               while (!done) {
                                   [searcher moveToString:@"sermon-listing-title"];
                                   [searcher moveToString:@"href="];
                                   NSString *title = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                                   [searcher moveToString:@"sermon-downloads"];
                                   NSString *website = [searcher getStringWithLeftBound:@"url=" rightBound:@"\""];
                                   if(title == nil){
                                       done = true;
                                   }
                                   else{
                                       [titleList addObject:title];
                                       [urlList addObject:website];
                                   }
                                   
                               }
                           }
                           if([teacher isEqualToString:@"Ryan Fullerton"]){
                               MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                               if([date isEqualToString:@"On Our Hearts Podcast"]){
                                   BOOL done = false;
                                   while(!done){
                                       [searcher moveToString:@"<article id="];
                                       NSString *website = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                                       NSString *title = [searcher getStringWithLeftBound:@"title=\"" rightBound:@"\""];
                                       
                                       if(title == nil)
                                           done = true;
                                       else{
                                           title = [self parseTitle:title];
                                           [titleList addObject:title];
                                           
                                           website = [NSString stringWithFormat:@"%@%@",website,@"?player=audio"];
                                           [urlList addObject:website];
                                       }
                                   }
                               }else{
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
                                               
                                               website = [NSString stringWithFormat:@"%@%@",website,@"?player=audio"];
                                               [urlList addObject:website];
                                           }
                                           [searcher moveToString:@"</article>"];
                                       }
                                       
                                   }
                               }
                               [searcher moveToBeginning];
                               [searcher moveToString:@"Older Sermons"];
                               [searcher moveBack:100];
                               NSString* olderItems =[searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                               //NSLog(@"%@",olderItems);
                               if(![olderItems isEqualToString:@"http://feeds.feedburner.com/ibclouisville-sermons"]){
                                   [self olderItems:olderItems old:dateURL];
                               }
                               
                           }
                           if([imman isEqualToString:@"Immanuel"]){
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
                                   [searcher moveToString:@"\"tag\""];
                                   teach = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                                   
                                   
                                   if(title == nil || [title isEqualToString:@"RSS"])
                                       done = true;
                                   else{
                                       title = [self parseTitle:title];
                                       [titleList addObject:title];
                                       NSLog(@"%@",teach);
                                       website = [NSString stringWithFormat:@"%@%@",website,@"?player=audio"];
                                       [urlList addObject:website];
                                       [teacherList addObject:teach];
                                       [searcher moveToString:@"</article>"];
                                   }
                                   
                               }
                               [searcher moveToBeginning];
                               [searcher moveToString:@"Older Sermons"];
                               [searcher moveBack:100];
                               NSString* olderItems =[searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                               NSLog(@"%@",olderItems);
                               if(![olderItems isEqualToString:@"http://feeds.feedburner.com/ibclouisville-sermons"]){
                                   [self olderItems:olderItems old:url];
                               }
                               
                           }
                           //NSLog(@"%@",type);
                           if([teacher isEqualToString:@"John Piper"]){                               if([type isEqualToString:@"By Date"] || [type isEqualToString:@"By Topic"]){
                               MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                               BOOL done = false;
                               while(!done){
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
                                       [urlList addObject:site];
                                       [titleList addObject:title];
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
                                   [self olderItems:ss old:ss];
                               }
                           }
                               if([type isEqualToString:@"By Scripture"]){
                                   self.navigationItem.title = date;
                                   NSMutableArray *tiar = [NSMutableArray array];
                                   NSMutableArray *liar = [NSMutableArray array];
                                   
                                   MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                                   
                                   //[searcher moveToString:@"media-object"];
                                   NSString*exists = [searcher getStringWithLeftBound:@"find the page " rightBound:@" requested"];
                                   
                                   if([exists isEqualToString:@"you"]){
                                       
                                       NSString *d = [date stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                                       
                                       NSString* l = [NSString stringWithFormat:@"%@%@%@",@"http://www.desiringgod.org/sermons/by-scripture/",d,@"/2"];
                                       [self nextScripture:l withNext:2];
                                   }
                                   else{
                                       BOOL done = false;
                                       
                                       while(!done){
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
                                               [liar addObject:site];
                                               [tiar addObject:title];
                                           }
                                       }
                                       
                                       
                                       
                                       if([tiar count] > 0)
                                       {
                                           [chaptersArray addObject:[NSNumber numberWithInt:1]];
                                           [arrayOfLinkArrays addObject:liar];
                                           [arrayOfTitleArrays addObject:tiar];
                                       }
                                       NSString *d = [date stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                                       NSString* l = [NSString stringWithFormat:@"%@%@%@",@"http://www.desiringgod.org/sermons/by-scripture/",d,@"/2"];
                                       [self nextScripture:l withNext:2];
                                       
                                   }
                               }
                           }
                           /*if([teacher isEqualToString:@"John Onwuchekwa"]){
                            
                            [self johnO];
                            
                            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [churchChangeList count])];
                            [titleList insertObjects:churchChangeList atIndexes:set];
                            [urlList insertObjects:churchChangeLinks atIndexes:set];
                            
                            corner = false;
                            
                            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                            [searcher moveToString:@"MAIN CONTENT START"];
                            BOOL done = false;
                            while (!done) {
                            NSString* theSite = [searcher getStringWithLeftBound:@"title\"><a href=\"" rightBound:@"\""];
                            NSString* title = [searcher getStringWithLeftBound:@">" rightBound:@"</a>"];
                            
                            if(theSite == nil){
                            done = true;
                            ////NSLog(@"%@",title);
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
                            
                            
                            
                            }*/
                           if([teacher isEqualToString:@"Gunner Gundersen"]){
                               MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                               BOOL done = false;
                               while (!done) {
                                   [searcher moveToString:@"audio-title"];
                                   NSString* title = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                                   NSString* teacher = [searcher getStringWithLeftBound:@"Speaker:</span> " rightBound:@"<"];
                                   NSString* link = [searcher getStringWithLeftBound:@"src=\"" rightBound:@"\""];
                                   if(title == nil){
                                       done = true;
                                   }
                                   else{
                                       if([teacher isEqualToString:@"David \"Gunner\" Gundersen"]){
                                           title = [self parseTitle:title];
                                           [titleList addObject:title];
                                           [urlList addObject:link];
                                       }
                                   }
                               }
                               [searcher moveToBeginning];
                               [searcher moveToString:@"pager-next"];
                               NSString* check = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                               NSString* next = [NSString stringWithFormat:@"%@%@", @"http://www.bridgepointbible.org/", check];
                               [self olderItems:next old:next];
                               
                           }
                           if([teacher isEqualToString:@"Brian Powell"]){
                               MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                               [searcher moveToString:@"headline\">Sermons"];
                               BOOL done = false;
                               while (!done) {
                                   [searcher moveToString:@"sermon-title"];
                                   NSString* title = [searcher getStringWithLeftBound:@"title=\"Permalink to " rightBound:@"\""];
                                   [searcher moveToString:@"audio/mpeg"];
                                   NSString* link = [searcher getStringWithLeftBound:@"src=\"" rightBound:@"\""];
                                   if(title == nil){
                                       done = true;
                                   }
                                   else{
                                       title = [self parseTitle:title];
                                       [titleList addObject:title];
                                       [urlList addObject:link];
                                   }
                               }
                           }
                           if([teacher isEqualToString:@"Spencer Harmon"]){
                               MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                               BOOL done = false;
                               while (!done) {
                                   [searcher moveToString:@"Permalink"];
                                   [searcher moveBack:100];
                                   NSString* link = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                                   NSString* title = [searcher getStringWithLeftBound:@"bookmark\">" rightBound:@"<"];
                                   if(title == nil){
                                       done = true;
                                   }
                                   else{
                                       title = [self parseTitle:title];
                                       [titleList addObject:title];
                                       [urlList addObject:link];
                                   }
                               }
                               [searcher moveToBeginning];
                               [searcher moveToString:@"pagination"];
                               //Probably gon need to fix this later
                               NSString* check = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                               if([check isEqualToString:@"javascript:void(0)"]){
                                   NSString*next = @"http://www.vinestreetbaptist.org/sermons/page/2/?sermon_speaker=sharmon&sermon_series&sermon_service&sermon_topic&submit=Filter%20Sermons";//[searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                                   [self olderItems:next old:next];
                               }
                               
                           }
                           if([teacher isEqualToString:@"Jason Lancaster"]){
                               MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                               [searcher moveToString:@"fellowship-table"];
                               BOOL done = false;
                               while (!done) {
                                   [searcher moveToString:@"Sermon Title"];
                                   NSString* title = [searcher getStringWithLeftBound:@"strong-text\"\">" rightBound:@"</strong>"];
                                   [searcher moveToString:@"Speaker"];
                                   NSString* teacher = [searcher getStringWithLeftBound:@"strong-text\">" rightBound:@"</strong>"];
                                   [searcher moveToString:@"Download MP3 +"];
                                   [searcher moveBack:100];
                                   NSString* link = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                                   NSLog(@"%@",title);
                                   if(title == nil){
                                       done = true;
                                   }
                                   else if([teacher isEqualToString:@"Jason Lancaster"] && link != nil){
                                       title = [self parseTitle:title];
                                       [titleList addObject:title];
                                       [urlList addObject:link];
                                   }
                                   
                                   
                                   
                                   
                                   
                               }
                               
                           }
                           if([teacher isEqualToString:@"Paul Washer"] ||[teacher isEqualToString:@"Tim Conway"]){
                               MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
                               
                               [searcher moveToString:@"Added Videos"];
                               BOOL done = false;
                               while (!done) {
                                   [searcher moveToString:@"thumbnail hentry"];
                                   NSString* exists = [searcher getStringWithLeftBound:@"class=\"th" rightBound:@"b"];
                                   NSString* title = [searcher getStringWithLeftBound:@"title=\"" rightBound:@"\""];
                                   NSString* theSite = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                                   
                                   
                                   if(![exists isEqualToString:@"um"]){
                                       done = true;
                                       ////NSLog(@"%@",title);
                                   }
                                   else{
                                       
                                       title = [self parseTitle:title];
                                       [titleList addObject:title];
                                       [urlList addObject:theSite];
                                   }
                               }
                               [searcher moveToBeginning];
                               [searcher moveToString:@"loop-nav-inner"];
                               [searcher moveToString:@"next"];
                               NSString *s = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                               
                               [self olderItems:s old:s];
                               
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
                           //NSLog(@"%@",[titleList objectAtIndex:i]);
                       }
                       //NSLog(@"%d",[titleList count]);
                       
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
/*-(void)johnO{
 corner = true;
 NSURL *url = [NSURL URLWithString:@"http://cornerstoneatl.org/preacher/johno/"];
 NSString *webData = [NSString stringWithContentsOfURL:url];
 NSError *error;
 if (webData == nil) {
 // an error occurred
 NSLog(@"Error reading file at %@\n%@",
 url, [error localizedFailureReason]);
 // implementation continues ...
 }
 else{
 dateURL = @"http://cornerstoneatl.org/preacher/johno/";
 [self cornerStone:webData];
 }
 }
 -(void)cornerStone: (NSString*) webData{
 MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
 BOOL done = false;
 while (!done) {
 [searcher moveToString:@"entry-title"];
 NSString *title = [searcher getStringWithLeftBound:@"bookmark\">" rightBound:@"<"];
 [searcher moveToString:@"audio/mpeg"];
 NSString *website = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
 if(title == nil){
 done = true;
 }
 else if(website != nil){
 if([teacher isEqualToString:@"John Onwuchekwa"])
 {
 [churchChangeList addObject:title];
 [churchChangeLinks addObject:website];
 }
 else{
 [titleList addObject:title];
 [urlList addObject:website];
 }
 }
 }
 [searcher moveToString:@"nav-previous"];
 NSString* oo = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
 [self olderItems:oo old:dateURL];
 }*/

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
    //NSLog(@"%d",[titleList count]);
    
}
-(void)nextScripture: (NSString*) site withNext:(int)next{
    if(stopRecurrsion){
        return;
    }
    NSMutableArray *tiar = [NSMutableArray array];
    NSMutableArray *liar = [NSMutableArray array];
    
    NSURL *url = [NSURL URLWithString:site];
    NSString *webData = [NSString stringWithContentsOfURL:url];
    NSError *error;
    NSLog(@"%@",site);
    if (webData == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              url, [error localizedFailureReason]);
        // implementation continues ...
    }
    else{
        MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
        //NSLog(@"%@", site);
        NSString*exists = [searcher getStringWithLeftBound:@"find the page " rightBound:@" requested"];
        
        if([exists isEqualToString:@"you"]){
            NSString *d = [date stringByReplacingOccurrencesOfString:@" " withString:@"-"];
            
            NSString* l = [NSString stringWithFormat:@"%@%@%@%d",@"http://www.desiringgod.org/sermons/by-scripture/",d,@"/",next+1];
            [self nextScripture:l withNext:next+1];
        }
        else{
            BOOL done = false;
            while(!done){
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
                    [liar addObject:site];
                    [tiar addObject:title];
                }
            }
            
        }
    }
    if([tiar count] > 0)
    {
        [chaptersArray addObject:[NSNumber numberWithInt:next]];
        [arrayOfLinkArrays addObject:liar];
        [arrayOfTitleArrays addObject:tiar];
        [tableView reloadData];
    }
    if((next <=151 && [date isEqualToString:@"Psalms"]) ||(next <=67 && [date isEqualToString:@"Isaiah"])|| next <=53){
        NSString *d = [date stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        
        NSString* l = [NSString stringWithFormat:@"%@%@%@%d",@"http://www.desiringgod.org/sermons/by-scripture/",d,@"/",next+1];
        [self nextScripture:l withNext:next+1];
    }
    
    
}
- (void)olderItems: (NSString*) site old:(NSString*)oldsite{
    
    if(stopRecurrsion){
        return;
    }
    
    NSLog(@"%@", site);
    NSURL *url = [NSURL URLWithString:site];
    NSString *webData = [NSString stringWithContentsOfURL:url];
    NSError *error;
    ////NSLog(@"hello");
    if (webData == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              url, [error localizedFailureReason]);
        // implementation continues ...
    }
    else{
        if([teacher isEqualToString:@"John Piper"]){
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            
            BOOL done = false;
            while(!done){
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
                    [urlList addObject:site];
                    [titleList addObject:title];
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
        if([teacher isEqualToString:@"Shai Linne"]){
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            BOOL done = false;
            while (!done) {
                [searcher moveToString:@"preacher_name"];
                NSString *title = [searcher getStringWithLeftBound:@"sermon-title\">" rightBound:@"<"];
                [searcher moveToString:@"download="];
                NSString *website = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                if(title == nil){
                    done = true;
                }
                else{
                    [titleList addObject:title];
                    [urlList addObject:website];
                }
                
                
            }
            [searcher moveToBeginning];
            [searcher moveToString:@"Older Entries"];
            [searcher moveBack:100];
            NSString *s = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            NSLog(@"%@",s);
            if(![s isEqualToString:@"https://rcfphilly.com/xmlrpc.php"]){
                [self olderItems:s old:s];
            }
            
        }
        if([teacher isEqualToString:@"Gunner Gundersen"]){
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            BOOL done = false;
            while (!done) {
                [searcher moveToString:@"audio-title"];
                NSString* title = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                NSString* teacher = [searcher getStringWithLeftBound:@"Speaker:</span> " rightBound:@"<"];
                NSString* link = [searcher getStringWithLeftBound:@"src=\"" rightBound:@"\""];
                if(title == nil){
                    done = true;
                }
                else{
                    if([teacher isEqualToString:@"David \"Gunner\" Gundersen"] || [teacher isEqualToString:@"Dr. David \"Gunner\" Gunderson"]){
                        title = [self parseTitle:title];
                        [titleList addObject:title];
                        [urlList addObject:link];
                        if([title isEqualToString:@"The Mystery of the Harvest: Christian Faithfulness Till All Things Are New"]){
                            return;
                        }
                    }
                }
            }
            [searcher moveToBeginning];
            [searcher moveToString:@"pager-next"];
            NSString* check = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            NSString* next = [NSString stringWithFormat:@"%@%@", @"http://www.bridgepointbible.org/", check];
            if([check isEqualToString:@"&nbsp;"])
            {
                return;
            }
            [self olderItems:next old:next];
            
        }
        if([teacher isEqualToString:@"Spencer Harmon"]){
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            BOOL done = false;
            while (!done) {
                NSString* c = [searcher getStringWithLeftBound: @"Permalink"rightBound:@"o"];
                [searcher moveBack:200];
                NSString* link = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                NSString* title = [searcher getStringWithLeftBound:@"bookmark\">" rightBound:@"<"];
                NSLog(@"%@", c);
                if(![c isEqualToString:@" t"]){
                    done = true;
                }
                else{
                    title = [self parseTitle:title];
                    [titleList addObject:title];
                    [urlList addObject:link];
                }
            }
            //[searcher moveToBeginning];
            //[searcher moveToString:@"pagination"];
            //Probably gon need to fix this later
            /*NSString* check = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
             if([check isEqualToString:@"javascript:void(0)"]){
             NSString*next =[searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
             [self olderItems:next old:next];
             }*/
            
        }
        /*if([teacher isEqualToString:@"Trip Lee"] || ([teacher isEqualToString:@"John Onwuchekwa"] && corner)){
         MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
         BOOL done = false;
         while (!done) {
         [searcher moveToString:@"entry-title"];
         NSString *title = [searcher getStringWithLeftBound:@"bookmark\">" rightBound:@"<"];
         [searcher moveToString:@"audio/mpeg"];
         NSString *website = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
         if(title == nil){
         done = true;
         }
         else if(website != nil){
         if([teacher isEqualToString:@"John Onwuchekwa"])
         {
         [churchChangeList addObject:title];
         [churchChangeLinks addObject:website];
         }
         else{
         [titleList addObject:title];
         [urlList addObject:website];
         }
         }
         }
         [searcher moveToString:@"nav-previous"];
         NSString* oo = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
         if(![oo isEqualToString:oldsite]){
         [self olderItems:oo old:site];
         }
         
         }
         if([teacher isEqualToString:@"John Onwuchekwa"] && !corner){
         ////NSLog(@"hello");
         MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
         [searcher moveToString:@"MAIN CONTENT START"];
         BOOL done = false;
         while (!done) {
         NSString* theSite = [searcher getStringWithLeftBound:@"title\"><a href=\"" rightBound:@"\""];
         NSString* title = [searcher getStringWithLeftBound:@">" rightBound:@"</a>"];
         
         if(theSite == nil){
         done = true;
         ////NSLog(@"%@",title);
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
         ////NSLog(@"%@",keepGoing);
         if([keepGoing length] == 5){
         [self olderItems:olderItems old:site];
         }
         else{
         
         }
         
         }*/
        if([teacher isEqualToString:@"Paul Washer"]){
            ////NSLog(@"hello");
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            [searcher moveToString:@"Browse Archives"];
            BOOL done = false;
            while (!done) {
                [searcher moveToString:@"thumbnail hentry"];
                NSString* exists = [searcher getStringWithLeftBound:@"<a class=\"" rightBound:@"\""];
                NSString* title = [searcher getStringWithLeftBound:@"title=\"" rightBound:@"\""];
                NSString* theSite = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                
                
                if(![exists isEqualToString:@"clip-link"]){
                    done = true;
                    ////NSLog(@"%@",title);
                }
                else{
                    
                    
                    title = [self parseTitle:title];
                    [titleList addObject:title];
                    [urlList addObject:theSite];
                }
            }
            [searcher moveToBeginning];
            [searcher moveToString:@"loop-nav-inner"];
            [searcher moveToString:@"next"];
            NSString *s = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            //NSLog(@"%@",s);
            if([s isEqualToString:@"http://illbehonest.com/speaker/paul-washer/"]){
                return;
            }
            [self olderItems:s old:s];
            
        }
        if([teacher isEqualToString:@"Tim Conway"]){
            ////NSLog(@"hello");
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            [searcher moveToString:@"Browse Archives"];
            BOOL done = false;
            while (!done) {
                [searcher moveToString:@"thumbnail hentry"];
                NSString* exists = [searcher getStringWithLeftBound:@"<a class=\"" rightBound:@"\""];
                NSString* title = [searcher getStringWithLeftBound:@"title=\"" rightBound:@"\""];
                NSString* theSite = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                
                
                if(![exists isEqualToString:@"clip-link"]){
                    done = true;
                    ////NSLog(@"%@",title);
                }
                else{
                    
                    
                    title = [self parseTitle:title];
                    [titleList addObject:title];
                    [urlList addObject:theSite];
                }
            }
            [searcher moveToBeginning];
            [searcher moveToString:@"loop-nav-inner"];
            [searcher moveToString:@"next"];
            NSString *s = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            //NSLog(@"%@",s);
            if([s isEqualToString:@"http://illbehonest.com/speaker/tim-conway/"]){
                return;
            }
            [self olderItems:s old:s];
            
        }
        
        if([teacher isEqualToString:@"Ryan Fullerton"]){
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            if([date isEqualToString:@"On Our Hearts Podcast"]){
                BOOL done = false;
                while(!done){
                    [searcher moveToString:@"<article id="];
                    NSString *website = [searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
                    NSString *title = [searcher getStringWithLeftBound:@"title=\"" rightBound:@"\""];
                    
                    if(title == nil)
                        done = true;
                    else{
                        title = [self parseTitle:title];
                        [titleList addObject:title];
                        
                        website = [NSString stringWithFormat:@"%@%@",website,@"?player=audio"];
                        [urlList addObject:website];
                    }
                }
            }else{
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
            }
            [searcher moveToBeginning];
            [searcher moveToString:@"Newer Sermons"];
            [searcher moveToString:@"Older Sermons"];
            [searcher moveBack:100];
            NSString* olderItems =[searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            // //NSLog(@"%@",olderItems);
            if(![olderItems isEqualToString:@"http://feeds.feedburner.com/ibclouisville-sermons"]&&![olderItems isEqualToString:oldsite]){
                [self olderItems:olderItems old:site];
            }
            else{
                //NSLog(@"all good in the hood");
                NSLog(@"%@",titleList);
                NSLog(@"%@",urlList);
                
            }
        }
        if([imman isEqualToString:@"Immanuel"]){
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
                [searcher moveToString:@"\"tag\""];
                teach = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                
                
                if(title == nil || [title isEqualToString:@"RSS"])
                    done = true;
                else{
                    title = [self parseTitle:title];
                    [titleList addObject:title];
                    [urlList addObject:website];
                    [teacherList addObject:teach];
                    
                    NSLog(@"%@", teach);
                    [searcher moveToString:@"</article>"];
                }
                
            }
            [searcher moveToBeginning];
            [searcher moveToString:@"Newer Sermons"];
            [searcher moveToString:@"Older Sermons"];
            [searcher moveBack:100];
            NSString* olderItems =[searcher getStringWithLeftBound:@"href=\"" rightBound:@"\""];
            // //NSLog(@"%@",olderItems);
            if(![olderItems isEqualToString:@"http://feeds.feedburner.com/ibclouisville-sermons"]&&![olderItems isEqualToString:oldsite]){
                [self olderItems:olderItems old:site];
            }
            else{
                //NSLog(@"all good in the hood");
                //NSLog(@"%@",titleLists);
                //NSLog(@"%@",linkList);
                
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([type isEqualToString:@"By Scripture"]){
        if([chaptersArray count] == 0){
            return 1;
        }
        return [chaptersArray count];
    }
    else{
        return 1;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([type isEqualToString:@"By Scripture"]){
        for(int i = 0; i < [chaptersArray count];i++){
            
            if (section==i)
            {
                //NSLog(@"%@%d", @"c", [chaptersArray count]);
                //NSLog(@"%@%d", @"a", [arrayOfTitleArrays count]);
                return [[arrayOfTitleArrays objectAtIndex:i] count];
            }
        }
    }
    else{
        return [titleList count]; //change
    }
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableViews dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if([type isEqualToString:@"By Scripture"]){
        NSString* lll = @"";
        NSString* fff = @"";
        for(int i = 0; i < [chaptersArray count];i++){
            
            if (indexPath.section==i)
            {
                cell.textLabel.text = [[arrayOfTitleArrays objectAtIndex:i] objectAtIndex:indexPath.row];
                lll = [NSString stringWithFormat:@"%@%@%@",teacher,[[arrayOfTitleArrays objectAtIndex:i] objectAtIndex:indexPath.row],@"heard"];
                fff = [NSString stringWithFormat:@"%@%@%@",teacher,[[arrayOfTitleArrays objectAtIndex:i] objectAtIndex:indexPath.row],@"favorite"];
            }
        }
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        bool heard = [prefs boolForKey:lll];
        if(heard){
            cell.imageView.image = [UIImage imageNamed:@"HeadphoneGreen.png"];
        }
        else{
            cell.imageView.image = [UIImage imageNamed:@"Headphone.png"];
        }
        bool fav = [prefs boolForKey:fff];
        if(fav){
            cell.imageView.image = [UIImage imageNamed:@"star.png"];
        }
        
        
    }
    else{
        NSString *pp = [self parseTitle:[titleList objectAtIndex:indexPath.row]];
        cell.textLabel.text = pp;
        NSString* lll;
        NSString* fff;
        if([imman isEqualToString:@"Immanuel"]){
            lll = [NSString stringWithFormat:@"%@%@%@",[teacherList objectAtIndex:indexPath.row],[titleList objectAtIndex:indexPath.row],@"heard"];
            fff = [NSString stringWithFormat:@"%@%@%@",[teacherList objectAtIndex:indexPath.row],[titleList objectAtIndex:indexPath.row],@"favorite"];
        }
        else{
            lll = [NSString stringWithFormat:@"%@%@%@",teacher,[titleList objectAtIndex:indexPath.row],@"heard"];
            fff = [NSString stringWithFormat:@"%@%@%@",teacher,[titleList objectAtIndex:indexPath.row],@"favorite"];
        }
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        bool heard = [prefs boolForKey:lll];
        
        if(heard){
            cell.imageView.image = [UIImage imageNamed:@"HeadphoneGreen.png"];
        }
        else{
            cell.imageView.image = [UIImage imageNamed:@"Headphone.png"];
        }
        bool fav = [prefs boolForKey:fff];
        if(fav){
            cell.imageView.image = [UIImage imageNamed:@"star.png"];
        }
        
    }
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
    if([type isEqualToString:@"By Scripture"]){
        for(int i = 0; i < [chaptersArray count];i++){
            
            if (section==i)
            {
                return [NSString stringWithFormat:@"%@%d", @"Chapter ", [[chaptersArray objectAtIndex:i] integerValue]];
            }
        }
        if([chaptersArray count] == 0){
            return @"Loading...";
        }
    }
    ////NSLog(@"%d",doneLoadin);
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
    NSLog(@"%@",@"Selected");
    [self performSegueWithIdentifier:@"sermondate" sender:self];
    [tableViews deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ////NSLog(@"%@", text);
    if([segue.identifier isEqualToString:(@"sermondate")]){
        if([type isEqualToString:@"By Scripture"]){
            AudioViewController *audio = [[AudioViewController alloc]init];
            NSIndexPath *path = [tableView indexPathForSelectedRow];
            audio = [segue destinationViewController];
            for(int i = 0; i < [chaptersArray count];i++){
                
                if (path.section==i)
                {
                    audio.theTitle = [[arrayOfTitleArrays objectAtIndex:i] objectAtIndex:path.row];
                    audio.websiteURL = [[arrayOfLinkArrays objectAtIndex:i] objectAtIndex:path.row];
                }
            }
            
            audio.teacher = teacher;
        }
        else{
            AudioViewController *audio = [[AudioViewController alloc]init];
            NSIndexPath *path = [tableView indexPathForSelectedRow];
            audio = [segue destinationViewController];
            NSString *tt = [self parseTitle:[titleList objectAtIndex:path.row]];
            audio.theTitle = tt;
            if([imman isEqualToString:@"Immanuel"]){
                audio.teacher = [teacherList objectAtIndex:path.row];
                audio.imman = imman;
            }
            else{
                audio.teacher = teacher;
            }
            if(path.row < [churchChangeList count]){
                audio.corner = @"Cornerstone";
            }
            audio.websiteURL = [urlList objectAtIndex:path.row];
            
        }
    }
}
//Make sure the title doesn't have crazy symbols
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
