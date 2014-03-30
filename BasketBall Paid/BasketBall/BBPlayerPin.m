//
//  BBPlayerPin.m
//  BasketBall
//
//  Created by TungPT on 1/5/13.
//
//

#import "BBPlayerPin.h"
#import "BBBallPin.h"
#import <QuartzCore/QuartzCore.h>
@implementation BBPlayerPin
- (id) initWithPlayer:(BBPlayer*)player{
    self = [self initWithFrame:CGRectMake(0, 0, 60, 60)];
    if (self) {
        self.player = player;
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(doubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = 30;
    self.layer.borderColor = self.color.CGColor;
    self.layer.borderWidth = 5;
    [self setBackgroundColor:self.color];
    [self setClipsToBounds:YES];
    if (!imvBall) {
        imvBall = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
        [self addSubview:imvBall];
        lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:lblNumber];
        [lblNumber setFont:[UIFont boldSystemFontOfSize:30]];
        [lblNumber setTextAlignment:NSTextAlignmentCenter];
        [lblNumber setBackgroundColor:[UIColor clearColor]];
        [lblNumber setTextColor:[UIColor whiteColor]];
    }
    [lblNumber setText:self.player.number];
    if ([self.player withBall]) {
        [imvBall setImage:[UIImage imageNamed:@"ball.png"]];
    } else {
        [imvBall setImage:nil];
    }
    self.center = self.player.fullCourtLocation;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void) doubleTap:(UITapGestureRecognizer*)doubleTap{
    if (self.player.withBall) {
        self.player.withBall = NO;
        [self setNeedsLayout];
        [BBBallPin defaultBallPin].center = self.center;
        [self.superview addSubview:[BBBallPin defaultBallPin]];
    }
}
- (void)moving{
    [self.player setFullCourtLocation:self.center];
}
- (void)hitToView:(UIView *)view{
    if ([view isKindOfClass:[BBBallPin class]]) {
        [self.player setWithBall:YES];
        [view removeFromSuperview];
        [self setNeedsLayout];
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
