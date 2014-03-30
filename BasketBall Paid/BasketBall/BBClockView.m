//
//  BBClockView.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBClockView.h"
static BBClockView *currentClockView;
@implementation BBClockView
@synthesize remainTime = _remainTime;
@synthesize delegate;
@synthesize isAllMode;
@synthesize isContMode;
@synthesize isFlashing;
#pragma mark - View life cycle
+ (BBClockView*) currentClockView{
    return currentClockView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect newFrame = frame;
        newFrame.size.height -= kButtonSizeHeight + 5;
        newFrame.origin.x = 0;
        newFrame.origin.y = 0;
        imageView = [[UIImageView alloc] initWithFrame:newFrame];
        [imageView setImage:[UIImage imageNamed:@"donghodo.png"]];
        [self setBackgroundColor:[UIColor clearColor]];
        timeLabel = [[UILabel alloc] initWithFrame:newFrame];
        timeLabel = [[UILabel alloc] initWithFrame:newFrame];
        [timeLabel setTextAlignment:UITextAlignmentCenter];
        UIFont *largeFont = [UIFont systemFontOfSize:kTimeLabelLargeFontSize];
        [timeLabel setFont:largeFont];
        UIFont *smallFont = [UIFont systemFontOfSize:kTimeLabelSmallFontSize];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        
        secondTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/2+kTimeLabelLargeFontSize, newFrame.size.height)];
        [secondTimeLabel setTextAlignment:UITextAlignmentRight];
        miliSecTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondTimeLabel.frame.size.width, 0, frame.size.width - secondTimeLabel.frame.size.width, newFrame.size.height)];
        [miliSecTimeLabel setTextAlignment:UITextAlignmentLeft];
        [miliSecTimeLabel setFont:smallFont];
        [secondTimeLabel setBackgroundColor:[UIColor clearColor]];
        [miliSecTimeLabel setBackgroundColor:[UIColor clearColor]];
        
        
        toggleButton = [[UIButton alloc] initWithFrame:newFrame];
        [toggleButton addTarget:self 
                         action:@selector(toggleButtonDidTap:) 
               forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageView];
        [self addSubview:timeLabel];
        [self addSubview:secondTimeLabel];
        [self addSubview:miliSecTimeLabel];
        [self addSubview:toggleButton];
        stopUpdateTime = YES;
        stopCountDownTimer = YES;
        btnUp = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height - kButtonSizeHeight, kButtonSizeWidth, kButtonSizeHeight)];
        [btnUp setTitle:@"Up" forState:UIControlStateNormal];
        btnDown = [[UIButton alloc] initWithFrame:CGRectMake(kButtonSizeWidth, frame.size.height - kButtonSizeHeight, kButtonSizeWidth, kButtonSizeHeight)];
        [btnDown setTitle:@"Down" forState:UIControlStateNormal];
        btnAll = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 2*kButtonSizeWidth, frame.size.height - kButtonSizeHeight, kButtonSizeWidth, kButtonSizeHeight)];
        [btnAll setTitle:@"All" forState:UIControlStateNormal];
        btnCont = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - kButtonSizeWidth, frame.size.height - kButtonSizeHeight, kButtonSizeWidth, kButtonSizeHeight)];
        [btnCont setTitle:@"Cont" forState:UIControlStateNormal];
        
        [btnUp setImage:[UIImage imageNamed:@"up.png"]
               forState:UIControlStateNormal];
        
        [btnDown setImage:[UIImage imageNamed:@"down.png"]
                 forState:UIControlStateNormal];
        [self addSubview:btnUp];
        [self addSubview:btnDown];
        [self addSubview:btnAll];
        [self addSubview:btnCont];
        
        
        [btnUp addTarget:self action:@selector(btnUpDidTouchDown) forControlEvents:UIControlEventTouchDown];
        [btnUp addTarget:self action:@selector(btnUpDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [btnUp addTarget:self action:@selector(btnUpDidTouchUpOutSide) forControlEvents:UIControlEventTouchUpOutside];
        [btnDown addTarget:self action:@selector(btnDownDidTouchDown) forControlEvents:UIControlEventTouchDown];
        [btnDown addTarget:self action:@selector(btnDownDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [btnDown addTarget:self action:@selector(btnDownDidTouchUpOutSide) forControlEvents:UIControlEventTouchUpOutside];
        
        [btnAll addTarget:self action:@selector(btnAllDidTap) forControlEvents:UIControlEventTouchUpInside];
        [btnCont addTarget:self action:@selector(btnContDidTap) forControlEvents:UIControlEventTouchUpInside];
        currentClockView = self;
    }
    return self;
}
- (void)awakeFromNib{
    ///Flag initial
    flashingTimer = nil;
    stopUpdateTime = NO;
    stopCountDownTimer = YES;
    isStartOfPeriod = YES;
    isAllMode = NO;
    isContMode = NO;
    distance = 1;
    isFlashing = NO;
    _remainTime = 0;
    isAdjustingTime = NO;
    isStartOfAMatch = YES;
    currentClockView = self;
    [self setBackgroundColor:[UIColor clearColor]];
    CGRect frame = self.frame;
    CGRect newFrame = frame;
    newFrame.size.height -= kButtonSizeHeight;
    newFrame.origin.x = 0;
    newFrame.origin.y = 0;
    imageView = [[UIImageView alloc] initWithFrame:newFrame];
    flashingView = [[UIImageView alloc] initWithFrame:newFrame];
    [flashingView setImage:[UIImage imageNamed:@"clockflashing.png"]];
    [flashingView setAlpha:0];
    [imageView setImage:[UIImage imageNamed:@"donghodo.png"]];
    timeLabel = [[UILabel alloc] initWithFrame:newFrame];
    timeLabel = [[UILabel alloc] initWithFrame:newFrame];
    [timeLabel setTextAlignment:UITextAlignmentCenter];
    UIFont *largeFont = [UIFont systemFontOfSize:kTimeLabelLargeFontSize];
    [timeLabel setFont:largeFont];
    UIFont *smallFont = [UIFont systemFontOfSize:kTimeLabelSmallFontSize];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    secondTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/2+kTimeLabelLargeFontSize-15, newFrame.size.height)];
    miliSecTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondTimeLabel.frame.size.width, kTimeLabelSmallFontSize-15, frame.size.width - secondTimeLabel.frame.size.width, newFrame.size.height-kTimeLabelSmallFontSize+15)];
    [secondTimeLabel setFont:largeFont];
    [miliSecTimeLabel setFont:smallFont];
    [secondTimeLabel setTextAlignment:UITextAlignmentRight];
    [secondTimeLabel setBackgroundColor:[UIColor clearColor]];
    [miliSecTimeLabel setBackgroundColor:[UIColor clearColor]];
    
    
    toggleButton = [[UIButton alloc] initWithFrame:newFrame];
    [toggleButton addTarget:self 
                     action:@selector(toggleButtonDidTap:) 
           forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageView];
    [self addSubview:flashingView];
    [self addSubview:timeLabel];
    [self addSubview:secondTimeLabel];
    [self addSubview:miliSecTimeLabel];
    [self addSubview:toggleButton];

    btnUp = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height - kButtonSizeHeight, kButtonSizeWidth, kButtonSizeHeight)];
    btnDown = [[UIButton alloc] initWithFrame:CGRectMake(kButtonSizeWidth-10, frame.size.height - kButtonSizeHeight, kButtonSizeWidth, kButtonSizeHeight)];

    btnAll = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 2*kButtonSizeWidth+10, frame.size.height - kButtonSizeHeight, kButtonSizeWidth, kButtonSizeHeight)];
    btnCont = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - kButtonSizeWidth, frame.size.height - kButtonSizeHeight, kButtonSizeWidth, kButtonSizeHeight)];
    
    
    [btnUp setImage:[UIImage imageNamed:@"up.png"]
           forState:UIControlStateNormal];
    
    [btnUp setTitleColor:[UIColor blueColor]
                forState:UIControlStateNormal];
    [btnDown setImage:[UIImage imageNamed:@"down.png"]
             forState:UIControlStateNormal];
    [btnAll setImage:[UIImage imageNamed:@"all1.png"]
            forState:UIControlStateNormal];
    [btnAll setImage:[UIImage imageNamed:@"all2.png"]
            forState:UIControlStateSelected];
    [btnCont setImage:[UIImage imageNamed:@"cont1.png"]
             forState:UIControlStateNormal];
    [btnCont setImage:[UIImage imageNamed:@"cont2.png"]
             forState:UIControlStateSelected];
    
    [self addSubview:btnUp];
    [self addSubview:btnDown];
    [self addSubview:btnAll];
    [self addSubview:btnCont];
    
    
    [btnUp addTarget:self action:@selector(btnUpDidTouchDown) forControlEvents:UIControlEventTouchDown];
    [btnUp addTarget:self action:@selector(btnUpDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [btnUp addTarget:self action:@selector(btnUpDidTouchUpOutSide) forControlEvents:UIControlEventTouchUpOutside];
    [btnDown addTarget:self action:@selector(btnDownDidTouchDown) forControlEvents:UIControlEventTouchDown];
    [btnDown addTarget:self action:@selector(btnDownDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [btnDown addTarget:self action:@selector(btnDownDidTouchUpOutSide) forControlEvents:UIControlEventTouchUpOutside];
    
    [btnAll addTarget:self action:@selector(btnAllDidTap) forControlEvents:UIControlEventTouchUpInside];
    [btnCont addTarget:self action:@selector(btnContDidTap) forControlEvents:UIControlEventTouchUpInside];
    NSNumber *duration = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKey_Duration];
    if (duration) {
        _remainTime = [duration floatValue];
    } else {
        _remainTime = 0;
    }
    
    [self setTimeLabel:_remainTime];

    
}


- (void)dealloc{
    [super dealloc];
    [self setDelegate:nil];
    F_RELEASE(timeLabel);
    F_RELEASE(secondTimeLabel);
    F_RELEASE(miliSecTimeLabel);
    F_RELEASE(toggleButton);
    F_RELEASE(btnUp);
    F_RELEASE(btnDown);
    F_RELEASE(btnAll);
    F_RELEASE(btnCont);
}
#pragma mark - Private methods
- (void) setFlashing:(BOOL)flashing{
    if (flashingTimer) {
        [flashingTimer invalidate];
        flashingTimer = nil;
    }
    [flashingView setAlpha:0];

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
    if (isFlashing && _remainTime > 0) {
//        NSLog(@"Clock Flashing In");
        [UIView animateWithDuration:kFlashingDuration
                         animations:^{
                             [flashingView setAlpha:1];
                         } completion:^(BOOL finished) {
                             [self flashingOut];
                         }];

    }
}

- (void) flashingOut{
//    NSLog(@"Clock Flashing Out");
    [UIView animateWithDuration:kFlashingDuration
                     animations:^{
                         [flashingView setAlpha:0];
                     } completion:^(BOOL finished) {
                         
                     }];
}
- (void) toggleChangeModeEnabled:(BOOL)enabled{
    [btnAll setEnabled:enabled];
    [btnCont setEnabled:enabled];
}

- (void) setAdjustRemainingTimeEnable:(BOOL)enable{
    [btnUp setEnabled:enable];
    [btnDown setEnabled:enable];
}
- (void) updateRemainingTime{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:oldDate];
    [oldDate release];
    oldDate = [[NSDate alloc] init];

    [self countDownToRemainingTime:_remainTime - timeInterval];



}
- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    [toggleButton setUserInteractionEnabled:userInteractionEnabled];
    [btnAll setUserInteractionEnabled:userInteractionEnabled];
    [btnCont setUserInteractionEnabled:userInteractionEnabled];
}

