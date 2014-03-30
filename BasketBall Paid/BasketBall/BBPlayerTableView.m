//
//  BBPlayerTableView.m
//  BasketBall
//
//  Created by TungPT on 12/18/12.
//
//

#import "BBPlayerTableView.h"
static NSMutableArray *allPlayers;
@implementation BBPlayerTableView
+ (NSMutableArray*) allPlayers{
    if (!allPlayers) {
        allPlayers = [[NSMutableArray alloc] init];
    }
    return allPlayers;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void) setPlayers:(NSArray*)players;{
//    F_RELEASE(players);
//    _players = [[[NSMutableArray alloc] initWithArray:players] autorelease];
//}
- (void) addPlayer:(BBPlayer*)player;{
    if (!self.players) {
        self.players = [[[NSMutableArray alloc] init] autorelease];
    }
    [player setIndex:nextId];
    nextId ++;
    [player setTeamIndex:self.tag];
    [self.players addObject:player];
//    [self sortPlayersByNumber];
}
- (void) removePlayer:(BBPlayer*)player;{
    [self.players removeObject:player];
    [self reloadSections:[NSIndexSet indexSetWithIndex:0]
        withRowAnimation:UITableViewRowAnimationFade];
}
- (void) setPlayer:(BBPlayer*)player atIndex:(NSInteger)index;{
    BBPlayer *desPlayer = [self.players objectAtIndex:index];
    desPlayer.name = player.name;
    desPlayer.number = player.number;
}


- (NSArray *)arrayOfSelectedPlayer{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        BBPlayer *player = (BBPlayer*)evaluatedObject;
        if (player.isSelected) {
            return YES;
        } else {
            return NO;
        }
    }];
    return [self.players filteredArrayUsingPredicate:predicate];
}
- (void) doneSubbing;{
    NSInteger period = [[DataManager defaultManager] period];
    for (BBPlayer *player in self.players) {
        if (player.isSubbedOn != player.isSelected) {
            if (player.isSelected) {
                [player addBeginTime:[[DataManager defaultManager] remainingTime]];
                [player setIsSubbedOn:YES];
                [player addAppearsAtHalf:(period < 3)?PLAYER_APPEARANCE_FIRSTHALF:PLAYER_APPEARANCE_SECONDHALF];
            } else {
                [player addEndTime:[[DataManager defaultManager] remainingTime]];
                [player setIsSubbedOn:NO];
            }
        }
    }
}
- (void) start;{
    for (int i = 0; i < self.players.count; i ++) {
        BBPlayerCell *cell = (BBPlayerCell*)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (![cell.player isSelected]) {
            [cell setEnable:NO];
        } else {
            [cell.player setIsOnPlayingTime:YES];
        }
        [cell setNeedsLayout];
    }
    self.isStart = YES;
}
- (NSArray*) arrayOfPlayer{
    NSMutableArray *arrPlayer = [NSMutableArray array];
    for (BBPlayer *player in self.players) {
        NSInteger number = [[player number] intValue];
        if (number > 0) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:player.dictionary];
            [dict setObject:[NSNumber numberWithInt:0]
                     forKey:kKey_Player_Score];
            [dict setObject:[NSNumber numberWithInt:0]
                     forKey:kKey_Player_Foul];
            [arrPlayer addObject:dict];
        }
    }
    return [NSArray arrayWithArray:arrPlayer];

}

- (void) sortPlayersByNumber{
    NSArray *sortedArray = [self.players sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        BBPlayer *player1 = obj1;
        BBPlayer *player2 = obj2;
        return [player1.number compare:player2.number options:NSNumericSearch];
    }];
    [self beginUpdates];
    for (int i = 0; i < self.players.count; i++) {
        [self moveRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                     toIndexPath:[NSIndexPath indexPathForRow:[sortedArray indexOfObject:[self.players objectAtIndex:i]] inSection:0]];
        
    }
    [self endUpdates];
    _players = [[NSMutableArray alloc] initWithArray:sortedArray];
}

