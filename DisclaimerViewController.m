//
//  UIViewController+DisclaimerViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 7/14/16.
//  Copyright © 2016 Andy Uyeda. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Disclaimer";
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    tapRecognizer.numberOfTapsRequired = 5;
    [self.view addGestureRecognizer:tapRecognizer];
    self.view.tag=2;
}
-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender
{
    if(sender.view.tag==2) {
        //do something here
        NSLog(@"HEY");
        [self performSegueWithIdentifier:@"dd" sender:self];
    }
}

@end