- (void)disable{
    self.remainTime = kDisabledValue;
    [timeLabel setText:@"--:--"];
    [self setFlashing:NO];
    [self setUserInteractionEnabled:NO];
    stopCountDownTimer = NO;
}
- (void) toggleButtonDidTap:(id)sender{
    stopCountDownTimer = !stopCountDownTimer;
    [self setFlashing:stopCountDownTimer];
    F_RELEASE(oldDate);
    oldDate = [[NSDate alloc] init];
    [self setAdjustRemainingTimeEnable:stopCountDownTimer];
    if (!stopCountDownTimer) {
        stopUpdateTime = NO;
        if (_remainTime <= 0) {
            stopCountDownTimer = YES;
            [self setAdjustRemainingTimeEnable:stopCountDownTimer];
            return;
        }

        if (isStartOfAMatch) {
            isStartOfAMatch = NO;
            if (durationOfTheMatch == 0) {
                durationOfTheMatch = _remainTime;
            }
//            start = [[NSDate alloc] init];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:durationOfTheMatch]
                                                      forKey:kUserDefaultKey_Duration];
//            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
            if (_remainTime != remainingTimeBeforeStop) {
//                start = [[NSDate dateWithTimeInterval:_remainTime - remainingTimeBeforeStop
//                                           sinceDate:start] retain];
//                [self setRemainTime:remainingTimeBeforeStop];
            }
        }
        if (countDownTimer) {
            [countDownTimer invalidate];
            countDownTimer = nil;
        }
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                          target:self
                                                        selector:@selector(updateRemainingTime) 
                                                        userInfo:nil
                                                         repeats:YES];
        [imageView setImage:[UIImage imageNamed:@"donghoxanh.png"]];
        if (self.delegate) {
            [self.delegate clockViewDidStart:self];
            [self.delegate clockViewDidTapToStart:self];
        }
    }
    else {
        stopUpdateTime = NO;
        if (countDownTimer) {
            [countDownTimer invalidate];
            countDownTimer = nil;
        }
        remainingTimeBeforeStop = _remainTime;
        [imageView setImage:[UIImage imageNamed:@"donghodo.png"]];
        if (self.delegate) {
            [self.delegate clockViewDidStop:self];
        }
    }
    [self setUserInteractionEnabled:NO];
    [NSTimer scheduledTimerWithTimeInterval:kFlashingDuration
                                     target:self
                                   selector:@selector(enableUserInteraction)
                                   userInfo:nil
                                    repeats:NO];
}
- (void) enableUserInteraction{
    [self setUserInteractionEnabled:YES];
}
- (void) start{
    F_RELEASE(oldDate);
    oldDate = [[NSDate alloc] init];
    [self setFlashing:NO];
    if (_remainTime > 0) {
        if (countDownTimer) {
            [countDownTimer invalidate];
            countDownTimer = nil;
        }
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                          target:self
                                                        selector:@selector(updateRemainingTime) 
                                                        userInfo:nil
                                                         repeats:YES];
        [imageView setImage:[UIImage imageNamed:@"donghoxanh.png"]];
        stopUpdateTime = NO;
        stopCountDownTimer = NO;
        if (self.delegate) {
            [self.delegate clockViewDidStart:self];
        }
    } else {
        [self stop];
    }

}
- (void) stopCountDownTimer{
    if (countDownTimer) {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
    [btnUp setEnabled:YES];
    [btnDown setEnabled:YES];
    
    stopCountDownTimer = YES;
    remainingTimeBeforeStop = _remainTime;
    [imageView setImage:[UIImage imageNamed:@"donghodo.png"]];
    [self setFlashing:YES];
}
- (void) increaseRemainTime{
    distance += 0.1;
    NSInteger i = (NSInteger)round(distance);
    [self setRemainTime:_remainTime + i];
}

- (void) decreaseRemainTime{
    distance += 0.1;
    NSInteger i = (NSInteger)round(distance);
    [self setRemainTime:_remainTime - i];
}
- (void) startLoopTimer:(NSTimer*)timer{
    longPressTimer = nil;
    LOOPTIMER_TYPE loopType = [(NSNumber*)[timer userInfo] intValue];
    switch (loopType) {
        case LOOPTIMER_TYPE_UP:
            loopTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                         target:self
                                                       selector:@selector(increaseRemainTime) userInfo:nil
                                                        repeats:YES];
            break;
        case LOOPTIMER_TYPE_DOWN:
            loopTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                         target:self
                                                       selector:@selector(decreaseRemainTime) userInfo:nil
                                                        repeats:YES];
        default:
            break;
    }
}

