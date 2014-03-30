//
//  BBTeamPlayerView.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBPlayerView.h"
@interface BBTeamPlayerView : UIView{
    UIImageView *flashView;
    BOOL isStart;
    NSMutableArray *arrPlayers;
}
@property (nonatomic, readonly) BOOL isStart;
- (NSArray*) arrayOfSelectedPlayerView;
- (void) setEnable:(BOOL)enable;
- (void) start;
- (void) stop;
- (void) suspend;
- (void) resume;
- (void) reset;
- (void) deselectAll;
- (void) setPlayerWithIndex:(NSInteger)index;
- (NSString*) playerNameAtIndex:(NSInteger)index;
- (void) setFlashing:(BOOL)flashing;
- (void) setFlashing:(BOOL)flashing atIndex:(NSInteger)index;
- (NSArray*) arrayOfPlayer;
- (void) setPlayerInfoWithArray:(NSArray*)arrPlayers;
- (void) doneSubbing;
- (BOOL) hasPlayerReachedTheFoulLimit;
- (void) subOffReachedPlayers;
- (NSArray*) quickSaveData;
- (BBPlayerView*) playerViewWithIndex:(NSInteger)index;
@end
