//
//  NoteViewController.h
//  A2:42
//
//  Created by Andy Uyeda on 5/17/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic)  NSString *theTitle;
@property (weak, nonatomic)  NSString *teacher;
@property (weak, nonatomic)  NSString *realT;
@property (weak, nonatomic)  NSString *realN;

@end