- (void) btnUpDidTouchDown{
    isAdjustingTime = YES;
    longPressTimer = [NSTimer scheduledTimerWithTimeInterval:kLongPressInterval
                                                      target:self
                                                    selector:@selector(startLoopTimer:) userInfo:[NSNumber numberWithInt:LOOPTIMER_TYPE_UP]
                                                     repeats:NO];
}

- (void) btnUpDidTouchUpInside{
    if (longPressTimer) {
        [longPressTimer invalidate];
        longPressTimer = nil;
    }
    if (loopTimer) {
        [loopTimer invalidate];
        loopTimer = nil;
    } else{
        [self setRemainTime:_remainTime + 1];
    }
    distance = 1;
    isAdjustingTime = NO;
}


- (void) btnUpDidTouchUpOutSide{
    if (longPressTimer) {
        [longPressTimer invalidate];
        longPressTimer = nil;
    }
    if (loopTimer) {
        [loopTimer invalidate];
        loopTimer = nil;
    }
    distance = 1;
    isAdjustingTime = NO;
}


- (void) btnDownDidTouchDown{
    isAdjustingTime = YES;
    longPressTimer = [NSTimer scheduledTimerWithTimeInterval:kLongPressInterval
                                                      target:self
                                                    selector:@selector(startLoopTimer:) userInfo:[NSNumber numberWithInt:LOOPTIMER_TYPE_DOWN]
                                                     repeats:NO];
}

