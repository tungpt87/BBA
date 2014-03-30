
//
//  BBPlayerView.m
//  BasketBall

//
//  Created by Tung Pham Thanh on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBPlayerView.h"
#import <QuartzCore/QuartzCore.h>
@implementation BBPlayerView
@synthesize isOnPlayingTime;
@synthesize isOnAction = _isOnAction;
@synthesize delegate = _delegate;
@synthesize isInTheCourt;
@synthesize firstPeriod;
@synthesize isFlashing;
@synthesize numberOfHalves;
@synthesize isSubbedOn = _isSubbedOn;
@synthesize index;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void) dismissPickerView{
    [tfHidden resignFirstResponder];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    /////
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dangerLimitDidChange:)
                                                 name:kNotificationDidChangeDangerLimit
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissPickerView)
                                                 name:kNotificationClockDidStart
                                               object:nil];
    ////
    NSLog(@"Awake from nib");
    scores = 0;
    fouls = 0;
    techFouls = 0;
    _timeOn = 0;
    isInTheCourt = NO;
    firstPeriod = 0;
    isFlashing = NO;
    couldStartFlashing = YES;
    _isSubbedOn = NO;
    [self setBackgroundColor:[UIColor clearColor]];
    tfHidden = [[UITextField alloc] initWithFrame:CGRectZero];
    [tfHidden setHidden:YES];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 200)];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    [tfHidden setInputView:pickerView];
    [pickerView release];
    UINavigationBar *tfToolBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 44)];
    [tfToolBar setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:tfHidden
                                                                               action:@selector(resignFirstResponder)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:BARTITLE_SETFOULDANGERLIMIT];
    navItem.rightBarButtonItem = barButton;
    [tfToolBar pushNavigationItem:navItem animated:YES];
    [navItem release];
    [barButton release];
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT)];
    [blackView setBackgroundColor:[UIColor clearColor]];
    CGRect frame = tfToolBar.frame;
    frame.origin.x = 0;
    frame.origin.y = SCREEN_SIZE_HEIGHT - frame.size.height;
    [tfToolBar setFrame:frame];
    [blackView addSubview:tfToolBar];
    [tfHidden setInputAccessoryView:blackView];
    [tfToolBar release];
    [blackView release];
    [self addSubview:tfHidden];

    hiddenTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    beginTime = [[NSMutableArray alloc] init];
    endTime = [[NSMutableArray alloc] init];
    
    frame = self.frame;
    CGRect buttonFrame = [self.superview convertRect:frame toView:self];
    CGFloat y = (frame.size.height - kLabelFrameHeight) / 2+1;
    if (self.tag > 100) {
        lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(0,y , kLabelFrameHeight, kLabelFrameHeight-8)];
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(kLabelFrameHeight, y, frame.size.width - 3*kLabelFrameHeight-17, 34)];
        lblScore = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 52, y, 34, 34)];
        imgScore = [[UIImageView alloc] initWithFrame:lblScore.frame];
        [imgScore setImage:[UIImage imageNamed:@"playerscorebox.png"]];
        [lblScore setBackgroundColor:[UIColor clearColor]];
        [lblScore setTextAlignment:UITextAlignmentCenter];
        lblFoul = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 2*34-19, y+1, 34, 32)];
        imgFoul = [[UIImageView alloc] initWithFrame:lblFoul.frame];
        [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleft.png"]];
        [lblFoul setBackgroundColor:[UIColor clearColor]];
        [lblFoul setTextAlignment:UITextAlignmentCenter];
        imgDot = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-17, 0, 17, 49)];
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-17, self.frame.size.height)];
        subBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-17, self.frame.size.height)];
        buttonFrame.size.width -= 68;
    }
    else {
        lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(17,y , kLabelFrameHeight, kLabelFrameHeight-8)];
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(kLabelFrameHeight+17, y, frame.size.width - 3*kLabelFrameHeight-17, 34)];
        lblScore = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 35, y, 34, 34)];
        imgScore = [[UIImageView alloc] initWithFrame:lblScore.frame];
        [imgScore setImage:[UIImage imageNamed:@"playerscorebox.png"]];
        [lblScore setBackgroundColor:[UIColor clearColor]];
        [lblScore setTextAlignment:UITextAlignmentCenter];
        lblFoul = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 2*34-2, y+1, 34, 32)];
        imgFoul = [[UIImageView alloc] initWithFrame:lblFoul.frame];
        [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleft.png"]];
        [lblFoul setBackgroundColor:[UIColor clearColor]];
        [lblFoul setTextAlignment:UITextAlignmentCenter];
        imgDot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 49)];
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 0, self.frame.size.width-17, self.frame.size.height)];
        subBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 0, self.frame.size.width-17, self.frame.size.height)];
        buttonFrame.size.width -= 68;
    }
    [imgFoul.layer setCornerRadius:3];
    [imgFoul.layer setMasksToBounds:YES];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(foulLongPressed:)];
    [lblScore setTextColor:[UIColor whiteColor]];
    [lblFoul setUserInteractionEnabled:YES];
    [lblFoul addGestureRecognizer:longPress];
    F_RELEASE(longPress);
    [lblNumber setBackgroundColor:[UIColor clearColor]];
    [lblNumber setTextAlignment:UITextAlignmentCenter];
    [lblName setBackgroundColor:[UIColor clearColor]];
    [subBgImageView setAlpha:0];
    [self addSubview:bgImageView];
    [self addSubview:subBgImageView];
    [self addSubview:imgScore];
    [self addSubview:imgFoul];
    [self addSubview:lblNumber];
    [self addSubview:lblName];
    [self addSubview:lblScore];
    [self addSubview:lblFoul];
    [self addSubview:imgDot];
    
    
    button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button setBackgroundColor:[UIColor clearColor]];

    [button addTarget:self
               action:@selector(touchUpInside:) 
     forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self
               action:@selector(touchDown:) 
     forControlEvents:UIControlEventTouchDown];
    [button addTarget:self
               action:@selector(touchUpOutside:) 
     forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:button];

    [lblScore setText:[NSString stringWithFormat:@"%d",scores]];
    [lblFoul setText:[NSString stringWithFormat:@"%d",fouls]];
    player = [[BBPlayer alloc] init];
    
    _isOnAction = NO;
    
    
    //////////Init accessory view
