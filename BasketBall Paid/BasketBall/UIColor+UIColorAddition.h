//
//  UIColor+UIColorAddition.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColorAddition)
+ (UIColor *)colorWithHex:(UInt32)col;
+ (UIColor *)colorWithHexString:(NSString *)str;
@end
