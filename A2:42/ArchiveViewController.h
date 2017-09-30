//
//  DateViewController.h
//  A2:42
//
//  Created by Andy Uyeda on 7/8/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic)  NSString *date;
@property (weak, nonatomic)  NSString *type;
@property (weak, nonatomic)  NSString *dateURL;
@property (weak, nonatomic)  NSString *teacher;

@end
