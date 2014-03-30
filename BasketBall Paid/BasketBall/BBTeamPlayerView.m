//
//  BBTeamPlayerView.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBTeamPlayerView.h"
@implementation BBTeamPlayerView
@synthesize isStart;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSArray*) arrayOfSelectedPlayerView{
    NSMutableArray *players = [NSMutableArray array];
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[BBPlayerView class]]) {
            if ([(BBPlayerView*)view isSelected]) {
                [players addObject:view];
            }
        }
    }


    return (NSArray*)players;
}

- (void) doneSubbing{
    

    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[BBPlayerView class]]) {
            BBPlayerView *playerView = (BBPlayerView*)subview;
            if (playerView.isSubbedOn != playerView.isSelected) {
                if (playerView.isSelected) {
                    [playerView addBeginTime:[[DataManager defaultManager] remainingTime]];
                    [playerView setIsSubbedOn:YES];
                    [playerView takeToTheCourtInPeriod:[[DataManager defaultManager] period]];
                } else {
                    [playerView addEndTime:[[DataManager defaultManager] remainingTime]];
                    [playerView setIsSubbedOn:NO];
                }
            }
        }
    }
    
}
- (void) start{
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[BBPlayerView class]]) {
            if (![(BBPlayerView*)view isSelected]) {
                [(BBPlayerView*)view setEnable:NO];
            } else {
                [(BBPlayerView*)view setIsOnPlayingTime:YES];
            }
        }
    }
    isStart = YES;
}
- (BOOL) hasPlayerReachedTheFoulLimit{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[BBPlayerView class]]) {
            BBPlayerView *playerView = (BBPlayerView*)subview;
            if ([playerView isReachedTheLimit] && [playerView isSelected]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void) subOffReachedPlayers{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[BBPlayerView class]]) {
            BBPlayerView *playerView = (BBPlayerView*)subview;
            if ([playerView isReachedTheLimit]) {
                [playerView setIsSelected:NO];
                [playerView setEnable:NO];
            }
        }
    }
}
- (void) stop{
    [self setUserInteractionEnabled:YES];
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[BBPlayerView class]]) {
            [(BBPlayerView*)view setEnable:YES];
            [(BBPlayerView*)view setIsOnPlayingTime:NO];
            [(BBPlayerView*)view setIsOnAction:NO];
        }
    }
    isStart = NO;
}

- (void) suspend{
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[BBPlayerView class]]) {
            [(BBPlayerView*)view setEnable:YES];
        }
    }
}

- (void) resume{
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[BBPlayerView class]]) {
            if (![(BBPlayerView*)view isSelected]) {
                [(BBPlayerView*)view setEnable:NO];
            }
        }
    }
}


- (void)awakeFromNib{

    isStart = NO;
}

- (void) timerFlashingOff{
    [UIView animateWithDuration:1
                     animations:^{
                         [flashView setAlpha:0];
                     } completion:^(BOOL finished) {
                         [self timerFlashingOn];
                     }];
}
- (void) timerFlashingOn{
    [UIView animateWithDuration:1
                     animations:^{
                         [flashView setAlpha:1];
                     } completion:^(BOOL finished) {
                         [self timerFlashingOff]; 
                     }];
}
- (void) reset{
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:[BBPlayerView class]]) {
            NSInteger index = [[self subviews] indexOfObject:subView];
            [(BBPlayerView*)subView setNumber:index+1];
            [(BBPlayerView*)subView setName:@""];
            if ((self.tag == 0 &&[self.subviews indexOfObject:subView] > 1) || (self.tag == 1 && [self.subviews indexOfObject:subView] > 0)) {
                [(BBPlayerView*)subView setHidden:YES];
            }
        }
    }
}

- (void) setFlashing:(BOOL)flashing{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[BBPlayerView class]]) {
            BBPlayerView *playView = (BBPlayerView*)subView;
            if (playView.isOnPlayingTime || playView.isFlashing || !isStart) {
                [playView toggleFlashing:flashing];
            }
//            [playView toggleFlashing:flashing];
        }
    }

}

- (void) setFlashing:(BOOL)flashing atIndex:(NSInteger)index{
    [self setEnable:NO];
    [self setUserInteractionEnabled:YES];
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[BBPlayerView class]]) {
            if ([(BBPlayerView*)subView isOnPlayingTime] || [(BBPlayerView*)subView isFlashing]) {
                if ([self.subviews indexOfObject:subView]+1 == index) {
                    [(BBPlayerView*)subView toggleFlashing:YES];                    
                }  
            }
        }
    }
}

