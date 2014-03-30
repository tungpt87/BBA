//
//  BBPlayer.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBPlayer.h"
#import "BBClockView.h"
@implementation BBPlayer

- (id) init{
    self = [super init];
    if (self) {
        [self setName:@""];
        [self setNumber:@""];
        self.fullCourtLocation = CGPointZero;
    }
    return self;
}
- (id) initWithDictionary:(NSDictionary*)dictionary{
    self = [self init];
    if (self) {
        [self setName:[dictionary objectForKey:kKey_PlayerName]];
        [self setNumber:[NSString stringWithFormat:@"%d",[(NSNumber*)[dictionary objectForKey:kKey_PlayerNumber] intValue]]];
        [self setScores:[[dictionary objectForKey:kKey_Player_Score] intValue]];
        [self setFouls:[[dictionary objectForKey:kKey_Player_Foul] intValue]];
        [self setIsSelected:[[dictionary objectForKey:kKey_Player_Selected] boolValue]];
        [self setTimeOn:[[dictionary objectForKey:kKey_Player_TimeOn] floatValue]];
        [self setBeginTimes:[dictionary objectForKey:kKey_Player_BeginTime]];
        [self setEndTimes:[dictionary objectForKey:kKey_Player_EndTime]];
        [self setIsSubbedOn:[[dictionary objectForKey:kKey_player_IsSubbedOn] boolValue]];
        [self setFirstPeriod:[[dictionary objectForKey:kKey_Player_FirstPeriod] integerValue]];

    }
    return self;
}
- (void)addAppearsAtHalf:(PLAYER_APPEARANCE)appearance{
    _appearance = _appearance | appearance;
    if (_appearance == PLAYER_APPEARANCE_NONE) {
        self.numberOfHalves = 0;
    } else if (_appearance == PLAYER_APPEARANCE_BOTHHALF){
        self.numberOfHalves = 2;
    } else {
        self.numberOfHalves = 1;
    }
}

- (void) addScore:(NSInteger) point;{
    self.scores += point;
}
- (void) subtractScore:(NSInteger) point;{
    self.scores -= point;
}
- (void) addFoul;{
    self.fouls ++;
}
- (void) reset;{
    self.appearance = PLAYER_APPEARANCE_NONE;
    F_RELEASE(self.beginTimes);
    self.beginTimes = [[[NSMutableArray alloc] init] autorelease];
    F_RELEASE(self.endTimes);
    self.endTimes = [[[NSMutableArray alloc] init] autorelease];
    [self setIsSelected:NO];
    [self setFouls:0];
    [self setScores:0];
    [self setIsOnAction:NO];
    [self setIsOnPlayingTime:NO];
    [self setIsInTheCourt:NO];
}
- (void) addTechFoul;{
    self.techFouls ++;
}
- (NSDictionary*) dictionary;{
    NSMutableArray *arrBeginTime = (self.beginTimes)?self.beginTimes:[NSMutableArray array];
    NSMutableArray *arrEndTime = (self.endTimes)?self.endTimes:[NSMutableArray array];
    CGFloat currentTimeOn = [self currentTimeOn];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self number],
                                                              [self name],
                                                              [NSNumber numberWithBool:[self isInTheCourt]],
                                                              [NSNumber numberWithInt:self.numberOfHalves],
                                                              [NSNumber numberWithInt:self.index],
                                                              [NSNumber numberWithBool:[self isSelected]],
                                                              [NSNumber numberWithInt:self.scores],
                                                              [NSNumber numberWithInt:self.fouls],
                                                              [NSNumber numberWithFloat:currentTimeOn],
                                                              arrBeginTime,
                                                              arrEndTime,
                                                              [NSNumber numberWithBool:self.isSubbedOn],
                                                              [NSNumber numberWithInt:self.firstPeriod],
                                                              [NSNumber numberWithInt:self.teamIndex],
                                                              nil]
                                                     forKeys:[NSArray arrayWithObjects:
                                                              kKey_PlayerNumber,
                                                              kKey_PlayerName,
                                                              kKey_Player_IsInTheCourt,
                                                              kKey_Player_NumberOfHalves,
                                                              kKey_Player_Index,
                                                              kKey_Player_Selected,
                                                              kKey_Player_Score,
                                                              kKey_Player_Foul,
                                                              kKey_Player_TimeOn,
                                                              kKey_Player_BeginTime,
                                                              kKey_Player_EndTime,
                                                              kKey_player_IsSubbedOn,
                                                              kKey_Player_FirstPeriod,
                                                              kKey_Player_TeamIndex,
                                                              nil]];
    
    return dict;
}

