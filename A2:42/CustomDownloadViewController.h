//
//  UIViewController+CustomDownloadViewController.h
//  A2:42
//
//  Created by Andy Uyeda on 12/29/16.
//  Copyright © 2016 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDownloadViewController : UIViewController <NSURLConnectionDelegate,UIWebViewDelegate>{
    NSMutableData *fileData;
}


@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *teacherField;
@property (weak, nonatomic) IBOutlet UITextField *linkField;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIProgressView *showProgress;

- (IBAction)downloaded:(id)sender;

@end
