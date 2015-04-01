//
//  MEStringSearcher.h
//  Meteorologist
//
//  Created by Matthew Fahrenbacher on Wed May 28 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MEStringSearcher : NSObject
{
    NSString *string;
    NSRange range;
    int length;
}



- (id)initWithString:(NSString *)str;

- (NSString *)getStringWithLeftBound:(NSString *)lft rightBound:(NSString *)rght;

- (void)moveBack:(int)dis;
- (void)moveForward:(int)dis;
- (void)moveToString:(NSString *)str;
- (void)moveToBeginning;

@end
