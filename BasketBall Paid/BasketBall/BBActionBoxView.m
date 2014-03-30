//
//  BBToggleButtonsView.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBActionBoxView.h"
#import "BBActionView.h"

@implementation BBActionBoxView
@synthesize delegate;
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
}

- (void) setButtonTitles:(NSArray*)titles{

    CGRect frame = self.frame;  
    buttonWidth = frame.size.width - 2*kLeftMargin;
    buttonHeight = frame.size.height / [titles count] - ([titles count]+1)*kDistanceBetweenButtons;
//    CGFloat y = kDistanceBetweenButtons;
//    CGFloat x = kLeftMargin;
    }
- (void)layoutSubviews{
    [super layoutSubviews];
//    CGRect frame = self.frame;  
//    CGFloat y = (frame.size.height - [self.subviews count]*(kDistanceBetweenButtons + buttonHeight) - kDistanceBetweenButtons)/2;
//    CGFloat y = kLeftMargin;
//    CGFloat x = kLeftMargin;
//    for (int i = 0; i < [self.subviews count]; i++) {
//        if ([[self.subviews objectAtIndex:i] isKindOfClass:[BBActionView class]]) {
//            BBActionView *button = [self.subviews objectAtIndex:i];
//            [button setFrame:CGRectMake(x, y, buttonWidth, buttonHeight)];
//            y +=kDistanceBetweenButtons + buttonHeight;
//        }
//
//    }
    if (self.tag == ACTION_BOX_TYPE_STATISTICS) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[BBActionView class]]) {
                BBActionView *button = (BBActionView*)view;
                NSString *imageName = nil;
                NSString *imageNameHover = nil;
                NSString *imageNameFlashing = nil;
                switch (view.tag) {
                    case ACTION_TYPE_ONEMADE:
                        imageName = @"onemade1.png";
                        imageNameHover = @"onemade2.png";
                        imageNameFlashing = @"onemade_flashing.png";
                        break;
                    case ACTION_TYPE_ONEMISS:
                        imageName = @"onemiss1.png";
                        imageNameHover = @"onemiss2.png";
                        imageNameFlashing = @"onemiss_flashing.png";
                        break;
                    case ACTION_TYPE_TWOMADE:
                        imageName = @"twomade1.png";
                        imageNameHover = @"twomade2.png";
                        imageNameFlashing = @"flashing1.png";
                        break;
                        
                    case ACTION_TYPE_TWOMISS:
                        imageName = @"twomiss1.png";
                        imageNameHover = @"twomiss2.png";
                        imageNameFlashing = @"flashing1.png";
                        break;
                        
                    case ACTION_TYPE_THREEMADE:
                        imageName = @"threemade1.png";
                        imageNameHover = @"threemade2.png";
                        imageNameFlashing = @"flashing1.png";
                        break;
                    case ACTION_TYPE_THREEMISS:
                        imageName = @"threemiss1.png";
                        imageNameHover = @"threemiss2.png";
                        imageNameFlashing = @"flashing1.png";
                        break;
                    case ACTION_TYPE_FOUL:
                        imageName = @"foul1.png";
                        imageNameHover = @"foul2.png";
                        imageNameFlashing = @"flashing1.png";
                        break;
                    case ACTION_TYPE_TECHFOUL:
                        imageName = @"techfoul1.png";
                        imageNameHover = @"techfoul2.png";
                        imageNameFlashing = @"flashing1.png";
                        break;
                    case ACTION_TYPE_ASSIST:
                        imageName = @"assist1.png";
                        imageNameHover = @"assist2.png";
                        imageNameFlashing = @"flashing1.png";
                        break;
                    case ACTION_TYPE_REBOUND:
                        imageName = @"rebound1.png";
                        imageNameHover = @"rebound2.png";
                        imageNameFlashing = @"flashing2.png";;
                        break;
                    case ACTION_TYPE_STEAL:
                        imageName = @"steal1.png";
                        imageNameHover = @"steal2.png";
                        imageNameFlashing = @"flashing1.png";
                        break;
                        
                    case ACTION_TYPE_TURNOVER:
                        imageName = @"turnover1.png";
                        imageNameHover = @"turnover2.png";
                        imageNameFlashing = @"flashing1.png";
                        break;
                    case ACTION_TYPE_FOUL1:
                        imageName = @"foul11.png";
                        imageNameHover = @"foul12.png";
                        imageNameFlashing = @"flashing1.png";
                        break;
                    case ACTION_TYPE_FOUL2:
                        imageName = @"foul21.png";
                        imageNameHover = @"foul22.png";
                        imageNameFlashing = @"flashing1.png";
                        break;
                    case ACTION_TYPE_FOUL3:
                        imageName = @"foul31.png";
                        imageNameHover = @"foul32.png";
                        imageNameFlashing = @"flashing1.png";
                        break;
                    default:
                        break;
                }
                [button setBackgroundColor:[UIColor clearColor]];
                [button setImage:[UIImage imageNamed:imageName]
                        forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:imageNameHover]
                        forState:UIControlStateSelected];
                [button setImage:[UIImage imageNamed:imageNameFlashing]
                        forState:UIControlStateFlashing];
                //                [button setAdjustsImageWhenHighlighted:YES];
                [button addTarget:self
                           action:@selector(buttonDidTap:)
                 forControlEvents:UIControlEventTouchUpInside];