- (void) btnDownDidTouchUpInside{
    if (longPressTimer) {
        [longPressTimer invalidate];
        longPressTimer = nil;
    }
    if (loopTimer) {
        [loopTimer invalidate];
        loopTimer = nil;
    } else{
        [self setRemainTime:_remainTime - 1];
    }
    distance = 1;
    isAdjustingTime = NO;
}

- (void) btnDownDidTouchUpOutSide{
    if (longPressTimer) {
        [longPressTimer invalidate];
        longPressTimer = nil;
    }
    if (loopTimer) {
        [loopTimer invalidate];
        loopTimer = nil;
    }
    
    distance = 1;
    isAdjustingTime = NO;
}


- (void) btnAllDidTap{
    btnAll.selected = !btnAll.selected;
    btnCont.selected = NO;
    isAllMode = btnAll.selected;
    isContMode = btnCont.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationClockViewDidChangeContMode
                                                        object:[NSNumber numberWithBool:isContMode]];
}

- (void) btnContDidTap{
    btnCont.selected = !btnCont.selected;
    btnAll.selected = NO;
    isAllMode = btnAll.selected;
    isContMode = btnCont.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationClockViewDidChangeContMode
                                                        object:[NSNumber numberWithBool:isContMode]];
}

#pragma mark - Public Methods
- (CGFloat) getCurrentTimeOfTheMatch{
    return durationOfTheMatch - _remainTime;
}