//    frame = CGRectMake(0, 0, SCREEN_SIZE_WIDTH, kAccessoryView_Size_Height);
//    accessoryView = [[UIView alloc] initWithFrame:frame];
//    CGFloat height = accessoryView.frame.size.height - 10;
//    tfNumber = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, height, height)];
//    tfName = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_SIZE_WIDTH - kAccessoryView_Size_Height, 10, SCREEN_SIZE_WIDTH - kAccessoryView_Size_Height-20, kAccessoryView_Size_Height)];
//    [accessoryView addSubview:tfNumber];
//    [accessoryView addSubview:tfName];
//    [hiddenTextField setInputAccessoryView:accessoryView];
//    [self addSubview:hiddenTextField];
}

#pragma mark - Setter
- (void) setNumber:(NSInteger)number{
    if (number == -1) {
        [lblNumber setText:@""];
        [self setAlpha:0.5];
        return;
    } else if (number == 0){
        [lblNumber setText:@""];
    } else {
        [lblNumber setText:[NSString stringWithFormat:@"%d",number]];   
    }
    [self setAlpha:1];
}

- (void) setName:(NSString*)name{
    [lblName setText:name];
}

- (void) setScore:(NSInteger)score{
    [lblScore setText:[NSString stringWithFormat:@"%d",score]];
    scores = score;
}