- (NSMutableArray *)beginTimes{
    if (!_beginTimes) {
        _beginTimes = [[NSMutableArray alloc] init];
    }
    
    return _beginTimes;
}

- (NSMutableArray *)endTimes{
    if (!_endTimes) {
        _endTimes = [[NSMutableArray alloc] init];
    }
    return _endTimes;
}
- (void) addEndTime:(CGFloat)anEndTime;{
    for (int i = self.endTimes.count - 1; i >= 0; --i) {
        if ([[self.endTimes objectAtIndex:i] floatValue] <= anEndTime) {
            [self.endTimes removeObjectAtIndex:i];
        }
    }
    
    for (int i = self.beginTimes.count - 1; i >= 0; --i) {
        if ([[self.beginTimes objectAtIndex:i] floatValue] <= anEndTime) {
            [self.beginTimes removeObjectAtIndex:i];
        }
    }
    if (self.endTimes.count == self.beginTimes.count - 1) {
        [self.endTimes addObject:[NSNumber numberWithFloat:anEndTime]];
    }

}
- (void) addBeginTime:(CGFloat)aBeginTime;{
    for (int i = self.endTimes.count - 1; i >= 0; --i) {
        if ([[self.endTimes objectAtIndex:i] floatValue] <= aBeginTime) {
            [self.endTimes removeObjectAtIndex:i];
        }
    }
    
    for (int i = self.beginTimes.count - 1; i >= 0; --i) {
        if ([[self.beginTimes objectAtIndex:i] floatValue] <= aBeginTime) {
            [self.beginTimes removeObjectAtIndex:i];
        }
    }
    if (self.beginTimes.count == self.endTimes.count) {
        [self.beginTimes addObject:[NSNumber numberWithFloat:aBeginTime]];
    }
}
- (void) endOfPeriod;{
    if (self.beginTimes && self.endTimes) {
        for (int i = 0; i < self.beginTimes.count; ++i) {
            self.timeOn += [[self.beginTimes objectAtIndex:i] floatValue] - [[self.endTimes objectAtIndex:i] floatValue];
        }
        F_RELEASE(_beginTimes);
        F_RELEASE(_endTimes);
    }
}
- (CGFloat) currentTimeOn{
    CGFloat currentTimeOn = self.timeOn;
    if (self.beginTimes) {
        for (int i = 0; i < self.beginTimes.count; ++i) {
            if (i < self.endTimes.count) {
                currentTimeOn += [[self.beginTimes objectAtIndex:i] floatValue] - [[self.endTimes objectAtIndex:i] floatValue];
            } else {
                currentTimeOn += [[self.beginTimes objectAtIndex:i] floatValue] - [[BBClockView currentClockView] remainTime];
            }
        }
    }
    return currentTimeOn;


}
- (void) subtractFoul;{
    self.fouls --;
}
- (void) subtractTechFoul;{
    self.techFouls --;
}

- (BOOL) isReachedTheLimit;{
    return self.fouls >= [DataManager foulDangerLimit] || self.techFouls >= kTechFoulDangerLimit;
}
- (void)setIsSubbedOnWithoutNotify:(BOOL)isSubbedOn;{
    _isSubbedOn = isSubbedOn;
}
- (void)setIsSubbedOn:(BOOL)isSubbedOn{
    if (isSubbedOn != _isSubbedOn) {
        NSInteger i = self.playerId;
        NSInteger teamIndex = self.teamIndex;
        NSDictionary *dictPlayerSub = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:teamIndex],[NSNumber numberWithInt:i], [NSNumber numberWithBool:isSubbedOn], nil]
                                                                  forKeys:[NSArray arrayWithObjects:kKey_PlayerSubbing_TeamIndex, kKey_PlayerSubbing_Index,kKey_PlayerSubbing_On, nil]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlayerSubbed
                                                            object:dictPlayerSub];
    }
    _isSubbedOn = isSubbedOn;

}

- (NSString *)description{
    return [NSString stringWithFormat:@"Player Index: %d",self.index];
}
@end
