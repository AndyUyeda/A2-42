//
//  DesiringGodViewController.h
//  A2:42
//
//  Created by Andy Uyeda on 7/16/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesiringGodViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{

}



@property (weak, nonatomic) IBOutlet UIButton *currentViewButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIPickerView *apjPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *poemPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *sermonPickerView;
@property (weak, nonatomic) IBOutlet UILabel *listenToButton;



- (IBAction)sermonTapped:(id)sender;

- (IBAction)segmentedControlAction:(id)sender;

@end
