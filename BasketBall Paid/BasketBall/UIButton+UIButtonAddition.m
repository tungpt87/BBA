//
//  UIButton+UIButtonAddition.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIButton+UIButtonAddition.h"

@implementation UIButton (UIButtonAddition)
- (void)setHidden:(BOOL)hidden{
    if (hidden) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self setAlpha:0];
                         }];
    } else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self setAlpha:1]; 
                         }];
    }
}

- (void)setEnabled:(BOOL)enabled{
    if (!self.alpha == 0) {
        if (enabled) {
            [self setAlpha:1];
        } else {
            [self setAlpha:0.5];
        }
    } else {
        [self setAlpha:0];
    }
    [self setUserInteractionEnabled:enabled];
}
@end