//                [button setActionType:button.tag];
                //            switch (button.actionType) {
                //                case :
                //                    
                //                    break;
                //                    
                //                default:
                //                    break;
                //            }
                [button setDelegate:(id)self];
            }
            
        }
        
    }
    else if (self.tag == ACTION_BOX_TYPE_SCORING){
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[BBActionView class]]) {
                BBActionView *button = (BBActionView*)view;
                NSString *imageName = nil;
                NSString *imageNameHover = nil;
                NSString *imageNameFlashing = nil;
                switch (view.tag) {
                    case ACTION_TYPE_TWOMADE:
                        imageName = @"twomade1_scoring.png";
                        imageNameHover = @"twomade2_scoring.png";
                        imageNameFlashing = @"flashing3.png";
                        break;
                        
                    case ACTION_TYPE_TWOMISS:
                        imageName = @"twomiss1_scoring.png";
                        imageNameHover = @"twomiss2_scoring.png";
                        imageNameFlashing = @"twomiss_scoring_flashing.png";
                        break;
                        
                    case ACTION_TYPE_THREEMADE:
                        imageName = @"threemade1_scoring.png";
                        imageNameHover = @"threemade2_scoring.png";
                        imageNameFlashing = @"flashing4.png";
                        break;
                    case ACTION_TYPE_THREEMISS:
                        imageName = @"threemiss1_scoring.png";
                        imageNameHover = @"threemiss2_scoring.png";
                        imageNameFlashing = @"flashing4.png";
                        break;
                    case ACTION_TYPE_FOUL:
                        imageName = @"foul1_scoring.png";
                        imageNameHover = @"foul2_scoring.png";
                        imageNameFlashing = @"flashing4.png";
                        break;
                    case ACTION_TYPE_TECHFOUL:
                        imageName = @"techfoul1_scoring.png";
                        imageNameHover = @"techfoul2_scoring.png";
                        imageNameFlashing = @"flashing4.png";
                        break;
                    case ACTION_TYPE_ASSIST:
                        imageName = @"assist1_scoring.png";
                        imageNameHover = @"assist2_scoring.png";
                        imageNameFlashing = @"flashing4.png";
                        break;
                    case ACTION_TYPE_REBOUND:
                        imageName = @"rebound1_scoring.png";
                        imageNameHover = @"rebound2_scoring.png";
                        imageNameFlashing = @"rebound_scoring_flashing.png";
                        break;
                    case ACTION_TYPE_STEAL:
                        imageName = @"steal1_scoring.png";
                        imageNameHover = @"steal2_scoring.png";
                        imageNameFlashing = @"steal_scoring_flashing.png";
                        break;
                        
                    case ACTION_TYPE_TURNOVER:
                        imageName = @"turnover1_scoring.png";
                        imageNameHover = @"turnover2_scoring.png";
                        imageNameFlashing = @"turnover_scoring_flashing.png";
                        break;
                    case ACTION_TYPE_FOUL1:
                        imageName = @"foul11_scoring.png";
                        imageNameHover = @"foul12_scoring.png";
                        imageNameFlashing = @"flashing4.png";
                        break;
                    case ACTION_TYPE_FOUL2:
                        imageName = @"foul21_scoring.png";
                        imageNameHover = @"foul22_scoring.png";
                        imageNameFlashing = @"flashing4.png";
                        break;
                    case ACTION_TYPE_FOUL3:
                        imageName = @"foul31_scoring.png";
                        imageNameHover = @"foul32_scoring.png";
                        imageNameFlashing = @"flashing4.png";
                        break;
                    default:
                        break;
                }                 
                [button setBackgroundColor:[UIColor clearColor]];
                [button setImage:[UIImage imageNamed:imageName]
                        forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:imageNameHover]
                        forState:UIControlStateSelected];
                [button setImage:[UIImage imageNamed:imageNameFlashing]
                                            forState:UIControlStateFlashing];
                //                [button setAdjustsImageWhenHighlighted:YES];
                [button addTarget:self
                           action:@selector(buttonDidTap:)
                 forControlEvents:UIControlEventTouchUpInside];
