//
//  IBCViewController.h
//  A2:42
//
//  Created by Andy Uyeda on 6/24/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBCViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    NSMutableArray* pickerViewArray;
}
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *pickerViewArray;
@property (nonatomic, retain) NSMutableArray *dateWebsiteArray;
@property (weak, nonatomic) IBOutlet UIButton *currentSermon;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

- (IBAction)dateSelected:(id)sender;
- (IBAction)onOurHearts:(id)sender;

- (IBAction)sermonTapped;

@end
