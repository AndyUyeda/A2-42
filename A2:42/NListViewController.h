//
//  NListViewController.h
//  A2:42
//
//  Created by Andy Uyeda on 5/18/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
@interface NListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;





@end
