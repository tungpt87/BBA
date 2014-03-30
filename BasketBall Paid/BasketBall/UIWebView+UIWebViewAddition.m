//
//  UIWebView+UIWebViewAddition.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIWebView+UIWebViewAddition.h"

@implementation UIWebView (UIWebViewAddition)
- (void)awakeFromNib{
    [super awakeFromNib];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            if (self.tag != kScrollableWebViewTag) {
                [(UIScrollView*)view setScrollEnabled:NO];
            }
            [(UIScrollView*)view setBackgroundColor:[UIColor clearColor]];
            break;
        }
    }
    
}

@end