- (void) setFoul:(NSInteger)foul{
    [lblFoul setText:[NSString stringWithFormat:@"%d",foul]];
    fouls = foul;
    NSInteger foulDanger = [DataManager foulDangerLimit];
    if (foul < foulDanger) {
        if (self.tag == 0) {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleft.png"]];            
        } else {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxright.png"]];            
        }
    }else {
        if (self.tag == 0) {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleftover.png"]];            
        } else {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxrightover.png"]];            
        }
    }
}
- (void) setTimeOn:(CGFloat)timeOn{
    _timeOn = timeOn;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
//    CGFloat y = (frame.size.height - kLabelFrameHeight) / 2;
//    if (self.tag == 1) {
//        lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - kLabelFrameHeight,y , kLabelFrameHeight, kLabelFrameHeight)];
//        lblName = [[UILabel alloc] initWithFrame:CGRectMake(2*kLabelFrameHeight, y, frame.size.width - 3*kLabelFrameHeight, kLabelFrameHeight)];
//        [lblName setTextAlignment:UITextAlignmentRight];
//        lblScore = [[UILabel alloc] initWithFrame:CGRectMake(kLabelFrameHeight, y, kLabelFrameHeight, kLabelFrameHeight)];
//        [lblScore setBackgroundColor:[UIColor greenColor]];
//        [lblScore setTextAlignment:UITextAlignmentCenter];
//        lblFoul = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kLabelFrameHeight, kLabelFrameHeight)];
//        [lblFoul setBackgroundColor:[UIColor redColor]];
//        [lblFoul setTextAlignment:UITextAlignmentCenter];    }
//    else {
//        lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(0,y , kLabelFrameHeight, kLabelFrameHeight)];
//        lblName = [[UILabel alloc] initWithFrame:CGRectMake(kLabelFrameHeight, y, frame.size.width - 3*kLabelFrameHeight, kLabelFrameHeight)];
//        lblScore = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 2*kLabelFrameHeight, y, kLabelFrameHeight, kLabelFrameHeight)];
//        [lblScore setBackgroundColor:[UIColor greenColor]];
//        [lblScore setTextAlignment:UITextAlignmentCenter];
//        lblFoul = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - kLabelFrameHeight, y, kLabelFrameHeight, kLabelFrameHeight)];
//        [lblFoul setBackgroundColor:[UIColor redColor]];
//        [lblFoul setTextAlignment:UITextAlignmentCenter];
//    }
//    
//    [lblNumber setBackgroundColor:[UIColor clearColor]];
//    [lblName setBackgroundColor:[UIColor clearColor]];
//    [self addSubview:lblNumber];
//    [self addSubview:lblName];
//    [self addSubview:lblScore];
//    [self addSubview:lblFoul];
//    button = [[UIButton alloc] initWithFrame:[self.superview convertRect:frame toView:self]];
//    [button setBackgroundColor:[UIColor clearColor]];
//    [button addTarget:self
//               action:@selector(touchUpInside:) 
//     forControlEvents:UIControlEventTouchUpInside];
//    [button addTarget:self
//               action:@selector(touchDown:) 
//     forControlEvents:UIControlEventTouchDown];
//    [button addTarget:self
//               action:@selector(touchUpOutside:) 
//     forControlEvents:UIControlEventTouchUpOutside];
//    [self addSubview:button];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Getter
- (NSString*) number{
    return lblNumber.text;
}

- (NSString*) name{
    return lblName.text;
}
- (void) touchDown:(id)sender{
    if (longPressTimer) {
        [longPressTimer invalidate];
        longPressTimer = nil;
    }
    if (!isOnPlayingTime) {
        longPressTimer = [NSTimer scheduledTimerWithTimeInterval:kLongPressInterval
                                                          target:self
                                                        selector:@selector(longPress)
                                                        userInfo:nil
                                                         repeats:NO];
    };
}
- (void) touchUpInside:(id)sender{
    if (longPressTimer && !isOnPlayingTime) {
        [longPressTimer invalidate];
        longPressTimer = nil;
        /////When longPressTimer still not equal to nil, it means longPress event does not fire
        [self toggleButtonTapped:sender];
    } else if (!longPressTimer && isOnPlayingTime){
        [self toggleButtonTapped:sender];
    }
}

- (void) touchUpOutside:(id)sender{
    if (longPressTimer) {
        [longPressTimer invalidate];
        longPressTimer = nil;
    }
}

- (void) longPress{
    if (longPressTimer) {
        [longPressTimer invalidate];
        longPressTimer = nil;
    }
    [self setIsSelected:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlayerViewDidLongPressed
                                                        object:self];
    ////Do whatever you want when button did longpressed

}

- (void) toggleButtonTapped:(id)sender{
    UIButton *btn = (UIButton*)sender;
    if (!isOnPlayingTime) {
        if (lblNumber.text.length > 0) {
            btn.selected = !btn.selected;
            [self setIsSelected:btn.selected];
            if (btn.selected) {
                [self.delegate playerViewDidSubbedOn:self];
            } else{
                [self.delegate playerViewDidSubbedOff:self];
            }
        }
    } else {
        for (UIView *subView in self.superview.subviews) {
            if ([subView isKindOfClass:[BBPlayerView class]] && subView != self && [(BBPlayerView*)subView isOnPlayingTime]) {
                [(BBPlayerView*)subView setIsOnAction:NO];
            }
        }
        [self toggleFlashing:NO];
        [self setIsOnAction:YES];
        if (self.delegate) {
            [self.delegate playerViewDidTapped:self];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlayerDidTap
                                                        object:self];

}
- (void)setIsOnAction:(BOOL)isOnAction{
    _isOnAction = isOnAction;
    if (_isOnAction) {
//        [self setBackgroundColor:[UIColor blueColor]];
        if (self.tag == 0) {
//            [bgImageView setImage:[UIImage imageNamed:@"b3l.png"]];
            [self changeBackgroundImage:[UIImage imageNamed:@"b3l.png"]];
        } else {
//            [bgImageView setImage:[UIImage imageNamed:@"b3r.png"]];
            [self changeBackgroundImage:[UIImage imageNamed:@"b3r.png"]];
        }
    } else {
        [self setIsSelected:self.isSelected];
    }
}
- (void) setEnable:(BOOL)enable{
    if (enable) {
        [self setAlpha:1];
    }else {
        [self setAlpha:0.3];
    }

    [button setEnabled:enable];
}

- (void) setIsOnPlayingTime:(BOOL)onPlayingTime{
    isOnPlayingTime = onPlayingTime;
}


- (void) addScore:(NSInteger) point{
    scores +=point;
    [self updateScore];
}
- (void) subtractScore:(NSInteger) point{
    scores -=point;
    [self updateScore];
}

- (void) addFoul{
    fouls +=1;
    NSInteger foulDanger = [DataManager foulDangerLimit];
    if (fouls < foulDanger && techFouls < kTechFoulDangerLimit) {
        if (self.tag == 0) {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleft.png"]];            
        } else {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxright.png"]];            
        }
    }else {
        if (self.tag == 0) {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleftover.png"]];            
        } else {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxrightover.png"]];            
        }
    }

    [self updateFoul];
}

- (void) subtractFoul{
    fouls -=1;
    NSInteger foulDanger = [DataManager foulDangerLimit];
    if (fouls < foulDanger && techFouls < kTechFoulDangerLimit) {
        if (self.tag == 0) {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleft.png"]];            
        } else {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxright.png"]];            
        }
    }else {
        if (self.tag == 0) {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleftover.png"]];            
        } else {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxrightover.png"]];            
        }
    }
    
    [self updateFoul];

}
- (void) addTechFoul{
    techFouls +=1;
    if (fouls < [DataManager foulDangerLimit] && techFouls < kTechFoulDangerLimit) {
        if (self.tag == 0) {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleft.png"]];            
        } else {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxright.png"]];            
        }
    }else {
        if (self.tag == 0) {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleftover.png"]];            
        } else {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxrightover.png"]];            
        }
    }
    
}
- (void) subtractTechFoul{
    techFouls -=1;
    if (fouls < kTechFoulDangerLimit) {
        if (self.tag == 0) {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleft.png"]];            
        } else {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxright.png"]];            
        }
    }else {
        if (self.tag == 0) {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleftover.png"]];            
        } else {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxrightover.png"]];            
        }
    }

}
- (void) setBeginTime:(NSArray*)arrBeginTime{
    F_RELEASE(beginTime);
    beginTime = [[NSMutableArray alloc] initWithArray:arrBeginTime];
}

- (void) setEndTime:(NSArray*)arrEndTime{
    F_RELEASE(endTime);
    endTime = [[NSMutableArray alloc] initWithArray:arrEndTime];
}
#pragma mark - Properties
- (NSDictionary*) dictionary{
    NSMutableArray *arrBeginTime = (beginTime)?beginTime:[NSMutableArray array];
    NSMutableArray *arrEndTime = (endTime)?endTime:[NSMutableArray array];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self number],[self name], [NSNumber numberWithBool:[self isInTheCourt]],[NSNumber numberWithFloat:[self timeOn]],[NSNumber numberWithInt:numberOfHalves],[NSNumber numberWithInt:self.index],[NSNumber numberWithBool:[self isSelected]],[NSNumber numberWithInt:scores],[NSNumber numberWithInt:fouls],[NSNumber numberWithFloat:_timeOn],arrBeginTime,arrEndTime, [NSNumber numberWithBool:_isSubbedOn],[NSNumber numberWithInt:firstPeriod], nil]
                                                     forKeys:[NSArray arrayWithObjects:kKey_PlayerNumber,kKey_PlayerName,kKey_Player_IsInTheCourt,kKey_Player_TimeOn, kKey_Player_NumberOfHalves,kKey_Player_Index,kKey_Player_Selected,kKey_Player_Score, kKey_Player_Foul,kKey_Player_TimeOn,kKey_Player_BeginTime, kKey_Player_EndTime, kKey_player_IsSubbedOn,kKey_Player_FirstPeriod,nil]];

    return dict;
    
}
- (BOOL) isSelected{
    return button.selected;
}
- (CGFloat) timeOn{
    return _timeOn;
}
- (NSArray*) beginTimes{
    return beginTime;
}

