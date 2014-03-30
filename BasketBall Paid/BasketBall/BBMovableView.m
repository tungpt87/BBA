//
//  BBMovableView.m
//  BasketBall
//
//  Created by TungPT on 1/6/13.
//
//

#import "BBMovableView.h"

@implementation BBMovableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(didPan:)];
        [self addGestureRecognizer:panGesture];
        [panGesture release];
    }
    return self;
}
- (void) didPan:(UIPanGestureRecognizer*)panGesture{
    CGPoint location = [panGesture locationInView:self.superview];
    self.center = location;
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [self moveBegan];
    } else if (panGesture.state == UIGestureRecognizerStateChanged){
        [self moving];
    } else if (panGesture.state == UIGestureRecognizerStateEnded){
        [self moveEnd];
    }
}

- (void)moveBegan{
    
}

- (void)moveEnd{
    
}

- (void)moving{
    
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
