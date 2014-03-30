//
//  NSString+NSStringAddition.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+NSStringAddition.h"

@implementation NSString (NSStringAddition)
- (BOOL) isNonCaseSensitiveEqualToString:(NSString*)aString{
    NSString *src = [self uppercaseString];
    NSString *desc = [aString uppercaseString];
    if ([src rangeOfString:desc].length == self.length && [src rangeOfString:desc].location == 0) {
        return YES;
    }
    return NO;
}

@end