- (NSArray*) endTimes{
    return endTime;
}
- (void) addBeginTime:(CGFloat)aBeginTime{
    if (!beginTime) {
        beginTime = [[NSMutableArray alloc] init];
    }
    if (!endTime) {
        endTime = [[NSMutableArray alloc] init];
    }
    for (int i = endTime.count - 1; i >= 0; --i) {
        if ([[endTime objectAtIndex:i] floatValue] <= aBeginTime) {
            [endTime removeObjectAtIndex:i];
        }
    }
    
    for (int i = beginTime.count - 1; i >= 0; --i) {
        if ([[beginTime objectAtIndex:i] floatValue] <= aBeginTime) {
            [beginTime removeObjectAtIndex:i];
        }
    }
    if (beginTime.count == endTime.count) {
        [beginTime addObject:[NSNumber numberWithFloat:aBeginTime]];   
    }

    NSLog(@"Add begin time");
}

- (void) addEndTime:(CGFloat)anEndTime{
    if (!beginTime) {
        beginTime = [[NSMutableArray alloc] init];
    }
    if (!endTime) {
        endTime = [[NSMutableArray alloc] init];
    }
//    NSNumber *lastEnd = [endTime lastObject];
    for (int i = endTime.count - 1; i >= 0; --i) {
        if ([[endTime objectAtIndex:i] floatValue] <= anEndTime) {
            [endTime removeObjectAtIndex:i];
        }
    }
    
    for (int i = beginTime.count - 1; i >= 0; --i) {
        if ([[beginTime objectAtIndex:i] floatValue] <= anEndTime) {
            [beginTime removeObjectAtIndex:i];
        }
    }
    if (endTime.count == beginTime.count - 1) {
        [endTime addObject:[NSNumber numberWithFloat:anEndTime]];
    }
    NSLog(@"Add end time");
}

