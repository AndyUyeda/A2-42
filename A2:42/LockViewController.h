//
//  UIViewController+Lock.h
//  A2:42
//
//  Created by Andy Uyeda on 1/26/17.
//  Copyright © 2017 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface LockViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *username;
- (IBAction)unlock:(id)sender;
- (IBAction)email:(id)sender;


@end
