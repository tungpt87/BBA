//
//  BBActionView.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBActionView.h"

@implementation BBActionView
@synthesize actionType;
@synthesize isMade;
@synthesize delegate;
@synthesize selected = _selected;
@synthesize isFlashing;
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
    NSLog(@"[ActionBox] AwakeFromNib");
    CGRect frame = [self.superview convertRect:self.frame toView:self];
    imvBackGround = [[UIImageView alloc] initWithFrame:frame];
    imvFlashing = [[UIImageView alloc] initWithFrame:frame];
    button = [[UIButton alloc] initWithFrame:frame];
    [self addSubview:imvBackGround];
    [self addSubview:imvFlashing];
    [self addSubview:button];
    [imvFlashing setAlpha:0];
}
- (void)setSelected:(BOOL)selected{
//    NSLog(@"[ActionBox] setSelected: %d",selected);
    _selected = selected;
    if (selected) {
        [imvBackGround setImage:imSelected];
    } else {
        [imvBackGround setImage:imNormal];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(actionViewDidTap:)]) {
        [self.delegate actionViewDidTap:self];
    }
    
}

- (BOOL) isSelected{
    return _selected;
}
- (void) toggleFlashing:(BOOL)flashing{
    isFlashing = flashing;
    [imvFlashing setAlpha:0];
    if (flashingTimer) {
        [flashingTimer invalidate];
        flashingTimer = nil;
    }

    //        [self setUserInteractionEnabled:flashing];
    if (flashing) {
        [self setSelected:NO];
        [self startFlashing];
        flashingTimer = [NSTimer scheduledTimerWithTimeInterval:2*kFlashingDuration
                                                         target:self
                                                       selector:@selector(startFlashing) 
                                                       userInfo:nil
                                                        repeats:YES];
        
    }
//    else {
//        if (flashingTimer) {
//            [flashingTimer invalidate];
//            flashingTimer = nil;
//        }
//    }

    if (flashing != isFlashing) {
        
    }
}

- (void) startFlashing{
    [self performSelectorOnMainThread:@selector(flashingIn)
                           withObject:nil
                        waitUntilDone:YES];    
}
- (void) flashingIn{
    //        NSLog(@"Action Box Flashing In");
    [imvFlashing setImage:imFlashing];
    [UIView animateWithDuration:kFlashingDuration 
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [imvFlashing setAlpha:1];
                     } completion:^(BOOL finished) {
//                         [imvFlashing setAlpha:0];
                         [self flashingOut];
                     }];
//    [UIView animateWithDuration:kFlashingDuration 
//                          delay:kFlashingDuration
//                        options:nil
//                     animations:^{
//                         [imvFlashing setAlpha:0];
//                     } completion:^(BOOL finished) {
//                         //                         [imvFlashing setAlpha:0];
//                     }];

}

- (void) flashingOut{
    
//    NSLog(@"Action Box Flashing Out");
    [imvFlashing setImage:imFlashing];
    [UIView animateWithDuration:kFlashingDuration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [imvFlashing setAlpha:0];
                     } completion:^(BOOL finished) {
                         //                         [bgImageView setImage:image];
                         //                         [subBgImageView setAlpha:0];
//                         if (isFlashing) {
//                             [self flashingIn];
//                         }

                     }];
}

- (void) repeatFlashing{
    if (isFlashing) {
        [self flashingIn];
    }
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    switch (state) {
        case UIControlStateNormal:
            F_RELEASE(imNormal);
            imNormal = [[UIImage alloc] initWithCGImage:image.CGImage];
//            [imvBackGround setImage:normal];
            break;
        case UIControlStateSelected:
            F_RELEASE(imSelected);
            imSelected = [[UIImage alloc] initWithCGImage:image.CGImage];
//            [imvBackGround setImage:imSelected];
            break;
        case UIControlStateFlashing:
            F_RELEASE(imFlashing);
            imFlashing = [[UIImage alloc] initWithCGImage:image.CGImage];
        default:
            break;
    }
    [self layoutSubviews];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [button addTarget:target
               action:action
     forControlEvents:controlEvents];

}
- (void)dealloc{
    [super dealloc];
    [self setDelegate:nil];
//    F_RELEASE(imvBackGround);
//    F_RELEASE(imvFlashing);
//    F_RELEASE(button);

}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (_selected) {
        [imvBackGround setImage:imSelected];
    } else {
        [imvBackGround setImage:imNormal];
    }
}
@end
