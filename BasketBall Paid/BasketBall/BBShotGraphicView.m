//
//  BBShotGraphicView.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBShotGraphicView.h"
#import "BBFullCourtView.h"
@implementation BBShotGraphicView
@synthesize shotPin;
@synthesize actionType = _actionType;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    interaction = userInteractionEnabled;
}
- (void) viewTapped:(UITapGestureRecognizer*)tapGesture{
    if (interaction) {
        location = [tapGesture locationInView:self];
        CGPoint bLoc = [self basketLocation];
        CGFloat radius = INLINE_RADIUS;
        if (((self.actionType == ACTION_TYPE_THREEMADE || self.actionType == ACTION_TYPE_THREEMISS || self.actionType == ACTION_TYPE_TWOMISS) && [CommonUtils distanceFromPoint:bLoc toPoint:location] > radius) || ((self.actionType == ACTION_TYPE_TWOMADE || self.actionType == ACTION_TYPE_TWOMISS) && [CommonUtils distanceFromPoint:bLoc toPoint:location] <= radius)) {
            if (!shotPin) {
                shotPin = [[BBShotPin alloc] initWithFrame:CGRectMake(0, 0, SHOTPIN_SMALL_SIZE, SHOTPIN_SMALL_SIZE)];
            }else {
                [shotPin setFrame:CGRectMake(0, 0, SHOTPIN_SMALL_SIZE, SHOTPIN_SMALL_SIZE)];
            }
            [shotPin setCenter:location];
            if (!shotPin.superview) {
                [self addSubview:shotPin];
            }
            if (self.actionType == ACTION_TYPE_THREEMADE || self.actionType == ACTION_TYPE_TWOMADE) {
                [self shotPinSetMade];
            }
            else {
                [self shotPinSetMiss];
            }
            [self toggleFlashing:NO];
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowFullCourt
                                                            object:nil];
    }
}
- (NSInteger) pointForLocation:(CGPoint)aLocation{
    CGPoint bLoc = [self basketLocation];
    CGFloat radius = INLINE_RADIUS;
    if ([CommonUtils distanceFromPoint:bLoc toPoint:aLocation] > radius) {
        return 3;
    } else {
        return 2;
    }
}
- (void) shotPinSetMade{
    if (shotPin) {
        [shotPin setIsScored:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShotPinDidChangeValue
                                                        object:shotPin];
}

- (void) shotPinSetMiss{
    if (shotPin) {
        [shotPin setIsScored:NO];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShotPinDidChangeValue
                                                        object:shotPin];
}
- (void) clear{
    [shotPin removeSelf];

}
- (CGPoint) basketLocation{
    CGPoint basketLocation = CGPointMake(self.frame.size.width / 2, 0);
    return basketLocation;
}


- (NSInteger) score{
    CGPoint bLoc = [self basketLocation];
    CGFloat radius = INLINE_RADIUS;
    if ([CommonUtils distanceFromPoint:bLoc toPoint:location] > radius) {
        return 3;
    }
    else {
        return 2;
    }
}
#pragma mark - View life circle
- (void)awakeFromNib{
//    CGRect frame = self.frame;
    ///TODO: Add background image here
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(viewTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setDelegate:self];
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(didPan:)];
    [self addGestureRecognizer:panGesture];
    [panGesture release];
    [self setBackgroundColor:[UIColor clearColor]];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"court.png"]];
    [imageView setFrame:[self.superview convertRect:self.frame toView:self]];
    imvFlashing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"court_flashing.png"]];
    [imvFlashing setFrame:[self.superview convertRect:self.frame toView:self]];
    [self addSubview:imageView];
    [self addSubview:imvFlashing];
    [imvFlashing setAlpha:0];
    
    couldStartFlashing = YES;
}
- (void) didPan:(UIPanGestureRecognizer*)panGesture{
    
    if (shotPin) {
        CGPoint bLoc = [self basketLocation];
        CGFloat radius = INLINE_RADIUS;
        CGPoint desc = [panGesture locationInView:self];
        if (!CGRectContainsPoint(self.frame, [self convertPoint:desc toView:self.superview])) {
            return;
        }
        if (((self.actionType == ACTION_TYPE_THREEMADE || self.actionType == ACTION_TYPE_THREEMISS || self.actionType == ACTION_TYPE_TWOMISS) && [CommonUtils distanceFromPoint:bLoc toPoint:desc] > radius) || ((self.actionType == ACTION_TYPE_TWOMADE || self.actionType == ACTION_TYPE_TWOMISS) && [CommonUtils distanceFromPoint:bLoc toPoint:desc] <= radius)) {
            shotPin.center = desc;
        } else{
            CGFloat rate = INLINE_RADIUS / [CommonUtils distanceFromPoint:bLoc toPoint:desc];
            CGPoint center = CGPointMake(bLoc.x - (bLoc.x - desc.x)*rate, bLoc.y - (bLoc.y - desc.y)*rate);
            shotPin.center = center;
        }

    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"Draw Rect");
}
#pragma mark - ViewDelegate
- (BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark - Public methods
- (void) setEnable:(BOOL)enable{
    [self setUserInteractionEnabled:enable];
    if (!enable) {
        [shotPin removeSelf];
    }else {
        ///TODO: Code for flashing here
    }
    [self toggleFlashing:enable];
}

- (void) toggleFlashing:(BOOL)flashing{
    isFlashing = flashing;
    if (flashingTimer) {
        [flashingTimer invalidate];
        flashingTimer = nil;
    }
    [imvFlashing setAlpha:0];
    if (isFlashing) {
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
                         [imvFlashing setAlpha:1];
                     }completion:^(BOOL finished) {
                         [self flashingOut];
                     }];
}

- (void) flashingOut{
    [UIView animateWithDuration:kFlashingDuration
                     animations:^{
                         [imvFlashing setAlpha:0];
                     } completion:^(BOOL finished) {
                    }];
}
- (CGPoint) shotLocation{
    if (shotPin && shotPin.superview && shotPin.superview == self) {
        return shotPin.frame.origin;
    }
    return CGPointZero;
}

- (BBShotPin*) shotPin{
    if (shotPin && shotPin.superview == self) {
        return shotPin;
    }
    return nil;
}

- (void) setShotPinWithLocation:(CGPoint)pinLocation andType:(ACTION_TYPE)type{
    [self setEnable:YES];
    CGFloat x = pinLocation.x * self.frame.size.width;
    CGFloat y = pinLocation.y * self.frame.size.height;
    if (!shotPin) {
        shotPin = [[BBShotPin alloc] initWithFrame:CGRectMake(x, y, SHOTPIN_SMALL_SIZE, SHOTPIN_SMALL_SIZE)];
    }
    [shotPin setFrame:CGRectMake(x, y, SHOTPIN_SMALL_SIZE, SHOTPIN_SMALL_SIZE)];
    if (!shotPin.superview || shotPin.superview != self ) {
        [self addSubview:shotPin];
    }

    if (type == ACTION_TYPE_THREEMADE || type == ACTION_TYPE_TWOMADE) {
        [shotPin setIsScored:YES];
    }
    else {
        [shotPin setIsScored:NO];
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
    if ([touch view] == self) {
        return YES;
    }
    return NO;
}
     


@end
