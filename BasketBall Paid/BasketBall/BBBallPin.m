//
//  BBBallPin.m
//  BasketBall
//
//  Created by TungPT on 1/5/13.
//
//

#import "BBBallPin.h"
#import "BBPlayerPin.h"
static BBBallPin *instance;
@implementation BBBallPin
+ (BBBallPin*) defaultBallPin{
    if (!instance) {
        instance = [[BBBallPin alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        UIImageView *imvBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [imvBg setImage:[UIImage imageNamed:@"ball.png"]];
        [instance addSubview:imvBg];
        [instance setCenter:CGPointMake(344, 472)];
    }
    return instance;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)moveBegan{
    [self.superview bringSubviewToFront:self];
}
- (void)moveEnd{
    UIPanGestureRecognizer *panGesture = nil;
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            panGesture = (UIPanGestureRecognizer*)gesture;
            break;
        }
    }
    CGPoint location = [panGesture locationInView:self.superview];
    NSArray *subviews = [self.superview subviews];
    BBPlayerPin *playerPin = nil;
    for (UIView *view in subviews) {
        CGRect frame = view.frame;
        if (CGRectContainsPoint(frame, location)) {
            if ([view isKindOfClass:[BBPlayerPin class]]) {
                playerPin = (BBPlayerPin*)view;
                break;
            }
        }
    }
    if (playerPin) {
        [playerPin hitToView:self];
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
