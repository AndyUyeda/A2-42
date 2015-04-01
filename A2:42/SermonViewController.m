//
//  FirstViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 6/24/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import "SermonViewController.h"
#import "IBCViewController.h"
#import "DateViewController.h"
#import "DesiringGodViewController.h"

@interface SermonViewController ()

@end

@implementation SermonViewController
@synthesize fullertonButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.navigationItem.title = @"Sermons";
    self.navigationController.navigationBar.topItem.title = @"Preachers";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonPressed{
    if(fullertonButton.isSelected){
        [self performSegueWithIdentifier:@"ibc" sender:self];
    }

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:(@"ibc")]){
        IBCViewController *ibc = [[IBCViewController alloc]init];
        ibc = [segue destinationViewController];
    }
    if([segue.identifier isEqualToString:(@"voddie")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"Voddie Baucham";
        date.date = @"Voddie Baucham";
        date.dateURL = @"http://www.sermonaudio.com/search.asp?speakeronly=true&currsection=sermonsspeaker&keyword=Voddie_Baucham";
    }
    if([segue.identifier isEqualToString:(@"petty")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"Kenny Petty";
        date.date = @"Kenny Petty";
        date.dateURL = @"http://www.sermonaudio.com/search.asp?speakeronly=true&currsection=sermonsspeaker&keyword=Kenny_Petty";
    }
    if([segue.identifier isEqualToString:(@"onwuchekwa")]){
        DateViewController *date = [[DateViewController alloc]init];
        date = [segue destinationViewController];
        date.teacher = @"John Onwuchekwa";
        date.date = @"John Onwuchekwa";
        date.dateURL = @"http://blueprintchurch.org/speaker/john-onwuchekwa/";
    }
    if([segue.identifier isEqualToString:(@"piper")]){
        DesiringGodViewController *desiring = [[DesiringGodViewController alloc]init];
        desiring = [segue destinationViewController];
    }

    
}

@end