- (void) endOfPeriod{
    if (beginTime && endTime) {
        for (int i = 0; i < beginTime.count; ++i) {
            _timeOn += [[beginTime objectAtIndex:i] floatValue] - [[endTime objectAtIndex:i] floatValue];
        }
        F_RELEASE(beginTime);
        F_RELEASE(endTime);
    }
    
}
- (void) setIsSelected:(BOOL)selected{
    button.selected = selected;
    if (button.selected) {
//        [self setBackgroundColor:[UIColor lightGrayColor]];
        if (self.tag == 0) {
//            [bgImageView setImage:[UIImage imageNamed:@"b2l.png"]];
            [self changeBackgroundImage:[UIImage imageNamed:@"b2l.png"]];
        }else {
//            [bgImageView setImage:[UIImage imageNamed:@"b2r.png"]];
            [self changeBackgroundImage:[UIImage imageNamed:@"b2r.png"]];
        }
        
    }
    else {
//        [self setBackgroundColor:[UIColor clearColor]];
        if (self.tag == 0) {
//            [bgImageView setImage:[UIImage imageNamed:@"b1l.png"]];
            [self changeBackgroundImage:[UIImage imageNamed:@"b1l.png"]];
        }else {
//            [bgImageView setImage:[UIImage imageNamed:@"b1r.png"]];
            [self changeBackgroundImage:[UIImage imageNamed:@"b1r.png"]];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlayerDidSelected
                                                        object:nil];
}

- (void) updateScore{
    [lblScore setText:[NSString stringWithFormat:@"%d",scores]];
}

- (void) updateFoul{
    [lblFoul setText:[NSString stringWithFormat:@"%d",fouls]];
}

- (void) reset{
    firstPeriod = 0;
    F_RELEASE(beginTime);
    beginTime = [[NSMutableArray alloc] init];
    F_RELEASE(endTime);
    endTime = [[NSMutableArray alloc] init];
    [self setIsSelected:NO];
    [self setFoul:0];
    [self setScore:0];
    [self setIsOnAction:NO];
    [self setIsOnPlayingTime:NO];
    NSInteger i = [self.superview.subviews indexOfObject:self];
    [self setNumber:i+1];
    [self setDot:0];
    [self setIsInTheCourt:NO];
}

- (void) setDot:(NSInteger)numberOfDot{
    if (numberOfDot == 0) {
        [imgDot setImage:nil];
    } else if (numberOfDot == 1) {
        [imgDot setImage:[UIImage imageNamed:@"onedot.png"]];
    } else {
        [imgDot setImage:[UIImage imageNamed:@"twodot.png"]];
    }
}
- (void) takeToTheCourtInPeriod:(NSInteger)period{
    if (firstPeriod == 0) {
        firstPeriod = period;
    }
    
    if (firstPeriod == period) {
        numberOfHalves = 1;
        if (period < 3) {
            [imgDot setImage:[UIImage imageNamed:@"higherdot.png"]];
        } else {
            [imgDot setImage:[UIImage imageNamed:@"lowerdot.png"]];
        }
    } else {
        if (firstPeriod < 3 && period >= 3) {
            numberOfHalves = 2;
            [imgDot setImage:[UIImage imageNamed:@"twodot.png"]];
        }
    }
}
- (BOOL) isHiddenPlayer{
    return (self.hidden || lblNumber.text.length == 0);
}
- (void) changeBackgroundImage:(UIImage*)image{
//    [subBgImageView setImage:image];
//    [UIView animateWithDuration:0.2
//                     animations:^{
//                         [subBgImageView setAlpha:1];
//                     } completion:^(BOOL finished) {
//                         [bgImageView setImage:image];
//                         [subBgImageView setImage:nil];
//                         [subBgImageView setAlpha:0];
//                     }];
    [bgImageView setImage:image];
}

- (void) foulLongPressed:(UILongPressGestureRecognizer*)longPress{

}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex > -1) {
        [DataManager setFoulDangerLimit:buttonIndex+1];
    }
}