- (void) setEnable:(BOOL)enable{
    [self setUserInteractionEnabled:enable];
    if (!enable) {
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[BBPlayerView class]]) {
                BBPlayerView *playView = (BBPlayerView*)subView;
                if (playView.isOnPlayingTime) {
                    [playView toggleFlashing:enable];
                    [playView setIsOnAction:NO];
                }
            }
        }

    }
}


- (void) deselectAll{
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[BBPlayerView class]]) {
            if ([(BBPlayerView*)view isSelected]) {
                [(BBPlayerView*)view setIsOnAction:NO];
            }

        }
    }
}

- (void) setPlayerWithIndex:(NSInteger)index{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[BBPlayerView class]]) {
            if ([(BBPlayerView*)subView isOnPlayingTime]) {
                if ([self.subviews indexOfObject:subView]+1 != index) {
                    [(BBPlayerView*)subView setIsOnAction:NO];                    
                }  
                else {
                    [(BBPlayerView*)subView setIsOnAction:YES];                    
                }
            }
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (NSString*) playerNameAtIndex:(NSInteger)index{
    BBPlayerView *playerView = [self.subviews objectAtIndex:index];
    return [playerView name];
}
- (BBPlayerView*) playerViewWithIndex:(NSInteger)index{
    return [self.subviews objectAtIndex:index];
}
- (NSArray*) arrayOfPlayer{
    NSMutableArray *arrPlayers = [NSMutableArray array];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[BBPlayerView class]]) {
            BBPlayerView *player = (BBPlayerView*)subview;
            NSDictionary *dictPlayer = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:player.number.intValue],player.name,[NSNumber numberWithBool:[player isHiddenPlayer]], nil]
                                                                   forKeys:[NSArray arrayWithObjects:kKey_PlayerNumber, kKey_PlayerName,kKey_Player_IsHidden, nil]];
            [arrPlayers addObject:dictPlayer];
        }
    }
    return arrPlayers;
}

- (void) setPlayerInfoWithArray:(NSArray*)arrPlayers{
    if (arrPlayers) {
        if (arrPlayers.count == 0) {
            BBPlayerView *playerView = (BBPlayerView*)[[self subviews] objectAtIndex:0];
            [playerView setHidden:NO];
            return;
        }
        int j = 0;
        for (int i = 0; i < kNumberOfPlayer; i++) {
            BBPlayerView *playerView = (BBPlayerView*)[[self subviews] objectAtIndex:i];
            [playerView setHidden:YES];
        }
        for (int i = 0; i < kNumberOfPlayer; ++i) {
            if (i < arrPlayers.count) {
                NSDictionary *player = [arrPlayers objectAtIndex:i];
                BOOL isHidden = [[player objectForKey:kKey_Player_IsHidden] boolValue];
                if (!isHidden) {
                    NSInteger number = [(NSNumber*)[player objectForKey:kKey_PlayerNumber] intValue];
                    NSString *name = [player objectForKey:kKey_PlayerName];
                    NSInteger scores = [[player objectForKey:kKey_Player_Score] intValue];
                    NSInteger fouls = [[player objectForKey:kKey_Player_Foul] intValue];
                    BOOL isSelected = [[player objectForKey:kKey_Player_Selected] boolValue];
                    CGFloat timeOn = [[player objectForKey:kKey_Player_TimeOn] floatValue];
                    NSArray *beginTime = [player objectForKey:kKey_Player_BeginTime];
                    NSArray *endTime = [player objectForKey:kKey_Player_EndTime];
                    BBPlayerView *playerView = (BBPlayerView*)[self.subviews objectAtIndex:j];
                    [playerView setName:name];
                    [playerView setNumber:number];
                    [playerView setHidden:NO];
                    [playerView setScore:scores];
                    [playerView setFoul:fouls];
                    [playerView setIsSelected:isSelected];
                    [playerView setTimeOn:timeOn];
                    [playerView setBeginTime:beginTime];
                    [playerView setEndTime:endTime];
                    [playerView setIsSubbedOn:[[player objectForKey:kKey_player_IsSubbedOn] boolValue]];
                    [playerView setFirstPeriod:[[player objectForKey:kKey_Player_FirstPeriod] integerValue]];
                    j++;
                }
            }
        }
    }
}
- (NSArray*) quickSaveData{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *subView = [self.subviews objectAtIndex:i];
        if ([subView isKindOfClass:[BBPlayerView class]]) {
            BBPlayerView *playerView = (BBPlayerView*)subView;
            if (!subView.hidden) {
                [arr addObject:[playerView dictionary]];
            }
        }
    }
    return arr;
}
@end