- (void)setFlashing:(BOOL)flashing{
    for (BBPlayerCell *cell in self.visibleCells) {
        BBPlayer *player = cell.player;
        if (player.isOnPlayingTime || !self.isStart) {
            [cell toggleFlashing:flashing];
        }
    }
}

- (void)setFlashing:(BOOL)flashing atIndex:(NSInteger)index{
    for (BBPlayer *player in self.players) {
        if (player.index == index) {
            [player setIsFlashing:YES];
        } else {
            [player setIsFlashing:NO];
        }
    }
    [self reloadData];
}
- (BOOL) hasPlayerReachedTheFoulLimit;{
    for (BBPlayer *player in self.players) {
        if (player.isReachedTheLimit && player.isSelected) {
            return YES;
        }
    }
    return NO;
}
- (void) selectPlayerForAction:(BBPlayer*)player;{
    for (BBPlayer *plr in self.players) {
        if (plr == player) {
            plr.isOnAction = YES;
        } else {
            plr.isOnAction = NO;
        }
    }
    [self reloadData];
}
- (void) reset;{
    self.players = nil;
    [self reloadData];
}
- (void)setEnable:(BOOL)enable{
    [self setUserInteractionEnabled:enable];
    for (BBPlayerCell *cell in self.visibleCells) {
        if (cell.player.isOnPlayingTime) {
            [cell toggleFlashing:enable];
            [cell.player setIsOnAction:NO];
        }
    }
}

- (void)deselectAll{
    for (BBPlayer *player in self.players) {
        [player setIsOnAction:NO];
    }
    [self reloadData];
}
- (void) stop;{
    [self setUserInteractionEnabled:YES];
    for (BBPlayerCell *cell in [self visibleCells]) {
        [cell setEnable:YES];
        [cell.player setIsOnPlayingTime:NO];
        [cell.player setIsOnAction:NO];
    }
    self.isStart = NO;
    [self reloadData];
}

- (void)setPlayers:(NSArray *)players{
    nextId = 1;
    F_RELEASE(_players);
    _players = [[NSMutableArray alloc] init];
    for (BBPlayer *player in players) {
        player.index = nextId;
        [player setTeamIndex:self.tag];
        [self addPlayer:player];
        nextId ++;
    }
}

