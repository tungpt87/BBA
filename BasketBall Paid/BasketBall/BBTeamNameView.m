//
//  BBTeamNameView.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBTeamNameView.h"
#import "UIColor+UIColorAddition.h"
@implementation BBTeamNameView
@synthesize delegate;
@synthesize isInTechFoul = _isInTechFoul;
@synthesize isSelected = _isSelected;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    _isSelected = NO;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.layer setCornerRadius:5];
    [self setClipsToBounds:YES];
    flashingView = [[UIView alloc] initWithFrame:label.frame];
    [flashingView setBackgroundColor:[UIColor colorWithHexString:@"#368FB8"]];
    [flashingView setAlpha:0];
    [self addSubview:flashingView];
    UIFont *font = [UIFont boldSystemFontOfSize:labelFontSize];
    [label setFont:font];
    [label setTextColor:[UIColor darkTextColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setUserInteractionEnabled:YES];
    [self addSubview:label];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(didTap:)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(didLongPress:)];
    [tapGesture requireGestureRecognizerToFail:longPress];
    [label addGestureRecognizer:tapGesture];
    [label addGestureRecognizer:longPress];
    [tapGesture release];
    [longPress release];
    isEditable = YES;
}


- (void) setTeamName:(NSString*)teamName{
    if ([teamName length] == 0) {
        if (self.tag == TEAMPLAYERVIEW_TAG_A) {
            [label setText:DEFAULTNAME_TEAMA];
        }
        else {
            [label setText:DEFAULTNAME_TEAMB];
        }
        return;
    }
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:teamName];
}

- (NSString*)teamName{
    return label.text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) setIsEditable:(BOOL)editable{
    isEditable = editable;
}
- (void) didTap:(UITapGestureRecognizer*)tapGesture{
    if (isEditable && !_isInTechFoul) {
        if (self.delegate) {
            [self.delegate teamNameViewDidTapped:self];
        }
        [label setBackgroundColor:[UIColor lightGrayColor]];
    } else if (_isInTechFoul){
        [self setIsSelected:!_isSelected];
        if (self.delegate) {
            [self.delegate teamNameViewDidTechFoul:self];
        }
    }

}
- (void)setIsSelected:(BOOL)isSelected{
    if (_isInTechFoul) {
        _isSelected = isSelected;
        if (_isSelected) {
            [self setBackgroundColor:[UIColor colorWithHexString:@"#368FB8"]];
        } else {
            [self setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
}
- (void)setIsInTechFoul:(BOOL)isInTechFoul{
    _isInTechFoul = isInTechFoul;
    [self toggleFlashing:isInTechFoul];
    if (_isInTechFoul) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        [self setBackgroundColor:[UIColor clearColor]];
        _isSelected = NO;
    }

}
- (void)toggleFlashing:(BOOL)flashing{
    if (tmFlashing) {
        [tmFlashing invalidate];
        tmFlashing = nil;
    }
    if (flashing) {
        [self flashingIn];
        tmFlashing = [NSTimer scheduledTimerWithTimeInterval:kFlashingDuration*2
                                                      target:self
                                                    selector:@selector(flashingIn)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}
- (void) flashingIn{
    [UIView animateWithDuration:kFlashingDuration
                     animations:^{
                         [flashingView setAlpha:1];
                     } completion:^(BOOL finished) {
                         [self flashingOut];
                     }];
}
- (void) flashingOut{
    [UIView animateWithDuration:kFlashingDuration
                     animations:^{
                         [flashingView setAlpha:0];
                     } completion:^(BOOL finished) {
                         
                     }];
}
- (void) didLongPress:(UILongPressGestureRecognizer*)longPress{
    if (isEditable) {
        if (self.delegate) {
            [self.delegate teamNameViewDidLongPressed:self];
        }
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }

}

- (void) desellect{
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)dealloc{
    [super dealloc];
    [self setDelegate:nil];
}
@end
