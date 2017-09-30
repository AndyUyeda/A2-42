//
//  MoreViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 5/13/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

#import "MoreViewController.h"
#import "AudioViewController.h"
#import "SWRevealViewController.h"
#import "SermonViewController.h"
#import "AppDelegate.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

NSMutableArray *recentTitleArray;
NSMutableArray *recentTeacherArray;
NSMutableArray *recentURLArray;

NSTimer *timer2;


NSMutableArray *favoriteTitleArray;
NSMutableArray *favoriteTeacherArray;
NSMutableArray *favoriteURLArray;

MoreViewController *th;
SermonViewController *sv;
bool added;



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
   
    added = true;
   
    self.revealViewController.delegate = self;
   
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //recentTitleArray = [NSMutableArray array];
    //recentTeacherArray = [NSMutableArray array];
    //recentURLArray = [NSMutableArray array];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    recentTitleArray = [[prefs objectForKey:@"recentTitles"] mutableCopy];
    recentURLArray = [[prefs objectForKey:@"recentSites"] mutableCopy];
    recentTeacherArray = [[prefs objectForKey:@"recentTeachers"] mutableCopy];
    
    
    favoriteTitleArray = [[prefs objectForKey:@"favoriteTitles"] mutableCopy];
    favoriteURLArray = [[prefs objectForKey:@"favoriteSites"] mutableCopy];
    favoriteTeacherArray = [[prefs objectForKey:@"favoriteTeachers"] mutableCopy];
    
    
    th = self;
    
    [self.tableView reloadData];
    timer2 = [NSTimer timerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(update3:)
                                   userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
    
    
}

- (void)update3: (NSTimer*) timer {
    
    AppDelegate *appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSString *receivingObj = appDel.sharedItem;
    
    if([receivingObj isEqualToString:@"3"]){
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position{
    
    AppDelegate *appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSString *receivingObj = appDel.sharedItem;
    
    if (th.isViewLoaded && th.view.window) {
        
        
        
        
        appDel.sharedItem = @"3";
    }
    else{
        
        
        if([receivingObj isEqualToString:@"-1"]){
            return;
        }
        
        appDel.sharedItem = @"2";
         
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section == 0){
        return [recentTitleArray count];
    }
    else{
        return [favoriteTitleArray count];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Recent";
    }
    else{
        return @"Favorites";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    cell.textLabel.text = @"HELLO";
    if(indexPath.section == 0){
        cell.textLabel.text = [recentTitleArray objectAtIndex:indexPath.row];
    }
    else{
        cell.textLabel.text = [favoriteTitleArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"audio" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - Navigation



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AppDelegate *appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    appDel.sharedItem = @"-1";
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if(path.section == 0){
        AudioViewController *audio = [[AudioViewController alloc]init];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        audio = [segue destinationViewController];
        audio.theTitle = [recentTitleArray objectAtIndex:path.row];
        audio.teacher = [recentTeacherArray objectAtIndex:path.row];;
        audio.websiteURL = [recentURLArray objectAtIndex:path.row];
        audio.tye = @"Back";
        NSString *iii = [NSString stringWithFormat:@"immanuel%@%@",[recentTeacherArray objectAtIndex:path.row],[recentTitleArray objectAtIndex:path.row]];
        
        bool im = [prefs boolForKey:iii];
        
        if(im){
            audio.imman = @"Immanuel";
        }
    }
    else{
        AudioViewController *audio = [[AudioViewController alloc]init];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        audio = [segue destinationViewController];
        audio.theTitle = [favoriteTitleArray objectAtIndex:path.row];
        audio.teacher = [favoriteTeacherArray objectAtIndex:path.row];
        audio.websiteURL = [favoriteURLArray objectAtIndex:path.row];
        audio.tye = @"Back";
        
        NSString *iii = [NSString stringWithFormat:@"immanuel%@%@",[favoriteTeacherArray objectAtIndex:path.row],[favoriteTitleArray objectAtIndex:path.row]];
        
        bool im = [prefs boolForKey:iii];
        
        if(im){
            audio.imman = @"Immanuel";
        }
    }
}


@end
