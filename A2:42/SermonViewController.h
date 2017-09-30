//
//  FirstViewController.h
//  A2:42
//
//  Created by Andy Uyeda on 6/24/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface SermonViewController : UIViewController <SWRevealViewControllerDelegate>

@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) NSString *seen;

- (IBAction)fullertonPressed:(id)sender;
- (IBAction)piperPressed:(id)sender;

@end
