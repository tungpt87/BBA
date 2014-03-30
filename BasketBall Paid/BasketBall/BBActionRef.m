//
//  BBAction.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBActionRef.h"

@implementation BBActionRef
@synthesize actionType;
@synthesize actionTime;
@synthesize actionLocation;
@synthesize playerIndex;
@synthesize teamIndex;
@synthesize period;
@synthesize isReplaced;
@synthesize isSaved;
- (id) initWithTime:(CGFloat)time{
    self = [super init];
    if (self) {
        actionTime = time;
        actionType = ACTION_TYPE_UNKNOWN;
        playerIndex = 0;
        teamIndex = -1;
        actionLocation = CGPointZero;
        isReplaced = NO;
        isSaved = NO;
    }
    return self;
}

- (id) initWithAction:(BBActionRef*)anAction{
    self = [super init];
    if (self) {
        actionType = anAction.actionType;
        actionLocation = anAction.actionLocation;
        actionTime = anAction.actionTime;
        teamIndex = anAction.teamIndex;
        playerIndex = anAction.playerIndex;
        period = anAction.period;
        isReplaced = NO;
        isSaved = NO;
    }
    return self;
}
- (CGPoint) locationInView:(UIView*)view{
    CGFloat x = view.frame.size.width * actionLocation.x;
    CGFloat y = view.frame.size.height * actionLocation.y;
    return CGPointMake(x, y);
}

- (id) initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    if (self) {
        actionType = [[dictionary objectForKey:kKey_Action_ActionType] intValue];
        NSDictionary *dctLocation = [dictionary objectForKey:kKey_Action_ActionLocation];
        actionLocation = CGPointMake([[dctLocation objectForKey:kKey_Action_Location_X] floatValue], [[dctLocation objectForKey:kKey_Action_Location_Y] floatValue]);
        actionTime = [[dictionary objectForKey:kKey_Action_ActionTime] floatValue];
        teamIndex = [[dictionary objectForKey:kKey_Action_TeamIndex] intValue];
        playerIndex = [[dictionary objectForKey:kKey_Action_PlayerIndex] intValue];
        period = [[dictionary objectForKey:kKey_Action_Period] intValue];
        isReplaced = [[dictionary objectForKey:kKey_Action_IsReplaced] boolValue];
        isSaved = [[dictionary objectForKey:kKey_Action_IsSaved] boolValue];
    }
    return self;
}
- (NSDictionary*) dictionary{
    NSDictionary *dictLocation = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithFloat:actionLocation.x],[NSNumber numberWithFloat:actionLocation.y], nil]
                                                             forKeys:[NSArray arrayWithObjects:kKey_Action_Location_X, kKey_Action_Location_Y, nil]];
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:actionType], dictLocation,[NSNumber numberWithFloat:actionTime],[NSNumber numberWithInt:teamIndex],[NSNumber numberWithInt:playerIndex], [NSNumber numberWithInt:period],[NSNumber numberWithBool:isSaved],[NSNumber numberWithBool:isReplaced], nil]
                                forKeys:[NSArray arrayWithObjects:kKey_Action_ActionType, kKey_Action_ActionLocation, kKey_Action_ActionTime, kKey_Action_TeamIndex, kKey_Action_PlayerIndex, kKey_Action_Period,kKey_Action_IsSaved,kKey_Action_IsReplaced, nil]];

}

- (BOOL)isEqual:(id)object{
    BBActionRef *objAction = (BBActionRef*)object;
    if (actionType == objAction.actionType && CGPointEqualToPoint(actionLocation, objAction.actionLocation) && actionTime == objAction.actionTime && teamIndex == objAction.teamIndex && playerIndex == objAction.playerIndex && period == objAction.period && isReplaced == objAction.isReplaced && isSaved == objAction.isSaved) {
        return YES;
    } else {
        return NO;
    }
}
- (NSString *)description{
    return [NSString stringWithFormat:@"Action Type: %d\nX: %f\nY: %f\nActionTime: %f\nTeam Index: %d\nPlayer Index: %d\nPeriod: %d\nReplaced: %d\nSaved: %d\n\n",actionType,actionLocation.x,actionLocation.y,actionTime,teamIndex,playerIndex,period,isReplaced,isSaved];
}

@end
