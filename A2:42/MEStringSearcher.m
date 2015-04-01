//
//  MEStringSearcher.m
//  Meteorologist
//
//  Created by Matthew Fahrenbacher on Wed May 28 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "MEStringSearcher.h"


@implementation MEStringSearcher

- (id)initWithString:(NSString *)str
{
    self = [super init];
    if(self)
    {
        string = str;
        length = [string length];
        range = NSMakeRange(0,length);
    }
    return self;
}

BOOL validRange(NSRange range, int len)
{
    if (range.location == NSNotFound|| range.location + range.length > len)
        return NO;
        
    else
        return YES;
}

- (NSString *)getStringWithLeftBound:(NSString *)lft rightBound:(NSString *)rght
{
    NSString *newStr;
    NSRange newRange;
    
    NSRange leftRange;
    NSRange rightRange;
    float leftSum;
    float rightSum;
    
    if(!validRange(range,length))
        return nil;
    
    
    leftRange = [string rangeOfString:lft                                                                                                     
                        options:NSCaseInsensitiveSearch  
                        range:range];
    if(!validRange(leftRange,length))
        return nil;
    leftSum = leftRange.location + leftRange.length;
    
    
    rightRange = [string rangeOfString:rght
                         options:NSCaseInsensitiveSearch
                         range:NSMakeRange(leftSum,length - leftSum)];
    if(!validRange(rightRange,length))
        return nil;
    rightSum = rightRange.location+rightRange.length;
        
        
    if(rightRange.location-leftSum <= 0)
        return nil;
    
    newRange = NSMakeRange(leftSum,rightRange.location-leftSum);
    if(!validRange(newRange,length))
        return nil;
    
    newStr = [string substringWithRange:newRange];
    
    if(rightSum != 0)
        rightSum--;
    
    range = NSMakeRange(rightSum,length - rightSum);
        
    return newStr;
}

- (void)moveBack:(int)dis
{
    if(range.location >= dis)
    {
        range.location -= dis;
        range.length += dis;
    }
}

- (void)moveForward:(int)dis
{
    if(dis <= range.length)
    {
        range.location += dis;
        range.length -= dis;
    }
}

- (void)moveToString:(NSString *)str
{
    NSRange tempR = [string rangeOfString:str                                                                                                     
                            options:NSCaseInsensitiveSearch  
                            range:range];
                            
    if(validRange(tempR,length))
    {
        range.location = tempR.location + tempR.length;
        range.length = length - range.location;
    }
}

- (void)moveToBeginning
{
    range = NSMakeRange(0,length);
}

@end
