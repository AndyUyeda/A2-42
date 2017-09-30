//
//  2DGViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 5/8/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

#import "2DGViewController.h"
#import "MEStringSearcher.h"
#import "DateViewController.h"

@interface _DGViewController ()

@end

@implementation _DGViewController
@synthesize tableView,desiringGod,type;

NSMutableArray *dates;
NSMutableArray *links;

NSMutableArray *dates2;
NSMutableArray *links2;
int sect;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = type;
    NSLog(@"%@",type);
    if([type isEqualToString:@"By Date"]){
        dates = [NSMutableArray array];
        links = [NSMutableArray array];
        
        NSURL *url = [NSURL URLWithString:@"http://www.desiringgod.org/messages/by-date"];
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
                //NSLog(@"%@", date);
                if(date.length == 4){
                    NSString *s = [NSString stringWithFormat:@"%@%@",@"http://www.desiringgod.org",link];
                    [links addObject:s];
                    [dates addObject:date];
                    NSLog(@"%@",date);
                    
                }
                else{
                    done = true;
                }
            }
        }
        
        
    }
    
    if([type isEqualToString:@"By Topic"]){
        dates = [NSMutableArray array];
        links = [NSMutableArray array];
        
        NSURL *url = [NSURL URLWithString:@"http://www.desiringgod.org/topics/with-messages"];
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
            [searcher moveToString:@"link-list"];
            BOOL done = false;
            while(!done){
                NSString*link = [searcher getStringWithLeftBound:@"href='" rightBound:@"'"];
                NSString*date = [searcher getStringWithLeftBound:@">" rightBound:@"<"];
                NSLog(@"%@", date);
                if(date.length >= 2 && ![date isEqualToString:@"\nLearn more about Desiring God\n"]){
                    NSString *s = [NSString stringWithFormat:@"%@%@",@"http://www.desiringgod.org",link];
                    [links addObject:s];
                    date = [self parseTitle:date];
                    [dates addObject:date];
                    
                }
                else{
                    //[links removeLastObject];
                    //[dates removeLastObject];
                    done = true;
                }
            }
        }
        
        
    }
    
    if([type isEqualToString:@"By Scripture"]){
        dates = [NSMutableArray array];
        links = [NSMutableArray array];
        
        dates2 = [NSMutableArray array];
        links2 = [NSMutableArray array];
        
        NSURL *url = [NSURL URLWithString:@"http://www.desiringgod.org/sermons/by-scripture"];
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
            [searcher moveToString:@"Old Testament"];
            BOOL done = false;
            BOOL OT = true;
            while(!done){
                
                NSString*date = [searcher getStringWithLeftBound:@"javascript:;'>\n" rightBound:@"\n<"];
                NSLog(@"%@", date);
                if([date isEqualToString:@"Matthew"]){
                    OT = false;
                }
                if(date != nil){
                    NSString *d = [date stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                    NSString *s = [NSString stringWithFormat:@"%@%@%@",@"http://www.desiringgod.org/sermons/by-scripture/",d,@"/1"];
                    if(OT){
                        [links addObject:s];
                        date = [self parseTitle:date];
                        [dates addObject:date];
                    }
                    else{
                        [links2 addObject:s];
                        date = [self parseTitle:date];
                        [dates2 addObject:date];
                    }
                    
                }
                else{
                    done = true;
                }
            }
        }
        
        
    }
    //NSLog(@"%@",dates2);
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([type isEqualToString:@"By Scripture"]){
        return 2;
    }
    else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([type isEqualToString:@"By Scripture"]){
        if (section==0)
        {
            return [dates count];
        }
        else{
            return [dates2 count];
        }
    }
    else{
        return [dates count];
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableViews dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    cell.textLabel.text = [dates objectAtIndex:indexPath.row];
    
    if([type isEqualToString:@"By Scripture"]){
        if (indexPath.section==0)
        {
            cell.textLabel.text = [dates objectAtIndex:indexPath.row];
        }
        else{
            cell.textLabel.text = [dates2 objectAtIndex:indexPath.row];
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
    NSString *cellText = [dates objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:12.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 20;
}
- (NSString *)tableView:(UITableView *)tableViews titleForHeaderInSection:(NSInteger)section
{
    
    if([type isEqualToString:@"By Scripture"]){
        if (section==0)
        {
            return @"Old Testament";
        }
        else{
            return @"New Testament";
        }
    }
    /*NSString *title = date;
     if(!doneLoadin){
     title = @"Loading...";
     }
     else if([titleList count] == 0){
     title = @"No Sermons Found";
     }
     else{
     title = [NSString stringWithFormat:@"%@%@%d%@", date, @" - ",[titleList count], @" Sermons"];
     }
     return title;*/
    return type;
}
- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sect = indexPath.section;
    [self performSegueWithIdentifier:@"dt" sender:self];
    [tableViews deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:(@"dt")]){
        if(sect == 0){
            DateViewController *audio = [[DateViewController alloc]init];
            NSIndexPath *path = [tableView indexPathForSelectedRow];
            audio = [segue destinationViewController];
            audio.date = [dates objectAtIndex:path.row];
            audio.teacher = @"John Piper";
            audio.type = type;
            audio.dateURL = [links objectAtIndex:path.row];
            
             NSLog(@"%@", [links objectAtIndex:path.row]);
        }
        else{
            DateViewController *audio = [[DateViewController alloc]init];
            NSIndexPath *path = [tableView indexPathForSelectedRow];
            audio = [segue destinationViewController];
            audio.date = [dates2 objectAtIndex:path.row];
            audio.teacher = @"John Piper";
            audio.type = type;
            audio.dateURL = [links2 objectAtIndex:path.row];
        }
        
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    //[links removeAllObjects];
    //[dates removeAllObjects];
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
