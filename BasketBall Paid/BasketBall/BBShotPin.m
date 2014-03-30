//
//  BBShotPin.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBShotPin.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+UIColorAddition.h"
@implementation BBShotPin
@synthesize isScored = _isScored;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(longPress:)];
        
        


//        [self addGestureRecognizer:longPress];
        [longPress release];
        _isScored = NO;

        CGFloat r = 15;
        [self.layer setCornerRadius:r];

    }
    return self;
}




- (void) longPress:(id)sender{
    [self becomeFirstResponder];
    UIMenuController *menuController = [[UIMenuController alloc] init];
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"Remove" action:@selector(removeFromSuperview)];
    [menuController setMenuItems:[NSArray arrayWithObject:item]];
    [item release];
    [menuController setTargetRect:[self frame]
                           inView:self.superview];
    
    [menuController setMenuVisible:YES animated:YES];
    [menuController release];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (void)setIsScored:(BOOL)isScored{
    _isScored = isScored;
    if (_isScored) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"#368FB8"]];
    }
    else{
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (CGPoint) location{
    if (self.superview) {
        CGFloat x = self.frame.origin.x / self.superview.frame.size.width;
        CGFloat y = self.frame.origin.y / self.superview.frame.size.height;
        return CGPointMake(x, y);
    }
    return CGPointZero;
}

- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    [self setNeedsDisplay];
}

- (void) removeSelf{
    NSLog(@"Shot pin remove itself");
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setAlpha:0];
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [self setAlpha:1];
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
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"Shot pin dragged");
//    if (touches.count == 1 && event.type == UIEventTypeMotion) {
//        self.center = [[touches anyObject] locationInView:self.superview];
//    }
//}
- (void)removeFromSuperview{
    [super removeFromSuperview];
    NSLog(@"Shotpin Removefromsuperview");
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShotPinDidRemoveFromSuperView
                                                        object:nil];

}
@end
