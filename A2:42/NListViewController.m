//
//  NListViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 5/18/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

#import "NListViewController.h"
#import "NoteViewController.h"
#import "AppDelegate.h"


@interface NListViewController ()

@end

@implementation NListViewController
@synthesize table;

NSMutableArray *noteTitles;
NSMutableArray *notesArray;
bool added;
NSTimer *timer2;
UIView *original;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    noteTitles = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"noteTitles"]];
    notesArray = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"notesArray"]];
    
    
    [table reloadData];
    self.revealViewController.delegate = self;
    self.navigationController.navigationBar.topItem.title = @"Notes";
    original = self.view;
    // Do any additional setup after loading the view.
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

-(void)viewWillAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    noteTitles = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"noteTitles"]];
    notesArray = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"notesArray"]];
    
    
    [table reloadData];
    self.navigationController.navigationBar.topItem.title = @"Notes";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [noteTitles count]; //change
}
- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableViews dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    cell.textLabel.text = [noteTitles objectAtIndex:indexPath.row];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [noteTitles objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:12.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return 70;
}
- (NSString *)tableView:(UITableView *)tableViews titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"Notes";
    return title;
}
- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"nts" sender:self];
    [tableViews deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //NSLog(@"%@", text);
    if([segue.identifier isEqualToString:(@"nts")]){
        NoteViewController *note = [[NoteViewController alloc]init];
        NSIndexPath *path = [table indexPathForSelectedRow];
        note = [segue destinationViewController];
        note.realT = [noteTitles objectAtIndex:path.row];
        note.realN = [notesArray objectAtIndex:path.row];
        
    }
}

-(void)tableView:(UITableView *)tableViews commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [noteTitles removeObjectAtIndex:indexPath.row];
    [notesArray removeObjectAtIndex:indexPath.row];
    [prefs setObject:noteTitles forKey:@"noteTitles"];
    [prefs setObject:notesArray forKey:@"notesArray"];
    
    [table reloadData];
    [prefs synchronize];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
