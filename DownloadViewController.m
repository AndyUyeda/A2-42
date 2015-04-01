//
//  DownloadViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 7/4/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import "DownloadViewController.h"
#import "AudDownloadViewController.h"

@implementation DownloadViewController

NSMutableArray *teachers;
NSMutableArray *titleList;
NSMutableArray *images;

- (void)viewDidLoad
{
    [super viewDidLoad];
    images = [NSMutableArray array];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    titleList = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"sermonTitles"]];
    teachers = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"teacherNames"]];
    self.navigationController.navigationBar.topItem.title = @"Downloads";
   
    
    for(int i = 0; i < [teachers count];i++)
    {
        UIImage *image;
        if([[teachers objectAtIndex:i]isEqualToString:@"Ryan Fullerton"]){
            image = [UIImage imageNamed:@"ryanfullerton.jpg"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"Voddie Baucham"]){
            image = [UIImage imageNamed:@"voddiebaucham.jpg"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"Kenny Petty"]){
            image = [UIImage imageNamed:@"kennypetty.jpg"];
        }
        if([[teachers objectAtIndex:i]isEqualToString:@"John Onwuchekwa"]){
            image = [UIImage imageNamed:@"johnO.jpg"];
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

    
}
-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    titleList = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"sermonTitles"]];
    teachers = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"teacherNames"]];
    
    [_table reloadData];
    //NSLog(@"yoyoyoyoyoyo");

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
    cell.textLabel.text = [titleList objectAtIndex:indexPath.row];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    cell.imageView.image = [images objectAtIndex:indexPath.row];
    cell.imageView.alpha = 1.0;
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
    NSString *title = @"Downloaded Sermons";
    return title;
}
- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"dload" sender:self];
    [tableViews deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)tableView:(UITableView *)tableViews commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",[titleList objectAtIndex:indexPath.row],@".mp3"]] error:&error];
    
    if(error){
        NSLog(@"failure");
    }
    
    [titleList removeObjectAtIndex:indexPath.row];
    [teachers removeObjectAtIndex:indexPath.row];
    [images removeObjectAtIndex:indexPath.row];
    [prefs setObject:titleList forKey:@"sermonTitles"];
    [prefs setObject:teachers forKey:@"teacherNames"];
    
    [tableViews reloadData];
    [prefs synchronize];
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%@", text);
    if([segue.identifier isEqualToString:(@"dload")]){
        AudDownloadViewController *audio = [[AudDownloadViewController alloc]init];
        NSIndexPath *path = [_table indexPathForSelectedRow];
        audio = [segue destinationViewController];
        audio.theTitle = [titleList objectAtIndex:path.row];
        audio.teacher = @"Ryan Fullerton";
        
    }
}


@end