- (NSString*) playerNameAtIndex:(NSInteger)index;{
    for (int i = 0; i < self.players.count; ++i) {
        BBPlayer *player = [self.players objectAtIndex:i];
        if (player.index == index) {
            return player.name;
        }
    }
    return nil;
}
- (void) setPlayerInfoWithArray:(NSArray*)arrPlayers;{
    if (arrPlayers) {
//        self.players = [NSMutableArray array];
        self.players = nil;
        if (arrPlayers.count == 0) {
            BBPlayer *player = [[BBPlayer alloc] init];
            [player setNumber:@"1"];
            [player setIndex:1];
            [player setTeamIndex:self.tag];
            [self addPlayer:player];
            return;
        }
        int j = 0;
//        for (int i = 0; i < kNumberOfPlayer; i++) {
//            BBPlayerView *playerView = (BBPlayerView*)[[self subviews] objectAtIndex:i];
//            [playerView setHidden:YES];
//        }
        for (int i = 0; i < arrPlayers.count; ++i) {
            if (i < arrPlayers.count) {
                NSDictionary *dictPlayer = [arrPlayers objectAtIndex:i];
                NSInteger number = [(NSNumber*)[dictPlayer objectForKey:kKey_PlayerNumber] intValue];
                NSString *name = [dictPlayer objectForKey:kKey_PlayerName];
                NSInteger scores = [[dictPlayer objectForKey:kKey_Player_Score] intValue];
                NSInteger fouls = [[dictPlayer objectForKey:kKey_Player_Foul] intValue];
                BOOL isSelected = [[dictPlayer objectForKey:kKey_Player_Selected] boolValue];
                CGFloat timeOn = [[dictPlayer objectForKey:kKey_Player_TimeOn] floatValue];
                NSArray *beginTime = [dictPlayer objectForKey:kKey_Player_BeginTime];
                NSArray *endTime = [dictPlayer objectForKey:kKey_Player_EndTime];
                NSInteger index = [[dictPlayer objectForKey:kKey_Player_Index] intValue];
                NSInteger teamIndex = [[dictPlayer objectForKey:kKey_Player_TeamIndex] intValue];
                BBPlayer *player = [[BBPlayer alloc] init];
                [player setName:name];
                [player setNumber:[NSString stringWithFormat:@"%d",number]];
                [player setScores:scores];
                [player setFouls:fouls];
                [player setIsSelected:isSelected];
                [player setTimeOn:timeOn];
                [player setBeginTimes:[NSMutableArray arrayWithArray:beginTime]];
                [player setEndTimes:[NSMutableArray arrayWithArray:endTime]];
                [player setIsSubbedOn:[[dictPlayer objectForKey:kKey_player_IsSubbedOn] boolValue]];
                [player setFirstPeriod:[[dictPlayer objectForKey:kKey_Player_FirstPeriod] integerValue]];
                [player setIndex:index];
                [player setTeamIndex:teamIndex];
                j++;
                [self addPlayer:player];
            }
        }
    }
    [self reloadData];
}
- (BBPlayer*) playerWithIndex:(NSInteger)index;{
    for (BBPlayer *player in self.players) {
        if (player.index == index) {
            return player;
        }
    }
    return nil;
}
- (void) addNewPlayer{
    NSString *maxNumber = 0;
    for (BBPlayer *player in self.players) {
        if ([player.number compare:maxNumber options:NSNumericSearch] == NSOrderedDescending) {
            maxNumber = player.number;
        }
    }
    
    NSString *nextNumber = [NSString stringWithFormat:@"%d",[maxNumber integerValue]+1];
    BBPlayer *player = [[BBPlayer alloc] init];
    player.number = nextNumber;
    [self addPlayer:player];
    [player release];
//    [self reloadSections:[NSIndexSet indexSetWithIndex:0]
//        withRowAnimation:UITableViewRowAnimationRight];
    [self insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.players.count - 1 inSection:0]]
                withRowAnimation:UITableViewRowAnimationFade];

}
- (void)toggleAddPlayerButtonVisible:(BOOL)visible{
    [self.tableFooterView setHidden:!visible];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setClipsToBounds:YES];
    [self setScrollEnabled:NO];
//    _players = [[NSArray alloc] initWithObjects:@"skdjhfajskf",@"2ksdjhfa",@"skdjhfajskf",@"2ksdjhfa",@"skdjhfajskf",@"asdjh",@"aksjdhfa", nil];
    [self setDelegate:self];
    [self setDataSource:self];
//    [self reloadData];
    
    UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 176, 34)];
    [btnAdd setImage:[UIImage imageNamed:@"addplayer.png"]
            forState:UIControlStateNormal];
    [btnAdd addTarget:self
               action:@selector(addNewPlayer)
     forControlEvents:UIControlEventTouchUpInside];
    self.tableFooterView = btnAdd;
    [btnAdd release];
    
    //Initiate nextId value
    nextId = 1;
}

- (NSArray*) quickSaveData{
    NSMutableArray *arr = [NSMutableArray array];
    for (BBPlayer *player in self.players) {
        [arr addObject:[player dictionary]];
    }
    return arr;
}
#pragma mark - UITableView Stuff
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.players.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (self.players.count < 12) {
        height = (self.frame.size.height - 40) / self.players.count;
    } else {
        height = self.frame.size.height / self.players.count;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    BBPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[BBPlayerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDelegate:self.cellDelegate];
    }
    [cell setPlayer:[self.players objectAtIndex:indexPath.row]];
    CGRect frame = cell.frame;
    frame.size.height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    frame.size.width = self.frame.size.width;
    cell.frame = frame;
    return cell;    
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
