//
//  UIViewController+CustomDownloadViewController.m
//  A2:42
//
//  Created by Andy Uyeda on 12/29/16.
//  Copyright © 2016 Andy Uyeda. All rights reserved.
//

#import "CustomDownloadViewController.h"
#import "MEStringSearcher.h"

@interface CustomDownloadViewController()

@end

@implementation CustomDownloadViewController
@synthesize titleField,teacherField,linkField,downloadButton, showProgress;

long long totalFileSize;
NSURLConnection *conn;
NSMutableArray *titles;
NSMutableArray *teacherNames;
NSMutableArray *webSitesP;
NSString* title;
NSString* teacher;
NSString* llink;
NSString* wTitle;
NSString* wTeacher;
NSString* wLink;
NSString* mediaType;

- (void)viewDidLoad {
    [super viewDidLoad];
    fileData = [NSMutableData data];
    self.navigationItem.title = @"Download";
    
    //https://sites.google.com/site/atwofourtwo/home/audio
    
    @try {
        NSURL *url = [NSURL URLWithString:@"https://sites.google.com/site/atwofourtwo/home/audio"];
        NSString *webData = [NSString stringWithContentsOfURL:url];
        NSError *error;
        if (webData == nil) {
            // an error occurred
            NSLog(@"Error reading file at %@\n%@",
                  url, [error localizedFailureReason]);
            // implementation continues ...
        }
        else{
            MEStringSearcher* searcher = [[MEStringSearcher alloc] initWithString:webData];
            wTitle = [searcher getStringWithLeftBound:@"TTitle:" rightBound:@"TTitle"];
            wLink = [searcher getStringWithLeftBound:@"LLink:" rightBound:@"LLink"];
            wTeacher = [searcher getStringWithLeftBound:@"TTeacher:" rightBound:@"TTeacher"];
            
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    tapRecognizer.numberOfTapsRequired = 5;
    [self.view addGestureRecognizer:tapRecognizer];
    self.view.tag=2;
}
-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender
{
    if(sender.view.tag==2) {
        //do something here
        NSLog(@"HEY");
        [titleField setText:wTitle];
        [teacherField setText:wTeacher];
        [linkField setText:wLink];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [titleField resignFirstResponder];
    [teacherField resignFirstResponder];
    [linkField resignFirstResponder];
}
- (IBAction)downloaded:(id)sender {
    title = titleField.text;
    teacher = teacherField.text;
    llink = linkField.text;
    
    NSLog(@"%@",title);
    NSLog(@"%@",teacher);
    NSLog(@"%@",llink);
    if([llink containsString:@"mp3"]){
        NSLog(@"%@",@"is MP3");
        mediaType = @"mp3";
    }
    else if([llink containsString:@"m4a"]){
        NSLog(@"%@",@"is M4A");
        mediaType = @"m4a";
        title = [NSString stringWithFormat:@"%@%@",@"m4a",title];
    }
    
    if(teacher != nil && title != nil && llink != nil){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        titles = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"sermonTitles"]];
        teacherNames = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"teacherNames"]];
        webSitesP = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"webSitesP"]];
        BOOL alreadyExists = FALSE;
        
        for(int i = 0; i < [titles count];i++){
            if([[titles objectAtIndex:i] isEqualToString:title]){
                alreadyExists = TRUE;
            }
        }
        
        if(!alreadyExists){
            
            NSURL *mpurl = [NSURL URLWithString:llink];
            NSURLRequest* req = [NSURLRequest requestWithURL:mpurl];
            conn = [NSURLConnection connectionWithRequest:req delegate:self];
            
        }
    }
}

-(void)connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse *)response{
    [showProgress setHidden: FALSE];
    [downloadButton setHidden:TRUE];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [fileData setLength:0];
    totalFileSize = [response expectedContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [fileData appendData:data];
    float progressive = (float)[fileData length] / (float)totalFileSize;
    [showProgress setProgress:progressive];
    //NSLog(@"%f",progressive);
}
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:    (NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,    NSUserDomainMask, YES);
    //NSLog(@"%@", [dirArray objectAtIndex:0]);
    NSString *path;
    if([mediaType isEqualToString:@"mp3"]){
        path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",title,@".mp3"]];
    }
    else if([mediaType isEqualToString:@"m4a"]){
        path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",title,@".m4a"]];
    }
    
    [showProgress setHidden: TRUE];
    [downloadButton setHidden:FALSE];
    
    if ([fileData writeToFile:path options:NSAtomicWrite error:nil] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"Audio Could Not Download"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [titles addObject:title];
        [teacherNames addObject:teacher];
        [webSitesP addObject:llink];
        
        [prefs setObject:titles forKey:@"sermonTitles"];
        [prefs setObject:teacherNames forKey:@"teacherNames"];
        [prefs setObject:webSitesP forKey:@"webSitesP"];
        [prefs synchronize];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Audio Downloaded Successfully"
                                                       delegate:nil
                                              cancelButtonTitle:@"Great"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
