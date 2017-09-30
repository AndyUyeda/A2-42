//
//  FirstViewController.h
//  Immanuel
//
//  Created by Andy Uyeda on 9/18/15.
//  Copyright © 2015 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface FirstViewController : UIViewController <SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *currentSermonButton;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;
- (IBAction)currentSermonSelected:(id)sender;


@end

