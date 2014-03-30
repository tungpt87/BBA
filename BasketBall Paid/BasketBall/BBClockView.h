//
//  BBClockView.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kButtonSizeHeight           50
#define kButtonSizeWidth            50
#define kTimeLabelLargeFontSize     80
#define kTimeLabelSmallFontSize     40


@class BBClockView;
typedef enum {
    LOOPTIMER_TYPE_UP = 0,
    LOOPTIMER_TYPE_DOWN = 1,
}LOOPTIMER_TYPE;

@protocol BBClockViewDelegate <NSObject>

@required
- (void) clockViewDidStart:(BBClockView*)clockView;
- (void) clockViewDidStop:(BBClockView*)clockView;
- (void) clockViewDidEndOfPeriod:(BBClockView*)clockView;
- (void) clockViewDidStop:(BBClockView*)clockView byFoul:(ACTION_TYPE)foulType;
- (void) clockViewDidStopAtAction:(BBClockView*)clockView;
- (void) clockViewDidTapToStart:(BBClockView*)clockView;
@end
@interface BBClockView : UIView{
    UILabel *timeLabel;
    UILabel *secondTimeLabel, *miliSecTimeLabel;
    UIButton *toggleButton;
    
    UIImageView *imageView, *flashingView;
    NSTimer *countDownTimer, *longPressTimer, *loopTimer;
    CGFloat _remainTime; ///Remain time in second
    BOOL stopUpdateTime;
    BOOL stopCountDownTimer;
    
    id <BBClockViewDelegate> delegate;
    NSDate *start, *oldDate, *end, *suspend, *resume;
    UIButton *btnUp, *btnDown, *btnAll, *btnCont;
    
    BOOL isAllMode, isContMode;
    
    BOOL isStartOfPeriod;
    
    BOOL shouldRevertRemainingTime;
    
    BOOL isFlashing;
    
    BOOL isAdjustingTime;
    
    BOOL isStartOfAMatch;
    CGFloat remainingTimeBeforeStop;
    CGFloat durationOfTheMatch;
    
    CGFloat distance;
    NSTimer *flashingTimer;
}
@property (nonatomic) BOOL isFlashing;
@property (nonatomic) CGFloat remainTime;
@property (nonatomic, retain) id <BBClockViewDelegate> delegate;
@property (nonatomic, readonly) BOOL isAllMode, isContMode;


//////Public Method
- (void) disable;
- (void) stopUpdateTimeGraphic;
- (void) setStopMode:(BOOL)isStop;
- (CGFloat) getCurrentTimeOfTheMatch;
- (void) continueUpdateTimeGraphic;
- (void) stopAndRevertRemainingTimeToLastStop;
- (void) stop;
- (void) stopCountDownTimer;
- (void) prepareForNextPeriod:(id)sender;
- (void) pendingUpdateTimeGraphicWithRemainingTime:(CGFloat)remainingTime;
- (void) start;
- (void) setFlashing:(BOOL)flashing;
- (BOOL) isRunning;
- (void) stopByFoul:(ACTION_TYPE)foulType;
- (void) setAdjustRemainingTimeEnable:(BOOL)enable;
- (void) toggleChangeModeEnabled:(BOOL)enabled;
- (CGFloat) durationOfAPeriod;
- (void) setDurationOfAPeriod:(CGFloat)time;
+ (BBClockView*) currentClockView;
@end