- (void) setTimeLabel:(CGFloat)remainTime{
    if (remainTime < 60 && remainTime >= 0) {
        NSInteger miliSecond = (NSInteger)floor((remainTime -  floor(remainTime))*100);
        if (remainTime < 10) {
            [secondTimeLabel setText:[NSString stringWithFormat:@"0%d.",(NSInteger)floor(remainTime)]];
        } else {
            [secondTimeLabel setText:[NSString stringWithFormat:@"%d.",(NSInteger)floor(remainTime)]];
        }


        if (miliSecond >= 10) {
            [miliSecTimeLabel setText:[NSString stringWithFormat:@"%d",miliSecond]];
        }
        else {
            [miliSecTimeLabel setText:[NSString stringWithFormat:@"0%d",miliSecond]];
        }
        [timeLabel setText:@""];
    }
    else if (remainTime >= 60){
        NSString *min, *sec;
        if ((NSInteger)ceil(remainTime) / 60 < 10) {
            min = [NSString stringWithFormat:@"0%d",(NSInteger)ceil(remainTime) / 60];
        }
        else {
            min = [NSString stringWithFormat:@"%d",(NSInteger)ceil(remainTime) / 60];
        }
        if ((NSInteger)ceil(remainTime) % 60 < 10) {
            sec = [NSString stringWithFormat:@"0%d",(NSInteger)ceil(remainTime) % 60];
        }
        else {
            sec = [NSString stringWithFormat:@"%d",(NSInteger)ceil(remainTime) % 60];
        }
        [timeLabel setText:[NSString stringWithFormat:@"%@:%@",min,sec]];
        [secondTimeLabel setText:@""];
        [miliSecTimeLabel setText:@""];
    } else {
        [timeLabel setText:@"--:--"];
        [secondTimeLabel setText:@""];
        [miliSecTimeLabel setText:@""];
    }
    
}

- (void) stopUpdateTimeGraphic{
    remainingTimeBeforeStop = _remainTime;
    stopUpdateTime = YES;
    [imageView setImage:[UIImage imageNamed:@"donghocam.png"]];
}

- (void) pendingUpdateTimeGraphicWithRemainingTime:(CGFloat)remainingTime{
    [self setTimeLabel:remainingTime];
    stopUpdateTime = YES;
    [imageView setImage:[UIImage imageNamed:@"donghocam.png"]];
}
- (void) continueUpdateTimeGraphic{
    if (!stopCountDownTimer && stopUpdateTime) {
        [imageView setImage:[UIImage imageNamed:@"donghoxanh.png"]];
        [self setRemainTime:_remainTime];
    } else if (stopCountDownTimer) {
        [self setTimeLabel:_remainTime];
        if (_remainTime == 0) {
            [imageView setImage:[UIImage imageNamed:@"donghodo.png"]];
            [self setAdjustRemainingTimeEnable:YES];
            if (self.delegate) {
                [self.delegate clockViewDidEndOfPeriod:self];
                NSLog(@"Continue update time");
            }
        } else {
            [self stop];
        }
    }
    stopUpdateTime = NO;

}
- (void) stopAndRevertRemainingTimeToLastStop{
    [self stop];
    [self setRemainTime:remainingTimeBeforeStop];
}
- (void) setStopMode:(BOOL)isStop{
    [self toggleButtonDidTap:nil];
}


