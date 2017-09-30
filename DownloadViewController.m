//
//  DownloadViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 7/4/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import "DownloadViewController.h"
#import "AudDownloadViewController.h"
#import "AppDelegate.h"

@implementation DownloadViewController

NSMutableArray *teachers;
NSMutableArray *titleList;
NSMutableArray *croppedTitles;
NSMutableArray *croppedTeachers;
NSMutableArray *webSitesP;
NSMutableArray *images;
NSMutableArray *images2;
NSTimer *timer2;
bool added;
UIView *original;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.revealViewController.delegate = self;
    images = [NSMutableArray array];
    images2 = [NSMutableArray array];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    titleList = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"sermonTitles"]];
    webSitesP = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"webSitesP"]];
    teachers = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"teacherNames"]];
    
    croppedTitles = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"croppedTitles"]];
    croppedTeachers = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"croppedNames"]];
    
    for(int i = 0; i < [croppedTitles count]; i ++){
        NSLog(@"%@",[croppedTeachers objectAtIndex:i]);
    }
    self.navigationController.navigationBar.topItem.title = @"Downloads";
    
    
    for(int i = 0; i < [teachers count];i++)
    {
        UIImage *image;
        NSString *iii = [NSString stringWithFormat:@"immanuel%@%@",[teachers objectAtIndex:i],[titleList objectAtIndex:i]];
        
        bool im = [prefs boolForKey:iii];
        image = [UIImage imageNamed: @"iTunesArtwork.png"];
        if(im){
            image = [UIImage imageNamed:@"ibcIcon.png"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"Ryan Fullerton"]){
            image = [UIImage imageNamed:@"ryanFullertonImage.png"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"Voddie Baucham"]){
            image = [UIImage imageNamed:@"voddiebaucham.jpg"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"Shai Linne"]){
            image = [UIImage imageNamed:@"shai_big.jpg"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"Kenny Petty"]){
            image = [UIImage imageNamed:@"kennypetty.jpg"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"Art Azurdia"]){
            image = [UIImage imageNamed:@"artAzurdiaImage.jpg"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"John Onwuchekwa"]){
            image = [UIImage imageNamed:@"johnO.jpg"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"John Piper"]){
            image = [UIImage imageNamed:@"johnpiper.jpg"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"Jason Lancaster"]){
            image = [UIImage imageNamed:@"lancaster.jpg"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"Paul Washer"]){
            image = [UIImage imageNamed:@"washer.jpg"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"Tim Conway"]){
            image = [UIImage imageNamed:@"conway.jpg"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"Spencer Harmon"]){
            image = [UIImage imageNamed:@"spencerharmon.jpg"];
        }
        UIImage *tempImage = nil;
        CGSize targetSize = CGSizeMake(60,60);
        UIGraphicsBeginImageContext(targetSize);
        
        CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
        thumbnailRect.origin = CGPointMake(0.0,0.0);
        thumbnailRect.size.width  = targetSize.width;
        thumbnailRect.size.height = targetSize.height;
        
        [image drawInRect:thumbnailRect];
        
        tempImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        image = tempImage;
        
        [images addObject:image];
    }
    for(int i = 0; i < [croppedTeachers count];i++)
    {
        UIImage *image;
        image = [UIImage imageNamed: @"iTunesArtwork.png"];
        NSString *iii = [NSString stringWithFormat:@"immanuel%@%@",[croppedTeachers objectAtIndex:i],[croppedTitles objectAtIndex:i]];
        
        bool im = [prefs boolForKey:iii];
        
        if(im){
            image = [UIImage imageNamed:@"ibcIcon.png"];
        }
        if([[croppedTeachers objectAtIndex:i]isEqualToString:@"Ryan Fullerton"]){
            image = [UIImage imageNamed:@"ryanFullertonImage.png"];
        }
        if([[croppedTeachers objectAtIndex:i]isEqualToString:@"Voddie Baucham"]){
            image = [UIImage imageNamed:@"voddiebaucham.jpg"];
        }
        if([[croppedTeachers objectAtIndex:i]isEqualToString:@"Kenny Petty"]){
            image = [UIImage imageNamed:@"kennypetty.jpg"];
        }
        if([[croppedTeachers objectAtIndex:i]isEqualToString:@"John Onwuchekwa"]){
            image = [UIImage imageNamed:@"johnO.jpg"];
        }
        if([[croppedTeachers objectAtIndex:i]isEqualToString:@"John Piper"]){
            image = [UIImage imageNamed:@"johnpiper.jpg"];
        }
        if([[croppedTeachers objectAtIndex:i]isEqualToString:@"Shai Linne"]){
            image = [UIImage imageNamed:@"shai_big.jpg"];
        }
        if([[croppedTeachers objectAtIndex:i]isEqualToString:@"Art Azurdia"]){
            image = [UIImage imageNamed:@"artAzurdiaImage.jpg"];
        }
        if([[croppedTeachers objectAtIndex:i]isEqualToString:@"Jason Lancaster"]){
            image = [UIImage imageNamed:@"lancaster.jpg"];
        }
        if([[croppedTeachers objectAtIndex:i]isEqualToString:@"Paul Washer"]){
            image = [UIImage imageNamed:@"washer.jpg"];
        }
        if([[croppedTeachers objectAtIndex:i]isEqualToString:@"Tim Conway"]){
            image = [UIImage imageNamed:@"conway.jpg"];
        }
        if([[croppedTeachers objectAtIndex:i]isEqualToString:@"Spencer Harmon"]){
            image = [UIImage imageNamed:@"spencerharmon.jpg"];
        }
        UIImage *tempImage = nil;
        CGSize targetSize = CGSizeMake(60,60);
        UIGraphicsBeginImageContext(targetSize);
        
        CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
        thumbnailRect.origin = CGPointMake(0.0,0.0);
        thumbnailRect.size.width  = targetSize.width;
        thumbnailRect.size.height = targetSize.height;
        
        [image drawInRect:thumbnailRect];
        
        tempImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        image = tempImage;
        
        [images2 addObject:image];
    }
    original = self.view;
    timer2 = [NSTimer timerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(update3:)
                                   userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
    
    
    
}
- (void)update3: (NSTimer*) timer {
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
    
    if (position == FrontViewPositionLeft){
        NSLog(@"ZZZZZZ");
        [self.view setUserInteractionEnabled:YES];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    else{
        NSLog(@"YYYYY");
        [self.view setUserInteractionEnabled:NO];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    titleList = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"sermonTitles"]];
    webSitesP = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"webSitesP"]];
    teachers = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"teacherNames"]];
    
    croppedTitles = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"croppedTitles"]];
    croppedTeachers = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"croppedNames"]];
    
    for(int i = 0; i < [croppedTitles count]; i ++){
        NSLog(@"%@",[croppedTeachers objectAtIndex:i]);
    }
    
    [self viewDidLoad];
    [_table reloadData];
    //NSLog(@"yoyoyoyoyoyo");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return [titleList count];
    }
    else{
        NSLog(@"%d", [croppedTitles count]);
        return [croppedTitles count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    int section = indexPath.section;
    
    UITableViewCell *cell = [tableViews dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if(section == 0){
        NSString* tt = [titleList objectAtIndex:indexPath.row];
        if([tt containsString:@"m4a"]){
            tt = [tt substringFromIndex:3];
        }
        cell.textLabel.text = tt;
    }
    else if(section == 1){
        cell.textLabel.text = [croppedTitles objectAtIndex:indexPath.row];
    }
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    if(section == 0){
        cell.imageView.image = [images objectAtIndex:indexPath.row];
    }
    else{
        cell.imageView.image = [images2 objectAtIndex:indexPath.row];
    }
    cell.imageView.alpha = 1.0;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText;
    if(indexPath.section == 0){
        cellText = [titleList objectAtIndex:indexPath.row];
    }
    else{
        cellText = [croppedTitles objectAtIndex:indexPath.row];
    }
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:12.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return 70;
}
- (NSString *)tableView:(UITableView *)tableViews titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return @"Downloaded Sermons";
    }
    else{
        return @"Trimmed Clips";
    }
}
- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"dload" sender:self];
    [tableViews deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)tableView:(UITableView *)tableViews commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    int section = indexPath.section;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSError *error;
    if(section == 0){
        if([[titleList objectAtIndex:indexPath.row] containsString:@"m4a"]){
            [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",[titleList objectAtIndex:indexPath.row],@".m4a"]] error:&error];
            NSLog(@"%@",[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",[titleList objectAtIndex:indexPath.row],@".m4a"]]);
            
            [titleList removeObjectAtIndex:indexPath.row];
            [webSitesP removeObjectAtIndex:indexPath.row];
            [teachers removeObjectAtIndex:indexPath.row];
            [images removeObjectAtIndex:indexPath.row];
            [prefs setObject:titleList forKey:@"sermonTitles"];
            [prefs setObject:teachers forKey:@"teacherNames"];
            [prefs setObject:webSitesP forKey:@"webSitesP"];
        }
        else{
            [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",[titleList objectAtIndex:indexPath.row],@".mp3"]] error:&error];
            NSLog(@"%@",[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",[titleList objectAtIndex:indexPath.row],@".mp3"]]);
            
            [titleList removeObjectAtIndex:indexPath.row];
            [webSitesP removeObjectAtIndex:indexPath.row];
            [teachers removeObjectAtIndex:indexPath.row];
            [images removeObjectAtIndex:indexPath.row];
            [prefs setObject:titleList forKey:@"sermonTitles"];
            [prefs setObject:teachers forKey:@"teacherNames"];
            [prefs setObject:webSitesP forKey:@"webSitesP"];
        }
    }
    else{
        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",[croppedTitles objectAtIndex:indexPath.row],@".m4a"]] error:&error];
        NSLog(@"%@",[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",[croppedTitles objectAtIndex:indexPath.row],@".m4a"]]);
        
        [croppedTitles removeObjectAtIndex:indexPath.row];
        [croppedTeachers removeObjectAtIndex:indexPath.row];
        [prefs setObject:croppedTitles forKey:@"croppedTitles"];
        [prefs setObject:croppedTeachers forKey:@"croppedNames"];
    }
    if(error){
        NSLog(@"failure");
    }
    
    
    
    [tableViews reloadData];
    [prefs synchronize];
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%@", text);
    if([segue.identifier isEqualToString:(@"dload")]){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        AudDownloadViewController *audio = [[AudDownloadViewController alloc]init];
        NSIndexPath *path = [_table indexPathForSelectedRow];
        int section = path.section;
        audio = [segue destinationViewController];
        if(section == 0){
            audio.theTitle = [titleList objectAtIndex:path.row];
            audio.teacher = [teachers objectAtIndex:path.row];
            /*if([[titleList objectAtIndex:path.row] containsString:@"m4a"]){
             audio.type = @"m4a";
             }else{*/
            audio.type = @"mp3";
            //}
            
            audio.websiteURL = [webSitesP objectAtIndex:path.row];
            NSString *iii = [NSString stringWithFormat:@"immanuel%@%@",[teachers objectAtIndex:path.row],[titleList objectAtIndex:path.row]];
            
            bool im = [prefs boolForKey:iii];
            
            if(im){
                audio.imman = @"Immanuel";
            }
            
        }
        else{
            audio.type = @"m4a";
            audio.theTitle = [croppedTitles objectAtIndex:path.row];
            audio.teacher = [croppedTeachers objectAtIndex:path.row];
            NSString *iii = [NSString stringWithFormat:@"immanuel%@%@",[croppedTeachers objectAtIndex:path.row],[croppedTitles objectAtIndex:path.row]];
            
            bool im = [prefs boolForKey:iii];
            
            if(im){
                audio.imman = @"Immanuel";
            }
        }
    }
}


@end
