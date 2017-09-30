//
//  DateViewController.h
//  A2:42
//
//  Created by Andy Uyeda on 7/8/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSString *date;
@property (strong, nonatomic)  NSString *imman;
@property (strong, nonatomic)  NSString *type;
@property (strong, nonatomic)  NSString *dateURL;
@property (strong, nonatomic)  NSString *teacher;
@property (weak, nonatomic) IBOutlet UIImageView *theGateLogo;
@property (weak, nonatomic) IBOutlet UIImageView *ibcLogo;
@property (weak, nonatomic) IBOutlet UIImageView *graceCommunityLogo;
@property (weak, nonatomic) IBOutlet UIImageView *bluePrintLogo;
@property (weak, nonatomic) IBOutlet UIImageView *dglogo;
@property (weak, nonatomic) IBOutlet UIImageView *hwlogo;
@property (weak, nonatomic) IBOutlet UIImageView *heartCryLogo;
@property (weak, nonatomic) IBOutlet UIImageView *gccLogo;
@property (weak, nonatomic) IBOutlet UIImageView *trinityLogo;
@property (weak, nonatomic) IBOutlet UIImageView *cornerStoneLogo;
@property (weak, nonatomic) IBOutlet UIImageView *bridgepointLogo;
@property (weak, nonatomic) IBOutlet UIImageView *holyCityLogo;

@end
