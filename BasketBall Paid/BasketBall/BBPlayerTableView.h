//
//  BBPlayerTableView.h
//  BasketBall
//
//  Created by TungPT on 12/18/12.
//
//

#import <UIKit/UIKit.h>
#import "BBPlayer.h"
#import "BBPlayerCell.h"
@interface BBPlayerTableView : UITableView<UITableViewDataSource, UITableViewDelegate>{
    NSInteger nextId;
}

@property (nonatomic, retain) NSMutableArray *players;
@property (nonatomic, assign) id <BBPlayerCellDelegate> cellDelegate;
@property (nonatomic) BOOL isStart;
- (void) setPlayers:(NSArray*)players;
- (void) addPlayer:(BBPlayer*)player;
- (void) removePlayer:(BBPlayer*)player;
- (void) setPlayer:(BBPlayer*)player atIndex:(NSInteger)index;
- (NSArray*) arrayOfSelectedPlayer;
- (void) doneSubbing;
- (void) start;
- (void) setFlashing:(BOOL)flashing;
- (void) setFlashing:(BOOL)flashing atIndex:(NSInteger)index;
- (BOOL) hasPlayerReachedTheFoulLimit;
- (void) reset;
- (void) stop;
- (void) setPlayerInfoWithArray:(NSArray*)arrPlayers;
- (void) setEnable:(BOOL)enable;
- (void) deselectAll;
- (void) toggleAddPlayerButtonVisible:(BOOL)visible;
- (NSArray*) quickSaveData;
- (NSArray*) arrayOfPlayer;
- (BBPlayer*) playerWithIndex:(NSInteger)index;
- (NSString*) playerNameAtIndex:(NSInteger)index;
- (void) sortPlayersByNumber;
- (void) selectPlayerForAction:(BBPlayer*)player;
+ (NSMutableArray*) allPlayers;

@end
