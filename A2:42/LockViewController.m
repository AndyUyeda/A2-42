//
//  UIViewController+Lock.m
//  A2:42
//
//  Created by Andy Uyeda on 1/26/17.
//  Copyright © 2017 Andy Uyeda. All rights reserved.
//

#import "LockViewController.h"
#import <MessageUI/MessageUI.h>
#import "ToastView.h"

@import FirebaseAuth;

@interface LockViewController ()
@end
@implementation LockViewController

@synthesize passwordField, username;

- (IBAction)unlock:(id)sender {
    [[FIRAuth auth] signInWithEmail:username.text
                           password:passwordField.text
                         completion:^(FIRUser *user, NSError *error) {
                             if(error){
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                 message:error.localizedDescription
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"Dismiss"
                                                                       otherButtonTitles:nil];
                                 [alert show];
                             }
                             else{
                                 NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                                 [prefs setBool:YES forKey:@"lock"];
                                 [prefs synchronize];
                                 [self.view endEditing:YES ];
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }
                         }];
}

- (IBAction)email:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"A2:42 Access Request"];
        [mail setMessageBody:@"Hey, my name is... \n\nI heard about this app through... \n\nDo you mind giving me access?" isHTML:NO];
        [mail setToRecipients:@[@"UyedaDevelopments@gmail.com"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Device is unable to access your email"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES ];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            [ToastView showToastInParentView:self.view withText:@"Email Sent" withDuaration:4.0];
            
            break;
        case MFMailComposeResultSaved:
            [ToastView showToastInParentView:self.view withText:@"Draft Saved" withDuaration:4.0];
            
            break;
        case MFMailComposeResultCancelled:
            [ToastView showToastInParentView:self.view withText:@"Email Cancelled" withDuaration:4.0];
            
            break;
        case MFMailComposeResultFailed:
            [ToastView showToastInParentView:self.view withText:@"Email Failed" withDuaration:4.0];
            break;
        default:
            [ToastView showToastInParentView:self.view withText:@"Email Failed" withDuaration:4.0];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
