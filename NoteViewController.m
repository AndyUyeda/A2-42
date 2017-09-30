//
//  NoteViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 5/17/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

@synthesize textView,theTitle,teacher,realT,realN;

NSMutableArray *noteTitles;
NSMutableArray *notesArray;

NSString *title1;
NSString *note;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    textView.delegate = self;
    if(realT == nil){
        NSLog(@"A");
        NSString *last = [[teacher componentsSeparatedByString:@" "] objectAtIndex:1];
        title1 = [NSString stringWithFormat:@"%@%@%@", last, @" - ", theTitle];
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        noteTitles = [[prefs objectForKey:@"noteTitles"] mutableCopy];
        notesArray = [[prefs objectForKey:@"notesArray"] mutableCopy];
        
        if(noteTitles == nil){
            NSLog(@"nillllll");
            
            notesArray = [NSMutableArray array];
            noteTitles = [NSMutableArray array];
        }
        int index = -1;
        for(int i = 0; i < [noteTitles count]; i++){
            if([[noteTitles objectAtIndex:i]isEqualToString:title1]){
                index = i;
            }
        }
        if(index != -1){
            NSString* string = [notesArray objectAtIndex:index];
            textView.text = string;
        }
        
        
    }
    else{
        NSLog(@"B");
        title1 = realT;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        noteTitles = [[prefs objectForKey:@"noteTitles"] mutableCopy];
        notesArray = [[prefs objectForKey:@"notesArray"] mutableCopy];
        
        if(noteTitles == nil){
            NSLog(@"nillllll");
            
            notesArray = [NSMutableArray array];
            noteTitles = [NSMutableArray array];
        }
        int index = -1;
        for(int i = 0; i < [noteTitles count]; i++){
            if([[noteTitles objectAtIndex:i]isEqualToString:title1]){
                index = i;
            }
        }
        if(index != -1){
            textView.text = realN;
        }

    
    }
    self.navigationItem.title = title1;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES ];
}
-(void)textViewDidBeginEditing:(UITextView *)ttextView{
    textView.frame = CGRectMake(49, 105, 223, 150);
    if([textView.text isEqualToString:@"Tap to Create"]){
        textView.text = @"";
    }
}
-(void)textViewDidEndEditing:(UITextView *)ttextView{
    textView.frame = CGRectMake(49, 105, 223, 306);
    if([textView.text isEqualToString:@""]){
        textView.text = @"Tap to Create";
    }
}
-(void)textViewDidChange:(UITextView *)ttextView{
    NSLog(@"%@",textView.text);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if(![textView.text isEqualToString:@""] && ![textView.text isEqualToString:@"Tap to Create"]){
        
        
        int index = -1;
        for(int i = 0; i < [noteTitles count]; i++){
            if([[noteTitles objectAtIndex:i]isEqualToString:title1]){
                index = i;
            }
        }
        if(index != -1){
            
            [noteTitles removeObjectAtIndex:index];
            [notesArray removeObjectAtIndex:index];
            
        }
        [noteTitles insertObject:title1 atIndex:0];
        [notesArray insertObject:textView.text atIndex:0];
        
        [prefs setObject:noteTitles forKey:@"noteTitles"];
        [prefs setObject:notesArray forKey:@"notesArray"];
    }
    [prefs synchronize];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