- (void) countDownToRemainingTime:(CGFloat)remainTime{
    [[DataManager defaultManager] setRemainingTime:remainTime];
    if (remainTime > 0) {
        if (!stopUpdateTime) {
            [self setTimeLabel:remainTime];
        }
        if (_remainTime > durationOfTheMatch) {
//            durationOfTheMatch = _remainTime;
        }
        _remainTime = remainTime;
    } else if (remainTime <= 0) {
        _remainTime = 0;
        if (countDownTimer) {
            [countDownTimer invalidate];
            countDownTimer = nil;
        }
        
        isStartOfPeriod = YES;
        if (!stopUpdateTime) {
            [self setTimeLabel:0];
            [imageView setImage:[UIImage imageNamed:@"donghodo.png"]];
            [self setAdjustRemainingTimeEnable:YES];
            if (self.delegate && !isAdjustingTime) {
                [self.delegate clockViewDidEndOfPeriod:self];
                NSLog(@"Set remain time");
            }
            stopCountDownTimer = YES;
        } else {
            stopCountDownTimer = YES;            
            //            stopUpdateTime = NO;
        }
        
        if (!stopCountDownTimer) {
            
            
        }
        
    }

}
- (void) setRemainTime:(CGFloat)remainTime{
    if (durationOfTheMatch > 0) {
        if (remainTime > durationOfTheMatch) {
            [self setRemainTime:durationOfTheMatch];
            return;
        }
    }
    [[DataManager defaultManager] setRemainingTime:remainTime];
    if (remainTime > 0) {
        if (!stopUpdateTime) {
            [self setTimeLabel:remainTime];
        }
        if (_remainTime > durationOfTheMatch) {
//            durationOfTheMatch = _remainTime;
        }
        _remainTime = remainTime;
    } else if (remainTime <= 0 && remainTime != kDisabledValue) {
        _remainTime = 0;
        if (countDownTimer) {
            [countDownTimer invalidate];
            countDownTimer = nil;
        }

        isStartOfPeriod = YES;
        if (!stopUpdateTime) {
            [self setTimeLabel:0];
            [imageView setImage:[UIImage imageNamed:@"donghodo.png"]];
            [self setAdjustRemainingTimeEnable:YES];
//            if (self.delegate && !isAdjustingTime) {
//                [self.delegate clockViewDidEndOfPeriod:self];
//                NSLog(@"Set remain time");
//            }
            stopCountDownTimer = YES;
        } else {
            stopCountDownTimer = YES;            
//            stopUpdateTime = NO;
        }
    } else {
        _remainTime = kDisabledValue;
        [self setTimeLabel:remainTime];
    }
}

- (void) stop{
    [self setFlashing:YES];
    [self setUserInteractionEnabled:YES];
    stopUpdateTime = NO;
    stopCountDownTimer = YES;
    if (countDownTimer) {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
    [self setAdjustRemainingTimeEnable:stopCountDownTimer];
    [imageView setImage:[UIImage imageNamed:@"donghodo.png"]];
    if (self.delegate) {
        [self.delegate clockViewDidStopAtAction:self];
    }
}
     
- (void) stopByFoul:(ACTION_TYPE)foulType{
//    [self setAdjustRemainingTimeEnable:stopCountDownTimer];
    [self setFlashing:YES];
    stopUpdateTime = NO;
    stopCountDownTimer = YES;
    if (countDownTimer) {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
    [imageView setImage:[UIImage imageNamed:@"donghodo.png"]];
    if (self.delegate) {
        [self.delegate clockViewDidStop:self byFoul:foulType];
    }
}
- (void) prepareForNextPeriod:(id)sender{
    isAdjustingTime = YES;
    [self setRemainTime:[(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKey_Duration] floatValue]];
    isAdjustingTime = NO;
    stopCountDownTimer = YES;
    stopUpdateTime = NO;
    [self setFlashing:YES];
}

- (BOOL) isRunning{
    return !stopCountDownTimer;
}

- (void) setDurationOfAPeriod:(CGFloat)time{
    durationOfTheMatch = time;
}

- (CGFloat) durationOfAPeriod{
    return durationOfTheMatch;
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
