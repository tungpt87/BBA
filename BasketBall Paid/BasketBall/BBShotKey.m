//
//  BBShotKey.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBShotKey.h"

@implementation BBShotKey

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat r = 20;
        [self.layer setCornerRadius:r];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        UIFont *font = [UIFont systemFontOfSize:30];
        [label setFont:font];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setTextColor:[UIColor redColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:label];
    }
    return self;
}

- (void) setIsShotMade:(BOOL) isShotMade{
    if (isShotMade) {
        [self.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.layer setBorderWidth:3];
    } else {
        [self.layer setBorderColor:[UIColor clearColor].CGColor];
        [self.layer setBorderWidth:0];
    }
}

- (void) setPlayerNumber:(NSString*)playerNumber{
    [label setText:playerNumber];
}

- (void) removeSelf{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setAlpha:0];
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
