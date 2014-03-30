//
//  BBPlayer.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    PLAYER_APPEARANCE_NONE = 0,
    PLAYER_APPEARANCE_FIRSTHALF = 1,
    PLAYER_APPEARANCE_SECONDHALF = 2,
    PLAYER_APPEARANCE_BOTHHALF = 3,
}PLAYER_APPEARANCE;

@interface BBPlayer : NSObject{

}
- (void) addAppearsAtHalf:(PLAYER_APPEARANCE)appearance;
@property (nonatomic) BOOL withBall;
@property (nonatomic) PLAYER_APPEARANCE appearance;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic) NSInteger playerId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *number;
@property (nonatomic) BOOL isOnPlayingTime;
@property (nonatomic) BOOL isOnAction;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) BOOL isInTheCourt;
@property (nonatomic) BOOL isFlashing;
@property (nonatomic) BOOL couldStartFlashing;
@property (nonatomic) BOOL isSubbedOn;


@property (nonatomic) NSInteger scores, fouls, techFouls;
@property (nonatomic) NSInteger firstPeriod;
@property (nonatomic) NSInteger numberOfHalves;
@property (nonatomic, retain) NSMutableArray *beginTimes, *endTimes;
@property (nonatomic) CGFloat timeOn;
@property (nonatomic) NSInteger index,teamIndex;
@property (nonatomic) CGPoint fullCourtLocation;
- (void) addScore:(NSInteger) point;
- (void) subtractScore:(NSInteger) point;
- (void) addFoul;
- (void) reset;
- (void) addTechFoul;
- (NSDictionary*) dictionary;
- (void) addEndTime:(CGFloat)anEndTime;
- (void) addBeginTime:(CGFloat)aBeginTime;
- (CGFloat) timeOn;
- (void) endOfPeriod;
- (void) takeToTheCourtInPeriod:(NSInteger)period;
- (void) subtractFoul;
- (void) subtractTechFoul;

- (BOOL) isReachedTheLimit;
- (void)setIsSubbedOnWithoutNotify:(BOOL)isSubbedOn;
- (void) setTimeOn:(CGFloat)timeOn;
- (void)setIsSubbedOn:(BOOL)isSubbedOn;
@end
