//
//  BBPlayerView.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBPlayer.h"
#define kLabelFrameHeight                   self.frame.size.height
#define kAccessoryView_Size_Height          60
@class BBPlayerView;

@protocol BBPlayerViewDelegate <NSObject>

@required
- (void) playerViewDidTapped:(BBPlayerView*)playerView;
- (void) playerViewDidSubbedOff:(BBPlayerView*)playerView;
- (void) playerViewDidSubbedOn:(BBPlayerView*)playerView;

@end
@interface BBPlayerView : UIView<UIActionSheetDelegate, UIActionSheetDelegate,UIPickerViewDataSource, UIPickerViewDelegate>{
    UILabel *lblNumber;
    UILabel *lblName;
    UILabel *lblScore;
    UILabel *lblFoul;
    UIButton *button;
    NSTimer *longPressTimer;
    UIImageView *bgImageView, *subBgImageView;
    UIImageView *imgScore, *imgFoul;
    UIImageView *imgDot;
    BBPlayer *player;
    BOOL isOnPlayingTime;
    BOOL _isOnAction;
    BOOL isInTheCourt;
    BOOL isFlashing;
    BOOL couldStartFlashing;
    BOOL _isSubbedOn;
    UIView *accessoryView;
    UITextField *hiddenTextField, *tfNumber, *tfName, *tfHidden;
    NSTimer *flashingTimer;
    id <BBPlayerViewDelegate> _delegate;
    
    
    NSInteger scores, fouls, techFouls;
    NSInteger firstPeriod;
    NSInteger numberOfHalves;
    NSMutableArray *beginTime, *endTime;
    CGFloat _timeOn;
    NSInteger index;
    
}
@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL isSubbedOn;
@property (nonatomic, readonly) NSInteger numberOfHalves;
@property (nonatomic, readonly) BOOL isFlashing;
@property (nonatomic) NSInteger firstPeriod;
@property (nonatomic) BOOL isInTheCourt;
@property (nonatomic,retain) id <BBPlayerViewDelegate> delegate;
@property (nonatomic) BOOL isOnAction;
@property (nonatomic) BOOL isOnPlayingTime;
- (BOOL) isHiddenPlayer;
- (void) setNumber:(NSInteger)number;
- (void) setName:(NSString*)name;
- (void) setScore:(NSInteger)score;
- (void) setFoul:(NSInteger)foul;
- (BOOL) isSelected;
- (void) setEnable:(BOOL)enable;
- (void) setIsOnPlayingTime:(BOOL)onPlayingTime;
- (void) setIsSelected:(BOOL)selected;
- (NSString*) number;
- (NSString*) name;
- (void) addScore:(NSInteger) point;
- (void) subtractScore:(NSInteger) point;
- (void) addFoul;
- (void) reset;
- (void) setDot:(NSInteger)numberOfDot;
- (void) toggleFlashing:(BOOL)flashing;
- (void) addTechFoul;
- (NSDictionary*) dictionary;
- (void) addEndTime:(CGFloat)anEndTime;
- (void) addBeginTime:(CGFloat)aBeginTime;
- (CGFloat) timeOn;
- (void) endOfPeriod;
- (void) takeToTheCourtInPeriod:(NSInteger)period;
- (void) subtractFoul;
- (void) subtractTechFoul;
- (NSArray*) beginTimes;
- (NSArray*) endTimes;
- (BOOL) isReachedTheLimit;
- (void)setIsSubbedOnWithoutNotify:(BOOL)isSubbedOn;
- (void) setTimeOn:(CGFloat)timeOn;
- (void) setBeginTime:(NSArray*)arrBeginTime;
- (void) setEndTime:(NSArray*)arrEndTime;
@end
