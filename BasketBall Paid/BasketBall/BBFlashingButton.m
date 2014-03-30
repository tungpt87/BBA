//
//  BBFlashingButton.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBFlashingButton.h"

@implementation BBFlashingButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    _imvBackground = [[UIImageView alloc] initWithFrame:frame];
//    _button = [[UIButton alloc] initWithFrame:frame];
    _imvFlashing = [[UIImageView alloc] initWithFrame:frame];
    [_imvFlashing setUserInteractionEnabled:NO];
    [_imvFlashing setAlpha:0];
//    [self addSubview:_imvBackground];
//    [self addSubview:_button];
    [self addSubview:_imvFlashing];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setAdjustsImageWhenHighlighted:YES];
}

- (void)dealloc{
    [super dealloc];
    F_RELEASE(_imvFlashing);
    F_RELEASE(_imvBackground);
    F_RELEASE(_button);
}

- (void) setBackGroundImage:(UIImage*)anImage{
//    [_button setBackgroundImage:anImage
//                       forState:UIControlStateNormal];
    [self setImage:anImage
          forState:UIControlStateNormal];

}

- (void) setFlashingImage:(UIImage*)anImage{
    [_imvFlashing setImage:anImage];
}

- (void) addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)event{
    [super addTarget:target
              action:action
    forControlEvents:event];
//    [_button addTarget:target
//                action:action
//      forControlEvents:event];
}

- (void) toggleFlashing:(BOOL) flashing{
    [_imvFlashing setAlpha:0];
    if (flashingTimer) {
        [flashingTimer invalidate];
        flashingTimer = nil;
    }
    if (flashing) {
        [self flashingIn];
        flashingTimer = [NSTimer scheduledTimerWithTimeInterval:2*kFlashingDuration
                                                         target:self
                                                       selector:@selector(flashingIn) 
                                                       userInfo:nil
                                                        repeats:YES];
    }
}

- (void) flashingIn{
    [UIView animateWithDuration:kFlashingDuration
                     animations:^{
                         [_imvFlashing setAlpha:1];
                     } completion:^(BOOL finished) {
                         [self flashingOut];
                     }];
}
- (void) flashingOut{
    [UIView animateWithDuration:kFlashingDuration
                     animations:^{
                         [_imvFlashing setAlpha:0];
                     }];
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        [self setAlpha:1];
    } else {
        [self setAlpha:0.5];
    }
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