- (void)dealloc{
    [super dealloc];
    [self setDelegate:nil];
    F_RELEASE(bgImageView);
    F_RELEASE(subBgImageView);
    F_RELEASE(imgScore);
    F_RELEASE(imgFoul);
    F_RELEASE(lblNumber);
    F_RELEASE(lblName);
    F_RELEASE(lblScore);
    F_RELEASE(lblFoul);
    F_RELEASE(imgDot);
}

- (void) toggleFlashing:(BOOL)flashing{
    isFlashing = flashing;
    [subBgImageView setAlpha:0];
    if (flashingTimer) {
        [flashingTimer invalidate];
        flashingTimer = nil;
    }
    
    if (isFlashing) {
        //            NSLog(@"Start flashing");
        [self setIsOnAction:NO];
        [self flashingIn];
        flashingTimer = [NSTimer scheduledTimerWithTimeInterval:2*kFlashingDuration
                                                         target:self
                                                       selector:@selector(flashingIn)
                                                       userInfo:nil
                                                        repeats:YES];
        
    }        

}

- (void) flashingIn{
    if (isFlashing) {
//        NSLog(@"Flashing In");
        UIImage *image;
        if (self.tag == 0) {
            
            image = [UIImage imageNamed:@"b3l.png"];
        } else {
            
            image = [UIImage imageNamed:@"b3r.png"];
        }
        
        [subBgImageView setImage:image];
        [UIView animateWithDuration:kFlashingDuration
                         animations:^{
                             [subBgImageView setAlpha:1];
                         } completion:^(BOOL finished) {
                             [self flashingOut];
                         }];
    }

}

