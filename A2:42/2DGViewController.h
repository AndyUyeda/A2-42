//
//  2DGViewController.h
//  A2:42
//
//  Created by Andy Uyeda on 5/8/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _DGViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
}
@property (weak, nonatomic)  NSString *type;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *desiringGod;



@end
