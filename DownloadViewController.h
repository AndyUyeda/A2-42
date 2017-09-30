//
//  DownloadViewController.h
//  A2:42
//
//  Created by Andy Uyeda on 7/4/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface DownloadViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;


@end