- (void) flashingOut{
    
//    NSLog(@"Flashing Out");
    UIImage *image;
    if (self.tag == 0) {
        
        image = [UIImage imageNamed:@"b3l.png"];
    } else {
        
        image = [UIImage imageNamed:@"b3r.png"];
    }
    
    [subBgImageView setImage:image];
    [UIView animateWithDuration:kFlashingDuration
                     animations:^{
                         [subBgImageView setAlpha:0];
                     } completion:^(BOOL finished) {

                     }];

}
     
- (void)setIsSubbedOn:(BOOL)isSubbedOn{
    if (isSubbedOn != _isSubbedOn) {
        NSInteger i = self.tag % 100;
        NSInteger teamIndex = self.superview.tag;
        NSDictionary *dictPlayerSub = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:teamIndex],[NSNumber numberWithInt:i], [NSNumber numberWithBool:isSubbedOn], nil]
                                                                  forKeys:[NSArray arrayWithObjects:kKey_PlayerSubbing_TeamIndex, kKey_PlayerSubbing_Index,kKey_PlayerSubbing_On, nil]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlayerSubbed
                                                            object:dictPlayerSub];
    }
    _isSubbedOn = isSubbedOn;
}

- (void)setIsSubbedOnWithoutNotify:(BOOL)isSubbedOn{
    _isSubbedOn = isSubbedOn;
}
- (BOOL) isReachedTheLimit{
    return fouls >= [DataManager foulDangerLimit] || techFouls >= kTechFoulDangerLimit;
}
#pragma mark - Handling observer
- (void)dangerLimitDidChange:(NSNotification*)notification{
    NSInteger newDangerLimit = [(NSNumber*)[notification object] intValue];
    if (newDangerLimit <= fouls) {
        if (self.tag == 0) {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleftover.png"]];
        } else {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxrightover.png"]];
        }
    } else{
        if (self.tag == 0) {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxleft.png"]];
        } else {
            [imgFoul setImage:[UIImage imageNamed:@"playerfoulboxright.png"]];
        }
    }
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d",row+1];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [DataManager setFoulDangerLimit:row+1];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 300;
}

@end