//                [button setActionType:button.tag];
                //            switch (button.actionType) {
                //                case :
                //                    
                //                    break;
                //                    
                //                default:
                //                    break;
                //            }
                //                [button setDelegate:self];
            }
            
        }
        
    } else if (self.tag == ACTION_BOX_TYPE_FREESHOT){
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[BBActionView class]]) {
                BBActionView *button = (BBActionView*)view;
                NSString *imageName = nil;
                NSString *imageNameHover = nil;
                NSString *imageNameFlashing = nil;
                switch (view.tag) {
                    case ACTION_TYPE_ONEMADE:
                        imageName = @"onemade1.png";
                        imageNameHover = @"onemade2.png";
                        imageNameFlashing = @"onemade_flashing.png";
                        break;
                    case ACTION_TYPE_ONEMISS:
                        imageName = @"onemiss1.png";
                        imageNameHover = @"onemiss2.png";
                        imageNameFlashing = @"onemiss_flashing.png";
                        break;
                        
                        
                    default:
                        break;
                }
                [button setBackgroundColor:[UIColor clearColor]];
                [button setImage:[UIImage imageNamed:imageName]
                        forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:imageNameHover]
                        forState:UIControlStateSelected];
                [button setImage:[UIImage imageNamed:imageNameFlashing]
                        forState:UIControlStateFlashing];
                //                [button setAdjustsImageWhenHighlighted:YES];
                [button addTarget:self
                           action:@selector(buttonDidTap:)
                 forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }


}

- (void) setButtonWidth:(CGFloat)width{
    buttonWidth = width;
    [self layoutSubviews];
}

- (void) setButtonHeight:(CGFloat)height{
    buttonHeight = height;
    [self layoutSubviews];
}

- (void) setFlashing:(BOOL)flashing forType:(ACTION_TYPE)actionType{
    [self setUserInteractionEnabled:YES];
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[BBActionView class]]) {
            if (subView.tag != actionType) {
                if ([(BBActionView*)subView isFlashing]) {
                    [(BBActionView*)subView toggleFlashing:NO];
                }
            } else {
                if (![(BBActionView*)subView isFlashing]) {
                    [(BBActionView*)subView toggleFlashing:YES];
                }

            }
        }
    }
}

- (void) setFlashing:(BOOL)flashing forTypes:(NSArray*)actionTypes{
    [self setUserInteractionEnabled:YES];
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[BBActionView class]]) {
            if (![actionTypes containsObject:[NSNumber numberWithInt:subView.tag]]) {
                if ([(BBActionView*)subView isFlashing]) {
                    [(BBActionView*)subView toggleFlashing:NO];
                }
            } else {
                if (![(BBActionView*)subView isFlashing]) {
                    [(BBActionView*)subView toggleFlashing:flashing];
                }
                
            }
        }
    }
}
- (void) setEnable:(BOOL)enable forTypes:(NSArray*)actionTypes{
    [self setUserInteractionEnabled:YES];
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[BBActionView class]]) {
            if (![actionTypes containsObject:[NSNumber numberWithInt:subView.tag]]) {
//                [(BBActionView*)subView setUserInteractionEnabled:NO];
            } else {
                [(BBActionView*)subView setUserInteractionEnabled:enable];
            }
        }
    }
}

- (void) setFlashing:(BOOL)flashing{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[BBActionView class]]) {
            [(BBActionView*)view toggleFlashing:flashing];
        }
    }

}
- (void) setEnable:(BOOL)enable{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[BBActionView class]]) {
            [(BBActionView*)view setUserInteractionEnabled:enable];
        }
    }
//    [self setUserInteractionEnabled:enable];
//    if (!enable) {
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                     action@selector(displayAlert:)];
//        [tapGesture setDelegate:self];
//        [self addGestureRecognizer:tapGesture];
//        [tapGesture release];
//    } else {
//        [self setGestureRecognizers:nil];
//    }
}

- (void) selectActionType:(ACTION_TYPE)actionType{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[BBActionView class]]) {
            if (subView.tag != actionType) {
                [(BBActionView*)subView setSelected:NO];
            } else {
                [(BBActionView*)subView setSelected:YES];
            }

        }
    }
}
- (void) deselectAll{
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:[BBActionView class]]) {
            if ([(BBActionView*)subView isSelected]) {
                [(BBActionView*)subView setSelected:NO];
            }

        }
    }
}

- (BBActionView*) selectedButton{
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:[BBActionView class]]) {
            if ([(BBActionView*)subView isSelected]) {
                return (BBActionView*)subView;
            }
        }
    }
    return nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) displayAlert:(UITapGestureRecognizer*)tapGesture{
    [CommonUtils displayAlertWithTitle:nil
                               message:kMessageNotTurnOnClockYet
                           cancelTitle:LOCALIZE(kButtonTitleOk)
                                   tag:0
                              delegate:self
                     otherButtonTitles:nil];
}
- (void)buttonDidTap:(id)sender{
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:[BBActionView class]]) {
            [(BBActionView*)subView setSelected:NO];
        }
    }
//    [self setEnable:NO];
    [(BBActionView*)[(UIButton*)sender superview] setSelected:YES];
    if (self.delegate) {
        [self.delegate toggleButtonView:self actionViewDidTapped:(BBActionView*)[(UIButton*)sender superview]];
    }

}

- (void) setActionWithType:(ACTION_TYPE)actionType{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[BBActionView class]]) {
            if (subView.tag != actionType) {
                [(BBActionView*)subView setSelected:NO];
            } else {
                [(BBActionView*)subView setSelected:YES];
            }

        }
    }
    
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.view == self) {
        return YES;
    }
    return NO;
}


- (void)dealloc{
    [super dealloc];
    [self setDelegate:nil];
}
@end
