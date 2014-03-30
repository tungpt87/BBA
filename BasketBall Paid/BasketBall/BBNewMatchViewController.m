//
//  BBNewMatchViewController.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBNewMatchViewController.h"
#import "BBScoreCardViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "BBFullCourtView.h"
#import "BBReportCardViewController.h"
typedef enum {
    STATE_VALUE_DEFAULT = 0,
}STATE_VALUE;
@interface BBState : NSObject{
    STATE_VALUE _state;
    BOOL edited;
}
@property (nonatomic) STATE_VALUE state;
@property (nonatomic, readonly) BOOL edited;
@end
@implementation BBState
@synthesize state = _state;
@synthesize edited;

- (void)setState:(STATE_VALUE)state{
    _state = state;
    edited = YES;
}

- (STATE_VALUE)state{
    edited = NO;
    return _state;
}


@end
@interface BBNewMatchViewController (Privates)
- (void) endGame;
- (void) playerDidChoosedWithName:(NSString*)name number:(NSString*)number teamName:(NSString*)teamName;
- (void) playerDidChooseWithIndex:(NSInteger)playerIndex inTeamIndex:(NSInteger)teamIndex isOnAction:(BOOL)isOnAction;
@end
static BBState *state;
@implementation BBNewMatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View life circle
- (void)dealloc{
    [super dealloc];
    NSLog(@"NewMatch did dealloc");
    [_clockView setDelegate:nil];
    [leftTimeOut setDelegate:nil];
    [rightTimeOut setDelegate:nil];
    [teamA setDelegate:nil];
    [teamB setDelegate:nil];
    [actionBoxView_Scoring setDelegate:nil];
    [actionBoxView_Statistics setDelegate:nil];
    [actionBoxView_Freeshot setDelegate:nil];
    for (UIView *view in teamAPlayerView.subviews) {
        if ([view isKindOfClass:[BBPlayerView class]]) {
            [(BBPlayerView*)view setDelegate:nil];
        }
    }
    for (UIView *view in teamBPlayerView.subviews) {
        if ([view isKindOfClass:[BBPlayerView class]]) {
            [(BBPlayerView*)view setDelegate:nil];
        }
    }

    F_RELEASE(onEditingTeamName);
    
    F_RELEASE(editingPlayerView);
    
    F_RELEASE(bbAction);
    
    F_RELEASE(arrActions);
    
    F_RELEASE(matchId);
    
    F_RELEASE(matchDate);
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated{
        
    
    
    
        
    
        
    
    ///////Set delegate for playerView

}
- (void)viewDidLoad
{
    
    NSLog(@"New Match ViewDidLoad");
    [super viewDidLoad];
    state = [[BBState alloc] init];
    
    subbedQueue = dispatch_queue_create("PlayerSubbingQueue", nil);
    isFouled = NO;
    subbingCount = 0;
    shouldIgnoreSubOffFoulPlayer = NO;
    lastPlayerIndex = -1;
    previousDataHasLoaded = NO;
        
    isEnd = NO;
    
    isInFreeShot = NO;
    
    isStartANewMatch = YES;
    
    isStartANewPeriod = YES;
    
    isEditingFreeShot = NO;
    
    shouldStartWithLessThan5Players = NO;
    
    isSubbing = NO;
    
    isInitialLoadActionList = YES;
    
    shouldIgnoreTeamB = NO;
    
    isClockDisabled = NO;
    period = 1;
    numberOfIgnorance = 0;
    [btnDisableClock  setEnabled:NO];
    totalTimeOn = 0;
//    [tfPlayerNum setInputView:pickerView];
    if (isStartANewMatch) {
        matchDate = [[NSDate alloc] init];
        isEditingAction = NO;
        [leftDoneButton setEnabled:NO];
        [rightDoneButton setEnabled:NO];
//        period = 1;
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddhhmm"];
        matchId = [[dateFormatter stringFromDate:date] retain];
        F_RELEASE(dateFormatter);
    }

    

    [actionBoxParent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_clockView setDelegate:self];
    [leftFouls setTitle:LOCALIZE(LABELTITLE_FOUL)];
    [rightFouls setTitle:LOCALIZE(LABELTITLE_FOUL)];
    
    [leftTimeOut setDelegate:self];
    [rightTimeOut setDelegate:self];
    [leftTimeOut setEnable:NO];
    [rightTimeOut setEnable:NO];
    
    
    
    CGRect actionBoxFrame = actionBoxView_Scoring.frame;
    actionBoxFrame.origin.x = 0;
    actionBoxFrame.origin.y = 0;
    [actionBoxView_Scoring setFrame:actionBoxFrame];
    [actionBoxView_Statistics setFrame:actionBoxFrame];
    [actionBoxParent addSubview:actionBoxView_Freeshot];
    [actionBoxParent addSubview:actionBoxView_Scoring];
    [actionBoxParent addSubview:actionBoxView_Statistics];
    [actionBoxView_Statistics setEnable:NO];
    [actionBoxView_Scoring setEnable:NO];
    topActionBox = actionBoxView_Statistics;
    
    [teamAPlayerView reset];
    [teamBPlayerView reset];
    [teamAPlayerView setCellDelegate:self];
    [teamBPlayerView setCellDelegate:self];
    ////Set textfield accessoryviews
    [tfHiddenPlayerView setInputAccessoryView:inputAccessoryViewPlayer];
    [tfHiddenTeam setInputAccessoryView:inputAccessoryViewTeam];
    // Do any additional setup after loading the view from its nib.
    
    ///Gesture recognizer initial
        
    //////Add observer
    [self registerObserver];
    
    
    /////
    [teamA setDelegate:self];
    [teamB setDelegate:self];
    [actionBoxView_Scoring setDelegate:self];
    [actionBoxView_Statistics setDelegate:self];
    [actionBoxView_Freeshot setDelegate:self];
    [teamA setTeamName:DEFAULTNAME_TEAMA];
    [teamB setTeamName:DEFAULTNAME_TEAMB];
    [shotGraphicView setEnable:NO];
    [teamAPlayerView stop];
    [teamBPlayerView stop];
    
    
    //Initial array of actions those're done in the match
    arrActions = [[NSMutableArray alloc] init];
    
    
   
    [leftDoneButton setBackGroundImage:[UIImage imageNamed:@"done.png"]];
    [rightDoneButton setBackGroundImage:[UIImage imageNamed:@"done.png"]];
    [leftDoneButton setFlashingImage:[UIImage imageNamed:@"done_flashing.png"]];
    [rightDoneButton setFlashingImage:[UIImage imageNamed:@"done_flashing.png"]];
    [btnPeriodEnd setBackGroundImage:[UIImage imageNamed:@"periodend.png"]];
    [btnEnd setBackGroundImage:[UIImage imageNamed:@"gameend.png"]];
    [btnPeriodEnd setFlashingImage:[UIImage imageNamed:@"done_flashing.png"]];
    [btnEnd setFlashingImage:[UIImage imageNamed:@"done_flashing.png"]];
    
    
    
    
    [btnPeriodEnd addTarget:self
                     action:@selector(btnPeriodEndDidTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    [btnEnd addTarget:self
               action:@selector(btnEndDidTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    [rightDoneButton addTarget:self
                        action:@selector(btnDoneDidTapped:)
              forControlEvents:UIControlEventTouchUpInside];
    [leftDoneButton addTarget:self
                        action:@selector(btnDoneDidTapped:)
              forControlEvents:UIControlEventTouchUpInside];
    [btnPeriodEnd setEnabled:NO];
    [btnPeriodEnd toggleFlashing:NO];
    [btnEnd setEnabled:NO];
    [btnEnd toggleFlashing:NO];
    
    [editTimeOutView.layer setCornerRadius:10];
//    [editTimeOutView setBackgroundColor:[UIColor colorWithHexString:@"#368FB8"]];
    [editTimeOutView.layer setBorderWidth:3];
    [editTimeOutView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    NSString *instructionsHtml = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"instruction" ofType:@"html"]
                                                            encoding:NSUTF8StringEncoding
                                                               error:nil];
    [instructionWebView setOpaque:NO];
    [instructionWebView setBackgroundColor:[UIColor clearColor]];
    [instructionWebView loadHTMLString:instructionsHtml
                               baseURL:nil];
    
    NSString *teamAName = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_NewMatch_TeamNameA];
    NSString *teamBName = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_NewMatch_TeamNameB];

    if (teamAName) {
        [teamA setTeamName:teamAName];
    }
    
    if (teamBName) {
        [teamB setTeamName:teamBName];
    }

    NSArray *arrTeamAPlayer = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_NewMatch_PlayerListA];
    NSArray *arrTeamBPlayer = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_NewMatch_PlayerListB];
    if (arrTeamAPlayer) {
        [teamAPlayerView setPlayerInfoWithArray:arrTeamAPlayer];
    }
    if (arrTeamBPlayer) {
        [teamBPlayerView setPlayerInfoWithArray:arrTeamBPlayer];
    }
    
    
    if (arrTeamAPlayer) {
        previousDataHasLoaded = YES;
    }
    
    
    if (isStartANewMatch) {
        isEditingAction = NO;
        [leftDoneButton setEnabled:NO];
        [rightDoneButton setEnabled:NO];
        //        period = 1;
        [_clockView stop];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddhhmm"];
        matchId = [[dateFormatter stringFromDate:date] retain];
        F_RELEASE(dateFormatter);
        
        NSNumber *duration = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKey_Duration];
        if (duration) {
            [_clockView setRemainTime:[duration floatValue]];
        }
        else {
            [_clockView setRemainTime:0];
        }
        
        [shotGraphicView setEnable:NO];
        
        
        
        //Initial array of actions those're done in the match
        
        
    }

    [self checkQuickSave];
//    BBPlayer *player = [[BBPlayer alloc] init];
//    [player setNumber:@"1"];
//    [player setName:@"Tung Pham"];
//    [teamAPlayerView addPlayer:player];
//    [teamAPlayerView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Methods
- (NSDictionary*) saveMatchData{
    NSMutableDictionary *match = nil;
    if (arrActions) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            BBActionRef *action = (BBActionRef*)evaluatedObject;
            if (action.actionType != ACTION_TYPE_QRTEND && action.actionType != ACTION_TYPE_QRTSTART) {
                return YES;
            } else {
                return NO;
            }
        }];
        NSInteger count = [[arrActions filteredArrayUsingPredicate:predicate] count];
        if (count > 0) {
            isEnd = YES;
            match = [NSMutableDictionary dictionary];
            NSArray *teamNames = [NSArray arrayWithObjects:teamA.teamName,teamB.teamName, nil];
            NSMutableArray *teamAPlayers = [NSMutableArray arrayWithArray:[teamAPlayerView arrayOfPlayer]];
            NSMutableArray *teamBPlayers = [NSMutableArray arrayWithArray:[teamBPlayerView arrayOfPlayer]];
                        
            
            NSMutableArray *actions = [NSMutableArray array];
            for (int i=0; i < arrActions.count; ++i) {
                BBActionRef *action = (BBActionRef*)[arrActions objectAtIndex:i];
                if (!action.isReplaced) {
                    [actions addObject:[action dictionary]];
                }
            }
            
            NSString *strDate = [CommonUtils dateTimeStringWithDate:matchDate
                                                       formatString:@"MMMM dd yyyy hh:mm"];
            [match setObject:teamNames forKey:kKey_TeamName];
            [match setObject:teamAPlayers forKey:kKey_Player_TeamA];
            [match setObject:teamBPlayers forKey:kKey_Player_TeamB];
            [match setObject:actions forKey:kKey_Actions];
            [match setObject:[NSNumber numberWithFloat:totalTimeOn] forKey:kKey_Match_TotalTimeOn];
            [match setObject:strDate
                      forKey:kKey_NewMatch_Date];
            [match setObject:[NSNumber numberWithBool:isClockDisabled]
                      forKey:kKey_Match_IsClockDisabled];
        }
        else {
            [self dismissModalViewControllerAnimated:YES];
            F_RELEASE(bbAction);
            
        }
    }
    return match;
}

- (IBAction)showQuickStatistic:(id)sender{
    if (![_clockView isRunning]) {
        NSMutableDictionary *match = [self saveMatchData];
        [match setObject:matchId forKey:kKey_Match_MatchName];
        BBReportCardViewController *reportCard = [[BBReportCardViewController alloc] initWithDictionary:match];
        UIBarButtonItem *barDone = [[UIBarButtonItem alloc] initWithTitle:kButtonTitleReturnToMatch
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:reportCard
                                                                   action:@selector(dismissModalViewControllerAnimated:)];
        reportCard.navigationItem.rightBarButtonItem = barDone;
        [barDone release];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:reportCard];
        [navController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [reportCard release];
        [self presentModalViewController:navController animated:YES];
        [navController release];
    }
}
- (void) ignoreTeamB{
    shouldIgnoreTeamB = YES;
    BBPlayer *player = [[BBPlayer alloc] init];
    [player setNumber:@"-1"];
    [player setName:@""];
    [player setIsSelected:YES];
    [teamBPlayerView setPlayers:[NSArray arrayWithObject:player]];
    
    [_clockView start];

}
#pragma mark - IBAction
- (IBAction)closeInstructions:(id)sender{
    [CommonUtils dismissPopUpView];
}
- (IBAction)teamForTimeOut:(id)sender{
    bbAction.teamIndex = [(UIButton*)sender tag];
    if (bbAction.teamIndex == 0) {
        [leftTimeOut addValue];
    } else {
        [rightTimeOut addValue];
    }
    [self saveEditedAction];
    [self doneEditingAction];

    [CommonUtils dismissPopUpView];
}
- (IBAction)showInstructions:(id)sender{
    [CommonUtils displayPopUpWithContentView:instructionView];
}
- (IBAction)deleteEditingAction:(id)sender{
    if (arrActions && bbAction) {
        NSInteger index = [arrActions indexOfObject:bbAction];
        BBActionRef *editingAction = nil;
        if (index > 0) {
            editingAction = [arrActions objectAtIndex:index-1];
            [arrActions removeObject:editingAction];
        }
        [arrActions removeObject:bbAction];
        bbAction = nil;
    }
    [leftDoneButton setEnabled:NO];
    [rightDoneButton setEnabled:NO];
    [self doneEditingAction];
}
- (IBAction)teamASub:(id)sender{
    isSubbing = YES;
    [teamAPlayerView stop];
    [teamAPlayerView setEnable:YES];
    [teamAPlayerView setFlashing:YES];
    [actionBoxView_Freeshot setFlashing:NO];
    [actionBoxView_Freeshot setEnable:NO];
    [actionBoxView_Scoring setFlashing:NO];
    [actionBoxView_Scoring setEnable:NO];
    [actionBoxView_Statistics setFlashing:NO];
    [actionBoxView_Statistics setEnable:NO];
    [shotGraphicView setEnable:NO];
    [leftDoneButton setEnabled:YES];
    [leftDoneButton toggleFlashing:YES];
    [rightDoneButton setEnabled:YES];
    [rightDoneButton toggleFlashing:YES];
    [btnEditCheck setEnabled:NO];
    [btnRedoLast setEnabled:NO];
    [teamAPlayerView toggleAddPlayerButtonVisible:YES];
    [_clockView setUserInteractionEnabled:NO];
    subbingCount ++;
}

- (IBAction)teamBSub:(id)sender{
    isSubbing = YES;
    [teamBPlayerView stop];
    [teamBPlayerView setEnable:YES];
    [teamBPlayerView setFlashing:YES];
    [actionBoxView_Freeshot setFlashing:NO];
    [actionBoxView_Freeshot setEnable:NO];
    [actionBoxView_Scoring setFlashing:NO];
    [actionBoxView_Scoring setEnable:NO];
    [actionBoxView_Statistics setFlashing:NO];
    [actionBoxView_Statistics setEnable:NO];
    [shotGraphicView setEnable:NO];
    [leftDoneButton setEnabled:YES];
    [rightDoneButton setEnabled:YES];
    [btnEditCheck setEnabled:NO];
    [btnRedoLast setEnabled:NO];
    if (!shouldIgnoreTeamB) {
        [teamBPlayerView toggleAddPlayerButtonVisible:YES];
    }
    [_clockView setUserInteractionEnabled:NO];
    subbingCount ++;
}
- (IBAction)btnDoneDidTapped:(id)sender{
    if (!isSubbing) {
        ACTION_TYPE actionType = bbAction.actionType;
        [self doneAction];
        if ((actionType == ACTION_TYPE_TWOMADE || actionType == ACTION_TYPE_THREEMADE || actionType == ACTION_TYPE_TWOMISS) && isFouled && isTechFoulByTeam) {
            [self startAFreeShot];
        }
    } else {
        [self doneSubbing];
    }
    [leftDoneButton toggleFlashing:NO];
    [rightDoneButton toggleFlashing:NO];
}

- (IBAction)btnLeftDoneTapped:(id)sender{
    [self btnDoneDidTapped:nil];
}

- (void) doneSubbing{
//    [self doneSubbing];
    if (!teamAPlayerView.isStart) {
        if (teamAPlayerView.arrayOfSelectedPlayer.count > 5) {
            [CommonUtils displayAlertWithTitle:kTitle_SubbingFailed
                                       message:kMessageSubbingFailed
                                   cancelTitle:kButtonTitleOk
                                           tag:ALERTVIEW_TAG_SUBBING_FAILED
                                      delegate:self
                             otherButtonTitles:nil];
            [self teamASub:nil];
            return;
        }
        [teamAPlayerView doneSubbing];
        [teamAPlayerView start];
        [teamAPlayerView setFlashing:NO];
    } 
    if (!teamBPlayerView.isStart) {
        if (teamBPlayerView.arrayOfSelectedPlayer.count > 5) {
            [CommonUtils displayAlertWithTitle:kTitle_SubbingFailed
                                       message:kMessageSubbingFailed
                                   cancelTitle:kButtonTitleOk
                                           tag:ALERTVIEW_TAG_SUBBING_FAILED
                                      delegate:self
                             otherButtonTitles:nil];
            [self teamBSub:nil];
            return;
        }
        [teamBPlayerView doneSubbing];
        [teamBPlayerView start];
        [teamBPlayerView setFlashing:NO];
    }
    [self toggleAddPlayerButton:NO];
    isSubbing = NO;

    [btnEditCheck setEnabled:YES];
    [btnRedoLast setEnabled:YES];
    subbingCount --;
    if (_clockView.remainTime > 0) {
        [actionBoxView_Scoring setEnable:YES];
        [actionBoxView_Scoring setFlashing:YES];
        [actionBoxView_Statistics setEnable:YES];
        [actionBoxView_Statistics setFlashing:YES];
    } else {
        [teamAPlayerView stop];
        [teamBPlayerView stop];
        if (!bbAction && period < 4 && period > 0) {
            [btnPeriodEnd setEnabled:YES];
            [btnPeriodEnd toggleFlashing:YES];
        }
        if (period % 2 == 0 && period > 0) {
            [btnEnd setEnabled:YES];
            [btnEnd toggleFlashing:YES];
        }
        [self completeTimeOn];
        for (BBPlayer *player in teamAPlayerView.players) {
            [player endOfPeriod];
        }
        
        for (BBPlayer *player in teamBPlayerView.players) {
            [player endOfPeriod];
        }
        

        
        [leftSub setHidden:YES];
        [rightSub setHidden:YES];
    }
    if (subbingCount == 0) {
        [_clockView setUserInteractionEnabled:YES];
    }
    if (isClockDisabled){
        [self disableClock];
    }
}
- (void) doneAction{
    NSInteger playerIndex = bbAction.playerIndex;
    if (!isEditingAction) {
        ACTION_TYPE actionType = bbAction.actionType;
        NSInteger playerIndex = bbAction.playerIndex;
        [self saveAction];
        [shotGraphicView setEnable:NO];
        if (!isFouled) {
            [_clockView setUserInteractionEnabled:YES];
            [self doneNormalAction];
        } else {
            if (actionType == ACTION_TYPE_FOUL || actionType == ACTION_TYPE_FOUL1 || actionType == ACTION_TYPE_FOUL2 || actionType == ACTION_TYPE_FOUL3 || actionType == ACTION_TYPE_TECHFOUL) {
                switch (actionType) {
                    case ACTION_TYPE_FOUL:
                        numberOfFreeShots = 0;
                        break;
                    case ACTION_TYPE_FOUL1:
                        numberOfFreeShots = kFoul1FreeShots;
                        break;
                    case ACTION_TYPE_FOUL2:
                        numberOfFreeShots = kFoul2FreeShots;
                        break;
                    case ACTION_TYPE_FOUL3:
                        numberOfFreeShots = kFoul3FreeShots;
                        break;
                    case ACTION_TYPE_TECHFOUL:
                        numberOfFreeShots = kTechFoulFreeShots;
                        break;
                    default:
                        break;
                }
                if (actionType == ACTION_TYPE_TECHFOUL && playerIndex == 0) {
                    isTechFoulByTeam = YES;
                }

                [self doneAFoul:actionType];
            } else if (actionType == ACTION_TYPE_ONEMADE || actionType == ACTION_TYPE_ONEMISS){
                lastPlayerIndex = playerIndex;
                [self startAFreeShot];
                [btnRedoLast setEnabled:YES];
            }
            else if (actionType == ACTION_TYPE_TWOMADE || actionType == ACTION_TYPE_THREEMADE){
                lastPlayerIndex = playerIndex;
                [self doneFieldShotAfterFoul];
                [btnRedoLast setEnabled:YES];
            }
            
        }


    } else if (bbAction){
        @try {
            [self saveEditedAction];
            [_clockView setUserInteractionEnabled:YES];
            
            [self doneEditingAction];
            [shotGraphicView setEnable:NO];
        }
        @catch (NSException *exception) {
            NSLog(@"Done editing action exception :%@",exception.debugDescription);
        }
        @finally {

        }
    }
    [teamA setIsInTechFoul:NO];
    [teamB setIsInTechFoul:NO];
    if (_clockView.remainTime == 0 && period > 0 && period < 4) {
        [btnPeriodEnd setEnabled:YES];
    }

    [leftDoneButton setEnabled:NO];
    [rightDoneButton setEnabled:NO];
}
- (void) startClock{
    [_clockView start];
}

- (void) changeToDisabledClockMode{
    
}
- (void) disableClock{
    [_clockView disable];
    if (teamBPlayerView.arrayOfSelectedPlayer.count == 0 && !shouldIgnoreTeamB) {
        [self ignoreTeamB];
    }
    [btnDisableClock setEnabled:NO];
    [self changeToDisabledClockMode];
    isClockDisabled = YES;
    [actionBoxView_Scoring setEnable:YES];
    [actionBoxView_Scoring setFlashing:YES];
    [actionBoxView_Statistics setEnable:YES];
    [actionBoxView_Statistics setFlashing:YES];
    [teamAPlayerView start];
    [teamBPlayerView start];
    [btnPeriodEnd toggleFlashing:YES];
    [btnPeriodEnd setEnabled:YES];
    [leftSub setHidden:NO];
    [rightSub setHidden:NO];
    if (isStartANewMatch || isStartANewPeriod) {
        [self initialAction];
        [bbAction setActionType:ACTION_TYPE_QRTSTART];
        [bbAction setActionTime:_clockView.remainTime];
        [self saveAction];
        isStartANewPeriod = NO;
        
        for (BBPlayer *player in teamAPlayerView.players) {
            if (player.isSelected) {
                [player addAppearsAtHalf:(period < 3)?PLAYER_APPEARANCE_FIRSTHALF:PLAYER_APPEARANCE_SECONDHALF];
            }
        }
        for (BBPlayer *player in teamBPlayerView.players) {
            if (player.isSelected) {
                [player addAppearsAtHalf:(period < 3)?PLAYER_APPEARANCE_FIRSTHALF:PLAYER_APPEARANCE_SECONDHALF];
            }
        }
        [self addSubbingAction];
        isStartANewMatch = NO;
        isStartANewPeriod = NO;
    }
}

- (IBAction)btnEndDidTapped:(id)sender{
//    isStartANewMatch = YES;
    //////TODO: Save current date of player list and team name into
    if ([_clockView remainTime] == kDisabledValue){
        totalTimeOn = kDisabledValue;
    } else {
         totalTimeOn = period * [(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKey_Duration] floatValue];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[teamAPlayerView arrayOfPlayer]
                                               forKey:kKey_NewMatch_PlayerListA];
    [[NSUserDefaults standardUserDefaults] setObject:[teamBPlayerView arrayOfPlayer]
                                              forKey:kKey_NewMatch_PlayerListB];
    [[NSUserDefaults standardUserDefaults] setObject:[teamA teamName]
                                              forKey:kKey_NewMatch_TeamNameA];
    [[NSUserDefaults standardUserDefaults] setObject:[teamB teamName]
                                              forKey:kKey_NewMatch_TeamNameB];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self unregisterObserver];
    if ((_clockView.remainTime == 0 && !isStartANewPeriod) || _clockView.remainTime == kDisabledValue) {
        isStartANewPeriod = YES;
        [self initialAction];
        if (bbAction) {
            [bbAction setActionType:ACTION_TYPE_QRTEND];
            [bbAction setActionTime:_clockView.remainTime];
        }
        [self saveAction];
    }
    if (isEditingAction) {
        [self doneEditingAction];
    }
//    [_clockView stop];

    NSDictionary *match = nil;
    match = [self saveMatchData];
    if (match) {
        BBScoreCardViewController *scoreCardView = [[BBScoreCardViewController alloc] initWithMatchDictionary:match defaultName:matchId];
        
        [scoreCardView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
        [self presentModalViewController:scoreCardView
                                animated:YES];
        [scoreCardView release];
    }
    [DataManager userDefaultRemoveObjectForKey:kKey_QuickSave];
}
- (IBAction)disableClockDidTap:(id)sender{
    [CommonUtils displayAlertWithTitle:nil
                               message:kMessage_DisableClock
                           cancelTitle:@"No"
                                   tag:ALERTVIEW_TAG_DISABLE_CLOCK
                              delegate:self
                     otherButtonTitles:@"Yes"];
}


- (IBAction)btnRedoDidTapped:(id)sender{
    isEditingFreeShot = NO;
    BBActionRef *lastAction = nil;
    if (arrActions) {
        for (int i = arrActions.count - 1; i>=0 ; --i) {
            BBActionRef *action = (BBActionRef*)[arrActions objectAtIndex:i];
            if (action.actionType != ACTION_TYPE_QRTEND && action.actionType != ACTION_TYPE_QRTSTART && action.actionType != ACTION_TYPE_PLAYERON && action.actionType != ACTION_TYPE_PLAYEROFF) {
                lastAction = action;
                break;
            }
        }
        if (lastAction) {
            [self editAction:lastAction];
        }
    }
}

- (IBAction)btnEditDidTapped:(id)sender{
//    NSMutableArray *arrNames = [NSMutableArray array];
//    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//        BBAction *action = (BBAction*)evaluatedObject;
//        if (action.actionType != ACTION_TYPE_QRTEND && action.actionType != ACTION_TYPE_QRTSTART && action.actionType != ACTION_TYPE_TIMEOUT) {
//            return YES;
//        } else {
//            return NO;
//        }
//    }];
//    
//    NSArray *arrValidActions = [arrActions filteredArrayUsingPredicate:predicate];
    [self displayActionsList];

}

- (IBAction)btnPeriodEndDidTapped:(id)sender{
    [teamAPlayerView setUserInteractionEnabled:YES];
    [teamBPlayerView setUserInteractionEnabled:YES];
    totalTimeOn += [(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKey_Duration] floatValue];
    [self doneEditingAction];
    [_clockView setUserInteractionEnabled:YES];
    [btnPeriodEnd setEnabled:NO];
    [btnPeriodEnd toggleFlashing:NO];
    [btnEnd setEnabled:NO];
    [btnEnd toggleFlashing:NO];
    isStartANewPeriod = YES;
    [self initialAction];
    if (bbAction) {
        [bbAction setActionType:ACTION_TYPE_QRTEND];
        [bbAction setActionTime:_clockView.remainTime];
    }
    [self saveAction];
    [_clockView prepareForNextPeriod:nil];
    
    period ++;
    [[DataManager defaultManager] setPeriod:period];
    NSString *periodString;
    switch (period) {
            
        case 1:
            periodString = @"1st";
            break;
        case 2:
            periodString = @"2nd";
            break;
            
        case 3:
            periodString = @"3rd";
            break;
        case 4:
            periodString = @"4th";
            break;
        default:
            periodString = @"";
            break;
    }
    [lblPeriod setText:periodString];
    F_RELEASE(bbAction);
//        [self doneEditingAction];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:LOCALIZE(kMessageConfirmResetTeamFouls)
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:LOCALIZE(kButtonTitleYes),LOCALIZE(kButtonTitleNo), nil];
    [alert setTag:ALERTVIEW_TAG_RESETTEAMFOUL];
    [alert show];
    [self subOnPlayerWhenStartANewPeriod];
    F_RELEASE(alert);
    [_clockView setUserInteractionEnabled:YES];
    [teamAPlayerView setFlashing:NO];
    [teamBPlayerView setFlashing:NO];
    [teamAPlayerView stop];
    [teamBPlayerView stop];
    //        [actionBoxView_Scoring setEnable:NO];
    //        [actionBoxView_Statistics setEnable:NO];
    [actionBoxView_Scoring setFlashing:NO];
    [actionBoxView_Statistics setFlashing:NO];
    [actionBoxView_Scoring setEnable:YES
                            forTypes:[NSArray arrayWithObject:[NSNumber numberWithInt:ACTION_TYPE_TECHFOUL]]];
    [actionBoxView_Statistics setEnable:YES
                               forTypes:[NSArray arrayWithObject:[NSNumber numberWithInt:ACTION_TYPE_TECHFOUL]]];
    [self toggleAddPlayerButton:YES];
    [leftDoneButton toggleFlashing:NO];
    [rightDoneButton toggleFlashing:NO];

    
    ////If Clock is disabled
    if (isClockDisabled) {
        [self disableClock];
    }
    if (isClockDisabled && period % 2 == 0){
        [btnEnd setEnabled:YES];
        [btnEnd toggleFlashing:YES];
    }

}

- (IBAction)btnSwitchDidTap:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:actionBoxParent cache:YES];
    [shotGraphicView setAlpha:1-shotGraphicView.alpha];
//    [self.view addSubview:tempView];
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:1.0];
    if (topActionBox == actionBoxView_Scoring) {
        [actionBoxParent bringSubviewToFront:actionBoxView_Statistics];
        topActionBox = actionBoxView_Statistics;
    } else {
        [actionBoxParent bringSubviewToFront:actionBoxView_Scoring];
        topActionBox = actionBoxView_Scoring;
    }

    [UIView commitAnimations];


}
#pragma mark - Private Methods
- (void) loadPreviousMatchData{
    //TODO: Load
    if (previousMatchData) {
        isLoadingPreviousData = YES;
        NSArray *arrTeamA = [previousMatchData objectForKey:kKey_QuickSave_TeamA];
        NSArray *arrTeamB = [previousMatchData objectForKey:kKey_QuickSave_TeamB];
        NSString *teamNameA = [previousMatchData objectForKey:kKey_QuickSave_TeamNameA];
        NSString *teamNameB = [previousMatchData objectForKey:kKey_QuickSave_TeamNameB];
        NSInteger teamFoulA = [[previousMatchData objectForKey:kKey_QuickSave_TeamFoulA] intValue];
        NSInteger teamFoulB = [[previousMatchData objectForKey:kKey_QuickSave_TeamFoulB] intValue];
        NSInteger timeOutA = [[previousMatchData objectForKey:kKey_QuickSave_TimeOutA] intValue];
        NSInteger timeOutB = [[previousMatchData objectForKey:kKey_QuickSave_TimeOutB] intValue];
        NSInteger teamScoreA = [[previousMatchData objectForKey:kKey_QuickSave_TeamScoreA] intValue];
        NSInteger teamScoreB = [[previousMatchData objectForKey:kKey_QuickSave_TeamScoreB] intValue];
        CGFloat remainingTime = [[previousMatchData objectForKey:kKey_QuickSave_RemainingTime] floatValue];
        
        CGFloat duration = [[previousMatchData objectForKey:kKey_QuickSave_Duration] floatValue];
        NSArray *actionList = [previousMatchData objectForKey:kKey_QuickSave_ActionList];
        
        shouldIgnoreTeamB = [[previousMatchData objectForKey:kKey_QuickSave_ShouldIgnoreTeamB] boolValue];
        isClockDisabled = [[previousMatchData objectForKey:kKey_QuickSave_DisableClock] boolValue];

        [_clockView setRemainTime:remainingTime];
        [_clockView setDurationOfAPeriod:duration];
        [teamAPlayerView setPlayerInfoWithArray:arrTeamA];
        [teamBPlayerView setPlayerInfoWithArray:arrTeamB];
        [teamA setTeamName:teamNameA];
        [teamB setTeamName:teamNameB];
        [leftFouls setValue:teamFoulA];
        [rightFouls setValue:teamFoulB];
        [leftTimeOut setValue:timeOutA];
        [rightTimeOut setValue:timeOutB];
        [scoreBoard setValue:teamScoreA ForIndex:0];
        [scoreBoard setValue:teamScoreB ForIndex:1];
        
        arrActions = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in actionList) {
            BBActionRef *action = [[BBActionRef alloc] initWithDictionary:dict];
            [arrActions  addObject:action];
            F_RELEASE(action);
        }
        period = [[previousMatchData objectForKey:kKey_QuickSave_Period] intValue];
        NSString *periodString;
        switch (period) {
                
            case 1:
                periodString = @"1st";
                break;
            case 2:
                periodString = @"2nd";
                break;
                
            case 3:
                periodString = @"3rd";
                break;
            case 4:
                periodString = @"4th";
                break;
            default:
                periodString = @"";
                break;
        }
        [lblPeriod setText:periodString];
        if ([_clockView remainTime] == 0) {
            [self clockViewDidEndOfPeriod:_clockView];
        }
        if (isClockDisabled) {
            [self disableClock];
        }
        previousDataHasLoaded = YES;
        isLoadingPreviousData = NO;
    }
}
- (void) checkQuickSave{
    previousMatchData =[[DataManager userDefaultObjectForKey:kKey_QuickSave] retain];
    NSLog(@"Previous data: %@",previousMatchData);
    [self loadPreviousMatchData];
    if (previousDataHasLoaded) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:LOCALIZE(kActionSheetTitle_DeleteTeamInfo)
                                                       delegate:self
                                              cancelButtonTitle:LOCALIZE(kButtonTitleKeepBoth)
                                              otherButtonTitles:LOCALIZE(kButtonTitleDeleteA),LOCALIZE(kButtonTitleDeleteB),LOCALIZE(kButtonTitleDeleteAll), nil];
        [alert setTag:ALERTVIEW_TAG_DELETEINFOTEAM];
        [alert show];
        [alert release];
    }

    if (previousMatchData) {

    } else {
    }
}
- (void) quickSave{
    NSMutableDictionary *dictQuickSave = [NSMutableDictionary dictionary];
    [dictQuickSave setObject:[teamAPlayerView quickSaveData]
                      forKey:kKey_QuickSave_TeamA];
    [dictQuickSave setObject:[teamBPlayerView quickSaveData]
                      forKey:kKey_QuickSave_TeamB];
    [dictQuickSave setObject:[NSNumber numberWithInt:[leftFouls value]]
                      forKey:kKey_QuickSave_TeamFoulA];
    [dictQuickSave setObject:[NSNumber numberWithInt:[rightFouls value]]
                      forKey:kKey_QuickSave_TeamFoulB];
    [dictQuickSave setObject:[NSNumber numberWithInt:[leftTimeOut value]]
                      forKey:kKey_QuickSave_TimeOutA];
    [dictQuickSave setObject:[NSNumber numberWithInt:[rightTimeOut value]]
                      forKey:kKey_QuickSave_TimeOutB];
    [dictQuickSave setObject:[NSNumber numberWithInt:[scoreBoard valueForIndex:0]]
                      forKey:kKey_QuickSave_TeamScoreA];
    [dictQuickSave setObject:[NSNumber numberWithInt:[scoreBoard valueForIndex:1]]
                      forKey:kKey_QuickSave_TeamScoreB];
    [dictQuickSave setObject:[NSNumber numberWithFloat:[_clockView remainTime]]
                      forKey:kKey_QuickSave_RemainingTime];
    [dictQuickSave setObject:[NSNumber numberWithInt:period]
                      forKey:kKey_QuickSave_Period];
    [dictQuickSave setObject:teamA.teamName
                      forKey:kKey_QuickSave_TeamNameA];
    [dictQuickSave setObject:teamB.teamName
                      forKey:kKey_QuickSave_TeamNameB];
    [dictQuickSave setObject:[NSNumber numberWithFloat:[_clockView durationOfAPeriod]]
                      forKey:kKey_QuickSave_Duration];
    [dictQuickSave setObject:[NSNumber numberWithBool:shouldIgnoreTeamB]
                      forKey:kKey_QuickSave_ShouldIgnoreTeamB];
    [dictQuickSave setObject:[NSNumber numberWithBool:isClockDisabled]
                      forKey:kKey_QuickSave_DisableClock];
    
    NSMutableArray *arrDictActions = [NSMutableArray array];
    for (BBActionRef *action in arrActions) {
        [arrDictActions addObject:[action dictionary]];
    }
    [dictQuickSave setObject:arrDictActions
                      forKey:kKey_QuickSave_ActionList];
    [DataManager setUserDefaultObject:dictQuickSave
                               forKey:kKey_QuickSave];
}
- (void) showFullCourt:(NSNotification*)notification{
    [CommonUtils displayPopUpWithContentView:[BBFullCourtView shareView]];
}
- (void) registerObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerViewDidLongPressed:)
                                                 name:kNotificationPlayerViewDidLongPressed
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shotPinDidChangeValue:)
                                                 name:kNotificationShotPinDidChangeValue
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shotPinDidRemove:)
                                                 name:kNotificationShotPinDidRemoveFromSuperView
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidTap:)
                                                 name:kNotificationPlayerDidTap
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkTeamFoul)
                                                 name:kNotificationShouldCheckTeamFoul
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerSubbed:)
                                                 name:kNotificationPlayerSubbed
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeContMode:)
                                                 name:kNotificationClockViewDidChangeContMode
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidSelected:)
                                                 name:kNotificationPlayerDidSelected
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(teamFoulReachedLimit:)
                                                 name:kNotificationTeamFoulReachedLimit
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showFullCourt:)
                                                 name:kNotificationShowFullCourt
                                               object:nil];
}
- (void) unregisterObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:kNotificationShowFullCourt
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:kNotificationPlayerViewDidLongPressed
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:kNotificationShotPinDidChangeValue
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:kNotificationShotPinDidRemoveFromSuperView
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:kNotificationPlayerDidTap
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:kNotificationShouldCheckTeamFoul
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:kNotificationPlayerSubbed
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:kNotificationClockViewDidChangeContMode
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:kNotificationPlayerDidSelected
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:kNotificationTeamFoulReachedLimit
                                               object:nil];

}

- (void) teamFoulReachedLimit:(NSNotification*)notif{
    [CommonUtils displayAlertWithTitle:nil
                               message:kMessageATeamReachLimit
                           cancelTitle:LOCALIZE(kButtonTitleOk)
                                   tag:ALERTVIEW_TAG_TEAM_REACH_LIMIT
                              delegate:self
                     otherButtonTitles:nil];
}
- (void) checkTeamFoul{
    NSInteger foulLimit = [DataManager teamFoulDangerLimit];
    if (leftFouls.value >= foulLimit || rightFouls.value >= foulLimit) {
        BBActionView *actionView = (BBActionView*)[actionBoxView_Statistics viewWithTag:ACTION_TYPE_FOUL2];
        [actionView setImage:[UIImage imageNamed:@"foul2x1.png"]
                    forState:UIControlStateNormal];
        [actionView setImage:[UIImage imageNamed:@"foul2x2.png"] 
                    forState:UIControlStateSelected];
        actionView = (BBActionView*)[actionBoxView_Scoring viewWithTag:ACTION_TYPE_FOUL2];
        [actionView setImage:[UIImage imageNamed:@"foul2x1_scoring.png"]
                    forState:UIControlStateNormal];
        [actionView setImage:[UIImage imageNamed:@"foul2x2_scoring.png"] 
                    forState:UIControlStateSelected];
    } else {
        BBActionView *actionView = (BBActionView*)[actionBoxView_Statistics viewWithTag:ACTION_TYPE_FOUL2];
        [actionView setImage:[UIImage imageNamed:@"foul21.png"]
                    forState:UIControlStateNormal];
        [actionView setImage:[UIImage imageNamed:@"foul22.png"] 
                    forState:UIControlStateSelected];
        actionView = (BBActionView*)[actionBoxView_Scoring viewWithTag:ACTION_TYPE_FOUL2];
        [actionView setImage:[UIImage imageNamed:@"foul21_scoring.png"]
                    forState:UIControlStateNormal];
        [actionView setImage:[UIImage imageNamed:@"foul22_scoring.png"] 
                    forState:UIControlStateSelected];
    }
}
- (void) transformIntoFreeshot{
    NSLog(@"Transform into free shot");
    isInFreeShot = YES;
    [UIView beginAnimations:nil context:nil]; 
    [UIView setAnimationDuration:0.5]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:actionBoxParent cache:YES];
    //    [self.view addSubview:tempView]; 
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:1.0];
    [actionBoxParent bringSubviewToFront:actionBoxView_Freeshot];
    [UIView commitAnimations];
    ////////////////////
}
- (void) transformIntoActionBox{
    if (isInFreeShot) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:actionBoxParent cache:YES];
        //    [self.view addSubview:tempView];
        [UIView commitAnimations];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:1.0];
        [actionBoxParent bringSubviewToFront:topActionBox];
        [UIView commitAnimations];
    }
    ////////////////////

}
- (void) saveEditedAction{
    if (bbAction) {
        NSInteger index = [arrActions indexOfObject:bbAction]; 
        if (index > 0 && index < arrActions.count){
            BBActionRef *editedAction = (BBActionRef*)[arrActions objectAtIndex:index-1];
            ///For comparing between bbaction and EditedAction
            [bbAction setIsSaved:YES];
            NSInteger point = 0;
            if (bbAction.actionType == ACTION_TYPE_ONEMADE) {
                point = 1;
            } else if (bbAction.actionType == ACTION_TYPE_TWOMADE){
                point = 2;
            } else if (bbAction.actionType == ACTION_TYPE_THREEMADE){
                point = 3;
            }
            [scoreBoard addValue:point
                        forIndex:bbAction.teamIndex];
            BBPlayerTableView *teamView;
            if (bbAction.teamIndex == 0) {
                teamView = teamAPlayerView;
            } else {
                teamView = teamBPlayerView;
            }
            
            if (bbAction.playerIndex > 0) {
                BBPlayer *player = [teamView playerWithIndex:bbAction.playerIndex];
                [player addScore:point];
            }
            if (bbAction.actionType == ACTION_TYPE_FOUL || bbAction.actionType == ACTION_TYPE_TECHFOUL || bbAction.actionType == ACTION_TYPE_FOUL1 || bbAction.actionType == ACTION_TYPE_FOUL2 || bbAction.actionType == ACTION_TYPE_FOUL3){
                BBFoulView *teamFoul = nil;
                if (bbAction.teamIndex == 0) {
                    teamFoul = leftFouls;
                } else {
                    teamFoul = rightFouls;
                }
                
                if (bbAction.playerIndex > 0) {
                    BBPlayer *player = [teamView playerWithIndex:bbAction.playerIndex];
                    [player addFoul];
                }
                [teamFoul addValue];
                if (bbAction.actionType == ACTION_TYPE_TECHFOUL) {
                    if (bbAction.playerIndex > 0) {
                        BBPlayer *player = [teamView playerWithIndex:bbAction.playerIndex];
                        [player addTechFoul];
                    }

                }
            }

            if (editedAction) {
                if ([bbAction isEqual:editedAction]) {
                    
                    [arrActions removeObjectAtIndex:index];
//                    F_RELEASE(bbAction);
                }else {
                    [editedAction setIsReplaced:YES];
                }
            }
            bbAction = nil;
        }

    }
}
- (void) doneNormalAction{
    if (_clockView.isRunning || _clockView.remainTime == 0) {
        [teamAPlayerView start];
        [teamAPlayerView setEnable:NO];
        [teamAPlayerView setFlashing:NO];
        [teamBPlayerView start];
        [teamBPlayerView setEnable:NO];
        [teamBPlayerView setFlashing:NO];
        [actionBoxView_Scoring setFlashing:YES];
        [actionBoxView_Scoring setEnable:YES];
        [actionBoxView_Statistics setFlashing:YES];
        [actionBoxView_Statistics setEnable:YES];
    } else if (_clockView.remainTime > 0){
        [teamAPlayerView stop];
        [teamBPlayerView stop];
//        [actionBoxView_Statistics setEnable:NO];
        [actionBoxView_Statistics setFlashing:NO];
//        [actionBoxView_Scoring setEnable:NO];
        [actionBoxView_Scoring setFlashing:NO];
        [_clockView setFlashing:YES];
    }
    [_clockView setUserInteractionEnabled:YES];
    [btnRedoLast setEnabled:YES];
    [btnEditCheck setEnabled:YES];
    if (isClockDisabled) {
        [self disableClock];
    }
    
}

- (void) doneAFoul:(ACTION_TYPE)actionType{
    BBPlayerTableView *team = nil;
    if (freeShotTeamIndex == 0) {
        team = teamAPlayerView;
    } else{
        team = teamBPlayerView;
    }
    if (team.arrayOfSelectedPlayer.count > 0) {
        if (actionType == ACTION_TYPE_FOUL1) {
            [self startFieldMade];
        } else {
            if (numberOfFreeShots > 0) {
                [teamAPlayerView start];
                [teamBPlayerView start];
                [self transformIntoFreeshot];
                [self startAFreeShot];
        } else {
                [self doneAFreeShot];
                isFouled = NO;
                isInFreeShot = NO;
                numberOfFreeShots = -1;
                freeShotCount = 0;
                freeShotTeamIndex = -1;
            }
        }

    } else{
        isFouled = NO;
        freeShotTeamIndex = -1;
        numberOfFreeShots = 0;
        [self doneAFreeShot];
    }
    if (numberOfFreeShots > 0) {
        [btnEditCheck setEnabled:NO];
        [btnRedoLast setEnabled:NO];
    }
}

- (void) doneFieldShotAfterFoul{

    [self transformIntoFreeshot];
    [self startAFreeShot];
}

- (void) doneAFreeShot{
    if (!_clockView.isContMode) {
        [teamAPlayerView stop];
        [teamAPlayerView setEnable:YES];
        [teamAPlayerView setFlashing:NO];
        [teamBPlayerView stop];
        [teamBPlayerView setEnable:YES];
        [teamBPlayerView setFlashing:NO];
//        [actionBoxView_Scoring setEnable:NO];
        [actionBoxView_Scoring setFlashing:NO];
//        [actionBoxView_Statistics setEnable:NO];
        [actionBoxView_Statistics setFlashing:NO];
        [leftTimeOut setEnable:YES];
        [rightTimeOut setEnable:YES];
        [_clockView setFlashing:YES];
        [_clockView setUserInteractionEnabled:YES];
        [_clockView setAdjustRemainingTimeEnable:YES];
        [btnRedoLast setEnabled:YES];
        [btnEditCheck setEnabled:YES];
        [teamA setIsEditable:YES];
        [teamB setIsEditable:YES];
        [self toggleAddPlayerButton:YES];
    } else if (isClockDisabled) {
        [actionBoxView_Scoring setEnable:YES];
        [actionBoxView_Scoring setFlashing:YES];
        [actionBoxView_Statistics setEnable:YES];
        [actionBoxView_Statistics setFlashing:YES];
        [leftTimeOut setEnable:YES];
        [rightTimeOut setEnable:YES];
        [_clockView setUserInteractionEnabled:YES];
        [btnRedoLast setEnabled:YES];
        [btnEditCheck setEnabled:YES];

    }
}

- (void) doneEditingAction{
    isEditingAction = NO;
    bbAction = nil;
    [self reset];

    [_clockView continueUpdateTimeGraphic];
    [leftDelete setHidden:YES];
    [rightDelete setHidden:YES];
    if (isEditingFreeShot) {
        if (isInFreeShot) {
            [self transformIntoActionBox];
        }
        isEditingFreeShot = NO;
    }
    if (_clockView.isRunning || isFouled || _clockView.remainTime == 0) {
        [teamAPlayerView start];
        [teamAPlayerView setEnable:NO];
        [teamAPlayerView setFlashing:NO];
        [teamBPlayerView start];
        [teamBPlayerView setEnable:NO];
        [teamBPlayerView setFlashing:NO];
        [actionBoxView_Scoring setFlashing:YES];
        [actionBoxView_Scoring setEnable:YES];
        [actionBoxView_Statistics setFlashing:YES];
        [actionBoxView_Statistics setEnable:YES];
        [_clockView setUserInteractionEnabled:YES];
        if (isInFreeShot) {
            [self transformIntoFreeshot];
            [self startAFreeShot];
        }
    } else if (_clockView.remainTime > 0) {
        [teamAPlayerView stop];
        [teamBPlayerView stop];
        [teamAPlayerView setFlashing:NO];
        [teamBPlayerView setFlashing:NO];
//        [actionBoxView_Statistics setEnable:NO];
        [actionBoxView_Statistics setFlashing:NO];
//        [actionBoxView_Scoring setEnable:NO];
        [actionBoxView_Scoring setFlashing:NO];
    }
    [btnRedoLast setEnabled:YES];
    [btnEditCheck setEnabled:YES];
}
- (void) dismissActionList{
    if (popOverViewController) {
        [popOverViewController dismissPopoverAnimated:YES];
        popOverViewController = nil;
    }
}
- (void) setPopOverContentSizeWithNumberOfLine:(NSInteger)lines{
    [popOverViewController setPopoverContentSize:CGSizeMake(kPopOverSize_Width, (lines * kTableViewCell_Height < kPopOverSize_Height)?lines * kTableViewCell_Height+40:kPopOverSize_Height+40)];
}

- (void) editTableView{
    [popOverContentViewController setEditing:YES
                                    animated:YES];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneEditing)];
    popOverContentViewController.navigationController.navigationBar.topItem.rightBarButtonItem = doneButton;
    [doneButton release];
}

- (void) doneEditing{
    [popOverContentViewController setEditing:NO
                                    animated:YES];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                target:self
                                                                                action:@selector(editTableView)];
    popOverContentViewController.navigationController.navigationBar.topItem.rightBarButtonItem = editButton;
    [editButton release];
    //    displayedTableViewController = nil;
}

- (void) displayTeamNamePopOverWithKeyWord:(NSString*)keyWord{
    CGRect caretRect = [tfTeamName caretRectForPosition:[tfTeamName positionFromPosition:tfTeamName.beginningOfDocument offset:tfTeamName.text.length]];
    NSArray *dataSource = [DataManager arrayOfRecordedTeamsWithKeyWord:keyWord];

    popOverDataSource = [dataSource retain];


    if ([popOverDataSource count] > 0) {
        


        

        if (!popOverViewController) {
            F_RELEASE(popOverContentViewController);
            popOverContentViewController = [[BBTableViewController alloc] initWithStyle:UITableViewStylePlain];
            //        [popOverContentViewController.tableView setBackgroundColor:[UIColor clearColor]];
            [popOverContentViewController.tableView setTag:TAG_AUTOFILLTABLEVIEW_TEAM];
            
            [popOverContentViewController.tableView setDelegate:self];
            [popOverContentViewController.tableView setDataSource:self];
            [popOverContentViewController setTitle:TITLE_TEAMLIST];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:popOverContentViewController];
            UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                  target:self
                                                                                  action:@selector(editTableView)];
            navController.navigationBar.topItem.rightBarButtonItem = edit;
            [edit release];
            popOverViewController = [[UIPopoverController alloc] initWithContentViewController:navController];
            
            [popOverViewController setDelegate:self];
            [popOverViewController setPopoverContentSize:CGSizeMake(kPopOverSize_Width, ([popOverDataSource count] * kTableViewCell_Height < kPopOverSize_Height)?[popOverDataSource count] * kTableViewCell_Height+40:kPopOverSize_Height+40)];

            

            
            [navController release];
            [popOverContentViewController release];        
        }
        [popOverContentViewController.tableView setTag:TAG_AUTOFILLTABLEVIEW_TEAM];
        [popOverContentViewController setTitle:TITLE_TEAMLIST];


        [popOverContentViewController.tableView reloadData];
        CGFloat height = ([popOverDataSource count] * kTableViewCell_Height < kPopOverSize_Height)?[popOverDataSource count] * kTableViewCell_Height+40:kPopOverSize_Height+40;
        [popOverViewController setPopoverContentSize:CGSizeMake(kPopOverSize_Width, height)];
        CGRect rect = [tfTeamName convertRect:caretRect toView:self.view];
        [popOverViewController presentPopoverFromRect:rect
                                               inView:self.view 
                             permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown 
                                             animated:YES];
    } else {
        if (popOverViewController && popOverViewController.isPopoverVisible) {
            [popOverViewController dismissPopoverAnimated:YES];
            F_RELEASE(popOverDataSource);
            F_RELEASE(popOverViewController);
        }
    }

}
- (void) displayTeamNameSuggestionPopOverWithTeam:(BBTeamNameView*)team{
    NSArray *dataSource = [DataManager arrayOfRecordedTeamsWithKeyWord:@""];
    F_RELEASE(popOverDataSource);
    popOverDataSource = [dataSource retain];
    currentTeamName = team;
    onEditingTeamName = currentTeamName;
    if (popOverDataSource.count == 0) {
        [tfHiddenTeam becomeFirstResponder];
        return;
    }
    if ([popOverDataSource count] > 0) {
        F_RELEASE(popOverContentViewController);
        popOverContentViewController = [[BBTableViewController alloc] initWithStyle:UITableViewStylePlain];
        //        [popOverContentViewController.tableView setBackgroundColor:[UIColor clearColor]];
        [popOverContentViewController.tableView setTag:TAG_SUGGESTIONTABLEVIEW];
        
        [popOverContentViewController.tableView setDelegate:self];
        [popOverContentViewController.tableView setDataSource:self];
        [popOverContentViewController setTitle:TITLE_TEAMLIST];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:popOverContentViewController];
        UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                              target:self
                                                                              action:@selector(editTableView)];
        navController.navigationBar.topItem.rightBarButtonItem = edit;
        [edit release];
        UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewTeamName:)];
        navController.navigationBar.topItem.leftBarButtonItem = add;
        [add release];
        popOverViewController = [[UIPopoverController alloc] initWithContentViewController:navController];
        
        [popOverViewController setDelegate:self];
        [popOverViewController setPopoverContentSize:CGSizeMake(kPopOverSize_Width, ([popOverDataSource count] * kTableViewCell_Height < kPopOverSize_Height)?[popOverDataSource count] * kTableViewCell_Height+40:kPopOverSize_Height+40)];
        
        
        
        
        [navController release];
        [popOverContentViewController.tableView setTag:TAG_SUGGESTIONTABLEVIEW];
        [popOverContentViewController setTitle:TITLE_TEAMLIST];
        [popOverContentViewController.tableView reloadData];
        CGFloat height = ([popOverDataSource count] * kTableViewCell_Height < kPopOverSize_Height)?[popOverDataSource count] * kTableViewCell_Height+40:kPopOverSize_Height+40;
        [popOverViewController setPopoverContentSize:CGSizeMake(kPopOverSize_Width, height)];
        CGRect rect = team.frame;
        [popOverViewController presentPopoverFromRect:rect
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
                                             animated:YES];
    }
        
        
        
        
//        if (!popOverViewController) {
            
//    } else {
//        [team setIsSelected:NO];
//        if (popOverViewController && popOverViewController.isPopoverVisible) {
//            [popOverViewController dismissPopoverAnimated:YES];
//            F_RELEASE(popOverDataSource);
//            F_RELEASE(popOverViewController);
//        }
//    }

}
- (void) displayActionsList{
    if (arrActions && arrActions.count > 0) {
        if (popOverViewController) {
            [popOverViewController dismissPopoverAnimated:YES];
        }

        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            BBActionRef *action = (BBActionRef*)evaluatedObject;
            if (action.actionType != ACTION_TYPE_QRTEND && action.actionType != ACTION_TYPE_QRTSTART && action.actionType != ACTION_TYPE_PLAYERON && action.actionType !=ACTION_TYPE_PLAYEROFF && action.isSaved) {
                return YES;
            } else {
                return NO;
            }
        }];
        //    arrActionNames = [[NSArray alloc] initWithArray:arrName];
        F_RELEASE(popOverContentViewController);
        F_RELEASE(popOverDataSource);
        popOverDataSource = [[NSArray alloc] initWithArray:[arrActions filteredArrayUsingPredicate:predicate]];
        NSMutableArray *arrNames = [NSMutableArray array];
        if (popOverDataSource && popOverDataSource.count > 0) {
            for (int i = 0; i < popOverDataSource.count; ++i) {
                BBActionRef *action = [popOverDataSource objectAtIndex:i]; 
                BBPlayerTableView *teamPlayerView;
                BBTeamNameView *teamNameview;
                NSString *teamLetter = nil;
                if (action.teamIndex == 0) {
                    teamPlayerView = teamAPlayerView;
                    teamNameview = teamA;
                    teamLetter = @"A";
                } else {
                    teamPlayerView = teamBPlayerView;
                    teamNameview = teamB;
                    teamLetter = @"B";
                }
                NSString *teamName = [teamNameview teamName];
                NSString *playerName = @"";
                NSString *playerNumber;
                if (action.playerIndex > 0) {
                    playerName = [teamPlayerView playerNameAtIndex:action.playerIndex];
                    BBPlayer *player = [teamPlayerView playerWithIndex:action.playerIndex];
                    playerNumber = [player number];
                }
                NSString *strTime =nil;
                if (action.actionTime == kDisabledValue) {
                    strTime = kDisableTimeTitle;
                } else {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"mm:ss"];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:action.actionTime];
                    strTime = [dateFormatter stringFromDate:date];
                    [dateFormatter release];
                }
                NSString *actionName = nil;
                switch (action.actionType) {
                    case ACTION_TYPE_ASSIST:
                        actionName = ACTION_NAME_ASSIST;
                        break;
                    case ACTION_TYPE_FOUL:
                        actionName = ACTION_NAME_FOUL;
                        break;
                    case ACTION_TYPE_FOUL1:
                        actionName = ACTION_NAME_FOUL1;
                        break;
                    case ACTION_TYPE_FOUL2:
                        actionName = ACTION_NAME_FOUL2;
                        break;
                    case ACTION_TYPE_FOUL3:
                        actionName = ACTION_NAME_FOUL3;
                        break;
                    case ACTION_TYPE_ONEMADE:
                        actionName = ACTION_NAME_ONEMADE;
                        break;
                    case ACTION_TYPE_ONEMISS:
                        actionName = ACTION_NAME_ONEMISS;
                        break;
                    case ACTION_TYPE_REBOUND:
                        actionName = ACTION_NAME_REBOUND;
                        break;
                    case ACTION_TYPE_STEAL:
                        actionName = ACTION_NAME_STEAL;
                        break;
                    case ACTION_TYPE_TECHFOUL:
                        actionName = ACTION_NAME_TECHFOUL;
                        break;
                    case ACTION_TYPE_THREEMADE:
                        actionName = ACTION_NAME_THREEMADE;
                        break;
                    case ACTION_TYPE_THREEMISS:
                        actionName = ACTION_NAME_THREEMISS;
                        break;
                    case ACTION_TYPE_TURNOVER:
                        actionName = ACTION_NAME_TURNOVER;
                        break;
                    case ACTION_TYPE_TWOMADE:
                        actionName = ACTION_NAME_TWOMADE;
                        break;
                    case ACTION_TYPE_TWOMISS:
                        actionName = ACTION_NAME_TWOMISS;
                        break;
                    case ACTION_TYPE_TIMEOUT:
                        actionName = ACTION_NAME_TIMEOUT;
                        break;
                    default:
                        break;
                }

                NSString *name = nil;
                if (action.playerIndex > 0) {
                    name = [NSString stringWithFormat:@"[Period %d] %@ %@ - %@%@ %@ (%@)",action.period,strTime,actionName,teamLetter,playerNumber,playerName,teamName];
                } else {
                    name = [NSString stringWithFormat:@"[Period %d] %@ %@ - %@",action.period,strTime,actionName,teamName];
                }
                name = [name stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
                [arrNames addObject:name];
            }
            F_RELEASE(arrActionNames);
            arrActionNames = [arrNames retain];
        }
        isInitialLoadActionList = YES;
        F_RELEASE(popOverContentViewController);
        popOverContentViewController = [[BBTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [popOverContentViewController.tableView setDelegate:self];
        [popOverContentViewController.tableView setDataSource:self];
        [popOverContentViewController.tableView setTag:TAG_ACTIONLISTTABLEVIEW];
        [popOverContentViewController setTitle:TITLE_ACTIONLIST];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:popOverContentViewController];
        //    [contentViewController.tableView setBackgroundColor:[UIColor clearColor]];
        F_RELEASE(popOverViewController);
        popOverViewController = [[UIPopoverController alloc] initWithContentViewController:navController];
        [popOverContentViewController setShouldScrollToBottom:YES];
        [popOverViewController setDelegate:self];
        [popOverViewController setPopoverContentSize:CGSizeMake(kActionListPopOverSize_Width,kActionListPopOverSize_Height)];
        [popOverContentViewController.tableView reloadData];
//        [popOverContentViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:popOverDataSource.count - 1 inSection:0]
//                                                      atScrollPosition: UITableViewScrollPositionTop                  
//                                                              animated:YES];
        CGSize contentSize = popOverContentViewController.tableView.contentSize;
        [popOverContentViewController.tableView setContentOffset:CGPointMake(0, contentSize.height - popOverContentViewController.tableView.frame.size.height)];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:LOCALIZE(kButtonTitleDone)
                                                                          style:UIBarButtonSystemItemDone
                                                                         target:self
                                                                         action:@selector(dismissActionList)];
        navController.navigationBar.topItem.rightBarButtonItem = doneBarButton;
        [doneBarButton release];
        [navController release];
        F_RELEASE(popOverContentViewController);
        [popOverViewController presentPopoverFromRect:shotGraphicView.frame 
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionDown
                                             animated:YES];

    }
}
- (void) displayPlayerNamePopOverWithKeyWord:(NSString*)keyWord{
    CGRect caretRect = [tfPlayerName caretRectForPosition:[tfPlayerName positionFromPosition:tfPlayerName.beginningOfDocument offset:tfPlayerName.text.length]];
    NSArray *dataSource = [DataManager arrayOfRecordedPlayersNameWithKeyWord:keyWord];
    F_RELEASE(popOverDataSource);
    popOverDataSource = [dataSource retain];
    if ([popOverDataSource count] > 0) {
        if (!popOverViewController) {
            F_RELEASE(popOverContentViewController);
            popOverContentViewController = [[BBTableViewController alloc] initWithStyle:UITableViewStylePlain];
            //        [popOverContentViewController.tableView setBackgroundColor:[UIColor clearColor]];
            [popOverContentViewController.tableView setTag:TAG_AUTOFILLTABLEVIEW_PLAYER];
            
            [popOverContentViewController.tableView setDelegate:self];
            [popOverContentViewController.tableView setDataSource:self];
            [popOverContentViewController setTitle:TITLE_PLAYERLIST];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:popOverContentViewController];
            UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                  target:self
                                                                                  action:@selector(editTableView)];
            navController.navigationBar.topItem.rightBarButtonItem = edit;
            [edit release];
            popOverViewController = [[UIPopoverController alloc] initWithContentViewController:navController];
            
            [popOverViewController setDelegate:self];
            [popOverViewController setPopoverContentSize:CGSizeMake(kPopOverSize_Width, ([popOverDataSource count] * kTableViewCell_Height < kPopOverSize_Height)?[popOverDataSource count] * kTableViewCell_Height+40:kPopOverSize_Height+40)];
            
            
            
            
            [navController release];
        }
        
        [popOverContentViewController.tableView setTag:TAG_AUTOFILLTABLEVIEW_PLAYER];
        
        [popOverContentViewController setTitle:TITLE_PLAYERLIST];
        [popOverContentViewController.tableView reloadData];
        CGFloat height = ([popOverDataSource count] * kTableViewCell_Height < kPopOverSize_Height)?[popOverDataSource count] * kTableViewCell_Height+40:kPopOverSize_Height+40;
        [popOverViewController setPopoverContentSize:CGSizeMake(kPopOverSize_Width, height)];
        CGRect rect = [tfPlayerName.superview convertRect:[tfPlayerName convertRect:caretRect toView:tfPlayerName.superview] toView:self.view];
        [popOverViewController presentPopoverFromRect:rect
                                               inView:self.view 
                             permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown 
                                             animated:YES];
    } else {
        if (popOverViewController && popOverViewController.isPopoverVisible) {
            [popOverViewController dismissPopoverAnimated:YES];
            F_RELEASE(popOverDataSource);
            F_RELEASE(popOverViewController);
        }
    }
    
}

- (void) shotPinDidRemove:(NSNotification*)notification{
//    [bbAction setActionType:ACTION_TYPE_UNKNOWN];
    if (bbAction) {
        [bbAction setActionLocation:CGPointZero];
    }
}

- (void) didChangeContMode:(NSNotification*)notification{
    BOOL contMode = _clockView.isContMode;
    if (contMode) {
        [leftSub setHidden:NO];
        if (!shouldIgnoreTeamB) {
            [rightSub setHidden:NO];
        }
    } else {
        [leftSub setHidden:YES];
        [rightSub setHidden:YES];
    }
}
- (void) playerDidSelected:(NSNotification*)notification{
    if ([teamAPlayerView arrayOfSelectedPlayer].count > 1) {
        [_clockView setIsFlashing:YES];
    } else {
        [_clockView setIsFlashing:NO];
    }
}
- (void) playerSubbed:(NSNotification*)notification{
    NSDictionary *dict = [notification object];
    @synchronized(self){
        [self initialAction];
        ACTION_TYPE actionType;
        NSInteger teamIndex = [[dict objectForKey:kKey_PlayerSubbing_TeamIndex] intValue];
        NSInteger playerIndex = [[dict objectForKey:kKey_PlayerSubbing_Index] intValue];
        if ([[dict objectForKey:kKey_PlayerSubbing_On] boolValue]) {
            actionType = ACTION_TYPE_PLAYERON;
        } else {
            actionType = ACTION_TYPE_PLAYEROFF;
        }
        [bbAction setActionType:actionType];
        [bbAction setPlayerIndex:playerIndex];
        [bbAction setTeamIndex:teamIndex];
        [bbAction setPeriod:period];    
        [self saveAction];    
    }
}

- (void) playerDidTap:(NSNotification*)notification{
    if ([teamAPlayerView arrayOfSelectedPlayer].count > 1) {
        [_clockView setIsFlashing:YES];
        if (!isClockDisabled && isStartANewMatch) {
            [btnDisableClock setEnabled:YES];
        }
    } else {
        [_clockView setIsFlashing:NO];
        [btnDisableClock setEnabled:NO];
    }
    BBPlayerView *playerView = [notification object];
    if (SYSTEM_VERSION < 7) {
        [(BBPlayerTableView*)playerView.superview setFlashing:NO];
    } else {
        [(BBPlayerTableView*)playerView.superview.superview setFlashing:NO];
    }
}

- (void) initialAction{
    [leftSub setEnabled:NO];
    [rightSub setEnabled:NO];
    [_clockView setUserInteractionEnabled:NO];
    [_clockView toggleChangeModeEnabled:NO];
    F_RELEASE(bbAction);
    bbAction = [[BBActionRef alloc] initWithTime:[_clockView remainTime]];
    [bbAction setPeriod:period];
}
- (void) editAction:(BBActionRef*)action{

    if (!isEditingAction && arrActions && arrActions.count > 0) {
        NSInteger index = [arrActions indexOfObject:action];
        F_RELEASE(bbAction);
        bbAction = [[BBActionRef alloc] initWithAction:action];
        [arrActions insertObject:bbAction atIndex:index+1];
        F_RELEASE(bbAction);
        bbAction = [arrActions objectAtIndex:index + 1];
        if (isInFreeShot) {
            freeShotCount --;
        }
        if (action.actionType == ACTION_TYPE_TIMEOUT) {
            if (action.teamIndex == 0) {
                [leftTimeOut subtractValue];
                [foulA setSelected:YES];
                [foulB setSelected:NO];
            } else{
                [rightTimeOut subtractValue];
                [foulA setSelected:NO];
                [foulB setSelected:YES];
            }
            [CommonUtils displayPopUpWithContentView:editTimeOutView];
            return;
        }
        if (!isFouled) {
            [leftDelete setHidden:NO];
            [rightDelete setHidden:NO];
        }
//        isInFreeShot = NO;
//        [self clockViewDidStart:_clockView];
        [teamAPlayerView start];
        [teamBPlayerView start];
        [_clockView setUserInteractionEnabled:NO];
        [leftDoneButton setEnabled:YES];
        [rightDoneButton setEnabled:YES];
        isEditingAction = YES;

        BBPlayerTableView *teamView;
        [teamAPlayerView setEnable:YES];
        [teamBPlayerView setEnable:YES];
        if (bbAction.teamIndex == 0) {
            teamView = teamAPlayerView;
            [teamBPlayerView setFlashing:NO];
        }else {
            teamView = teamBPlayerView;
            [teamAPlayerView setFlashing:NO];
        }
        
//        [teamView setPlayerWithIndex:bbAction.playerIndex];
        
        [teamView setFlashing:YES
                      atIndex:bbAction.playerIndex];
        
        
        [_clockView pendingUpdateTimeGraphicWithRemainingTime:bbAction.actionTime];
        

//        [topActionBox setFlashing:YES
//                          forType:bbAction.actionType];
        if (bbAction.actionType == ACTION_TYPE_ONEMADE || bbAction.actionType == ACTION_TYPE_ONEMISS) {
            isEditingFreeShot = YES;
            [self transformIntoFreeshot];
            [actionBoxView_Freeshot deselectAll];
            [actionBoxView_Freeshot setEnable:YES
                                    forTypes:[NSArray arrayWithObjects:[NSNumber numberWithInt:ACTION_TYPE_ONEMADE],[NSNumber numberWithInt:ACTION_TYPE_ONEMISS], nil]];

        } else {
            [self transformIntoActionBox];
        }
        [actionBoxView_Scoring setEnable:YES];
        [actionBoxView_Statistics setEnable:YES];
        [actionBoxView_Scoring setFlashing:YES forType:bbAction.actionType];
        [actionBoxView_Statistics setFlashing:YES forType:bbAction.actionType];
        [actionBoxView_Freeshot setFlashing:YES forType:bbAction.actionType];
        [shotGraphicView setActionType:action.actionType];
        if (!CGPointEqualToPoint(bbAction.actionLocation, CGPointZero)) {
            [shotGraphicView setShotPinWithLocation:bbAction.actionLocation
                                            andType:bbAction.actionType];
        }
        NSInteger point;
        switch (action.actionType) {
            case ACTION_TYPE_ONEMADE:
                point = 1;
                break;
            case ACTION_TYPE_TWOMADE:
                point = 2;
                break;
            case ACTION_TYPE_THREEMADE:
                point = 3;
                break;
            default:
                point = 0;
                break;
        }
        

        BBPlayer *player = nil;
        if (action.playerIndex > 0) {
            player = [teamView playerWithIndex:action.playerIndex];
        }
        [player subtractScore:point];
        [scoreBoard subtractValue:point
                         forIndex:action.teamIndex];
        
        ACTION_TYPE actionType = bbAction.actionType;
        if (actionType != ACTION_TYPE_TECHFOUL && action.teamIndex == 1 && !player) {
            [teamBPlayerView setFlashing:YES];
        } else if (actionType == ACTION_TYPE_FOUL || actionType == ACTION_TYPE_FOUL1 || actionType == ACTION_TYPE_FOUL2 || actionType == ACTION_TYPE_FOUL3 || actionType == ACTION_TYPE_TECHFOUL) {
            BBFoulView *teamFoul = nil;
            if (action.teamIndex == 0) {
                teamFoul = leftFouls;
            } else {
                teamFoul = rightFouls;
            }
            if (player) {
                [player subtractFoul];
                [teamFoul subtractValue];
                if (actionType == ACTION_TYPE_TECHFOUL) {
                    [player subtractTechFoul];
                }
            }
            if (actionType == ACTION_TYPE_TECHFOUL) {
                [teamA setIsInTechFoul:YES];
                [teamB setIsInTechFoul:YES];
                if (action.teamIndex == 0) {
                    [teamA toggleFlashing:YES];
                    [teamB toggleFlashing:NO];
                } else {
                    [teamA toggleFlashing:NO];
                    [teamB toggleFlashing:YES];
                }
            }
        }
        if (actionType == ACTION_TYPE_TWOMADE || actionType == ACTION_TYPE_TWOMISS || actionType == ACTION_TYPE_THREEMADE || actionType == ACTION_TYPE_THREEMISS) {
            [shotGraphicView setEnable:YES];
        }
        [teamView reloadData];
    }
}
- (void) reset{
    [shotGraphicView clear];
    [teamAPlayerView deselectAll];
    [teamBPlayerView deselectAll];
    [actionBoxView_Statistics deselectAll];
    [actionBoxView_Scoring deselectAll];

    [shotGraphicView setEnable:NO];
//    [actionBoxView_Scoring setEnable:YES];
//    [actionBoxView_Statistics setEnable:YES];
}
- (void) updateActionWithPlayerIndex:(NSInteger)playerIndex teamIndex:(NSInteger)teamIndex{
    if (!bbAction) {
        [self initialAction];
    }
    
    [bbAction setPlayerIndex:playerIndex];
    [bbAction setTeamIndex:teamIndex];
    [self checkCompletenessOfInfomation];
    
    NSLog(@"Did select player");
}

- (void) updateActionWithActionType:(ACTION_TYPE)type{
    if (!bbAction) {
        [self initialAction];
    }
    [bbAction setActionType:type];
    [shotGraphicView setActionType:type];
    [self checkCompletenessOfInfomation];
    
    NSLog(@"Did select action");
}

- (void) updateActionWithActionLocation:(CGPoint)location{
    if (!bbAction) {
        [self initialAction];
    }
    
    [bbAction setActionLocation:location];

    [self checkCompletenessOfInfomation];
    NSLog(@"Did select location of shot");
    
}


- (void) checkCompletenessOfInfomation{
    
    if (!isEditingAction && bbAction) {
        NSLog(@"Check completeness of information");
        if (bbAction.actionType == ACTION_TYPE_ASSIST || bbAction.actionType == ACTION_TYPE_REBOUND || bbAction.actionType == ACTION_TYPE_STEAL || bbAction.actionType == ACTION_TYPE_TURNOVER) {
            [self doneAction];
            [leftTimeOut setEnable:YES];
            [rightTimeOut setEnable:YES];
            [_clockView setUserInteractionEnabled:YES];
            [btnRedoLast setEnabled:YES];
            [btnEditCheck setEnabled:YES];
        } else if (bbAction.actionType == ACTION_TYPE_FOUL || bbAction.actionType == ACTION_TYPE_FOUL1 || bbAction.actionType == ACTION_TYPE_FOUL2 || bbAction.actionType == ACTION_TYPE_FOUL3 || bbAction.actionType == ACTION_TYPE_TECHFOUL){
            BBFoulView *teamFoul = (bbAction.teamIndex==0)?leftFouls:rightFouls;
            isFouled = YES;
            switch (bbAction.actionType) {
                case ACTION_TYPE_FOUL:
                {
                    if (teamFoul.value >= [DataManager teamFoulDangerLimit]) {
                        numberOfFreeShots = 2;
                    } else {
                        numberOfFreeShots = 0;
                        isFouled = NO;
                    }
                }
                    break;
                case ACTION_TYPE_FOUL1:
                    numberOfFreeShots = 1;
                    break;
                case ACTION_TYPE_FOUL2:
                    numberOfFreeShots = 2;
                    break;
                case ACTION_TYPE_FOUL3:
                    numberOfFreeShots = 3;
                case ACTION_TYPE_TECHFOUL:
                    numberOfFreeShots = 2;
                default:
                    break;
            }
        } else if ((bbAction.actionType == ACTION_TYPE_TWOMADE || bbAction.actionType == ACTION_TYPE_THREEMADE || bbAction.actionType == ACTION_TYPE_TWOMISS) && isFouled && !CGPointEqualToPoint(shotGraphicView.shotLocation, CGPointZero)){
            [self doneAction];
            [leftDoneButton toggleFlashing:NO];
            [rightDoneButton toggleFlashing:NO];
        }
    }
}


- (void) saveAction{
    if (!arrActions) {
        arrActions = [[NSMutableArray alloc] init];
    }
    if (bbAction) {
        [leftDoneButton setEnabled:NO];
        [rightDoneButton setEnabled:NO];
        NSLog(@"Did save action");
        [bbAction setIsSaved:YES];
        [arrActions addObject:bbAction];
        if (bbAction.teamIndex > -1) {
            BBPlayerTableView *tpView;
            BBFoulView *teamFoul;
            if (bbAction.teamIndex == 0) {
                tpView = teamAPlayerView;
                teamFoul = leftFouls;
            }else {
                tpView = teamBPlayerView;
                teamFoul = rightFouls;
            }
            
            
            
            NSInteger point = 0;
            if (bbAction.actionType == ACTION_TYPE_ONEMADE) {
                point = 1;
            } else if (bbAction.actionType == ACTION_TYPE_TWOMADE){
                point = 2;
            } else if (bbAction.actionType == ACTION_TYPE_THREEMADE){
                point = 3;
            }
            if (bbAction.playerIndex > 0) {
                [[tpView playerWithIndex:bbAction.playerIndex] addScore:point];
            }
            [scoreBoard addValue:point
                        forIndex:bbAction.teamIndex];
            if (bbAction.actionType == ACTION_TYPE_FOUL || bbAction.actionType == ACTION_TYPE_TECHFOUL || bbAction.actionType == ACTION_TYPE_FOUL1 || bbAction.actionType == ACTION_TYPE_FOUL2 || bbAction.actionType == ACTION_TYPE_FOUL3){
                [teamFoul addValue];
                freeShotTeamIndex = 1 - bbAction.teamIndex;
                if (bbAction.playerIndex > 0) {
                    [[tpView playerWithIndex:bbAction.playerIndex] addFoul];
                    if (bbAction.actionType == ACTION_TYPE_TECHFOUL) {
                        [[tpView playerWithIndex:bbAction.playerIndex] addTechFoul];
                    }
                }
                if (bbAction.actionType == ACTION_TYPE_TECHFOUL || (bbAction.actionType == ACTION_TYPE_FOUL && teamFoul.value > [DataManager teamFoulDangerLimit])) {
                    numberOfFreeShots = 2;
//                    isFouled = YES;
                }
                /////////Free shot processing
                freeShotCount = 0;
            }
                        
            
//             else {

//            }
            
        }
        [self reset];
//        if (isInFreeShot) {
//            [self startAFreeShot];
//        }
//        if (bbAction.actionType == ACTION_TYPE_FOUL1 && !_clockView.isContMode) {
//            [self startFieldMade];
//        }
        F_RELEASE(bbAction);
    }
    if (!isFouled) {
        [leftSub setEnabled:YES];
        [rightSub setEnabled:YES];
        [_clockView setUserInteractionEnabled:YES];
        if (!isLoadingPreviousData) {
            [self quickSave];
        }
    }
    

    [_clockView toggleChangeModeEnabled:YES];
}

- (void) startFieldMade{
//    isInFreeShot = YES;
    [teamAPlayerView start];
    [teamBPlayerView start];
    [self toggleAddPlayerButton:NO];
    [actionBoxView_Scoring setEnable:YES
                            forTypes:[NSArray arrayWithObjects:[NSNumber numberWithInt:ACTION_TYPE_TWOMADE], [NSNumber numberWithInt:ACTION_TYPE_THREEMADE], nil]];
    [actionBoxView_Statistics setEnable:YES
                               forTypes:[NSArray arrayWithObjects:[NSNumber numberWithInt:ACTION_TYPE_TWOMADE], [NSNumber numberWithInt:ACTION_TYPE_THREEMADE], nil]];
    [actionBoxView_Scoring setFlashing:YES
                              forTypes:[NSArray arrayWithObjects:[NSNumber numberWithInt:ACTION_TYPE_TWOMADE], [NSNumber numberWithInt:ACTION_TYPE_THREEMADE], nil]];
    [actionBoxView_Statistics setFlashing:YES
                                 forTypes:[NSArray arrayWithObjects:[NSNumber numberWithInt:ACTION_TYPE_TWOMADE], [NSNumber numberWithInt:ACTION_TYPE_THREEMADE], nil]];
//    BBTeamPlayerView *fieldShotTeam = nil;
//    if (freeShotTeamIndex == 0) {
//        fieldShotTeam = teamAPlayerView;
//    } else {
//        fieldShotTeam = teamBPlayerView;
//    }
    [teamAPlayerView setEnable:NO];
    [teamBPlayerView setEnable:NO];
//    [fieldShotTeam setFlashing:YES];
}
- (void) endGame{
    [_clockView setFlashing:NO];
    [actionBoxView_Scoring setFlashing:NO];
    [actionBoxView_Statistics setFlashing:NO];
    [teamAPlayerView setFlashing:NO];
    [teamBPlayerView setFlashing:NO];
}

- (void) resetValue{
    [(UIButton*)menuControllerSender setTitle:@"" forState:UIControlStateNormal];
}
- (void) displayPopupButtonsBar:(id)sender{
    
    menuControllerSender = sender;
    [self becomeFirstResponder];
    menuController = [[UIMenuController alloc] init];
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"Reset" action:@selector(resetValue)];
    [menuController setMenuItems:[NSArray arrayWithObject:item]];
    [item release];
    [menuController setTargetRect:[(UIView*)sender frame]
                           inView:self.view];
    
    [menuController setMenuVisible:YES animated:YES];
    
}

- (void) dismissPopupButtonBar{
    [menuController setMenuVisible:NO animated:YES];
}




- (void) playerDidChooseWithIndex:(NSInteger)playerIndex inTeamIndex:(NSInteger)teamIndex isOnAction:(BOOL)isOnAction{
    [teamA toggleFlashing:NO];
    [teamB toggleFlashing:NO];
    if (!bbAction) {
        [self initialAction];
    }
    if (isOnAction) {
        [bbAction setPlayerIndex:playerIndex];
        [bbAction setTeamIndex:teamIndex];
        if (teamIndex == 1 && shouldIgnoreTeamB) {
            [bbAction setPlayerIndex:0];
        }
    }
    else {
        [bbAction setPlayerIndex:0];
        [bbAction setTeamIndex:-1];
    }
    
    if (!isEditingAction) {
        [teamAPlayerView setFlashing:NO];
        [teamBPlayerView setFlashing:NO];
        if (bbAction.actionType == ACTION_TYPE_THREEMADE || bbAction.actionType == ACTION_TYPE_THREEMISS || bbAction.actionType == ACTION_TYPE_TWOMADE || bbAction.actionType == ACTION_TYPE_TWOMISS) {
            [shotGraphicView setEnable:YES];
            if (CGPointEqualToPoint(bbAction.actionLocation, CGPointZero)) {
                [leftDoneButton toggleFlashing:YES];
                [rightDoneButton toggleFlashing:YES];
            }

        } else if (bbAction.actionType == ACTION_TYPE_FOUL || bbAction.actionType == ACTION_TYPE_FOUL1 || bbAction.actionType == ACTION_TYPE_FOUL2 || bbAction.actionType == ACTION_TYPE_FOUL3 || bbAction.actionType == ACTION_TYPE_TECHFOUL || bbAction.actionType == ACTION_TYPE_ONEMADE || bbAction.actionType == ACTION_TYPE_ONEMISS){
            [leftDoneButton toggleFlashing:YES];
            [rightDoneButton toggleFlashing:YES];
        }
        [leftDoneButton setEnabled:YES];
        [rightDoneButton setEnabled:YES];
    }
    [teamAPlayerView setFlashing:NO];
    [teamBPlayerView setFlashing:NO];
    [self checkCompletenessOfInfomation];
    NSLog(@"Did choose player");

}
#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"Textfield prepare to change characters in range");
    NSString *keyWord = [textField.text stringByReplacingCharactersInRange:range
                                                                withString:string];
    if (textField == tfTeamName) {
//        NSArray *arr = [[DataManager defaultManager] arrayOfRecordedTeams];
//        [[DataManager defaultManager] displayAutofillPopOverForTextField:textField
//                                                                  inView:self.view
//                                                              dataSource:[[arr retain] autorelease]
//                                                                delegate:self
//                                                                animated:YES 
//                                                                withType:EDITING_TYPE_TEAMNAME];
        [self displayTeamNamePopOverWithKeyWord:keyWord];

    }else if (textField == tfPlayerName){
        [self displayPlayerNamePopOverWithKeyWord:keyWord];

    } else if (textField == tfPlayerNum){
        if (![string isEqualToString:@"0"] && [string intValue] == 0 && ![string isEqualToString:@""]) {
            return NO;
        }
    }

    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == tfPlayerNum || textField == tfPlayerName) {
        [self doneEditingPlayerView:editingPlayerView];
        return NO;
    } else if (textField == tfTeamName){
        [self doneEditingTeamName:currentTeamName];
        return NO;
    }
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(resetValue)) {
        return YES;
    }
    return NO;
}





#pragma mark - BBClockViewDelegate
- (void)clockViewDidStopAtAction:(BBClockView *)clockView{
    isSubbing = NO;
//    [self completeTimeOn];
    [leftSub setHidden:YES];
    [rightSub setHidden:YES];
    [actionBoxView_Scoring setFlashing:NO];
    [actionBoxView_Statistics setFlashing:NO];

}
- (void)clockViewDidStop:(BBClockView *)clockView byFoul:(ACTION_TYPE)foulType{
    isSubbing = NO;
    switch (foulType) {
        case ACTION_TYPE_FOUL:
            numberOfFreeShots = 0;
            break;
        case ACTION_TYPE_FOUL1:
            numberOfFreeShots = kFoul1FreeShots;
            break;
        case ACTION_TYPE_FOUL2:
            numberOfFreeShots = kFoul2FreeShots;
            break;
        case ACTION_TYPE_FOUL3:
            numberOfFreeShots = kFoul3FreeShots;
            break;
        case ACTION_TYPE_TECHFOUL:
            numberOfFreeShots = 2;
        default:
            break;
    }
//    [self completeTimeOn];
    freeShotCount = 0;
    [_clockView setFlashing:NO];
    [_clockView setUserInteractionEnabled:NO];
    [btnRedoLast setEnabled:NO];
    [btnEditCheck setEnabled:NO];
    [leftTimeOut setEnable:NO];
    [rightTimeOut setEnable:NO];
    [leftSub setHidden:YES];
    [rightSub setHidden:YES];
    [teamAPlayerView start];
    [teamBPlayerView start];
//    [self startAFreeShot];
}

- (void) startAFreeShot{
    if (freeShotCount < numberOfFreeShots) {
        [actionBoxView_Freeshot deselectAll];
        isInFreeShot = YES;
        [teamAPlayerView start];
        [teamBPlayerView start];
        [self toggleAddPlayerButton:NO];
        [teamAPlayerView setEnable:NO];
        [teamBPlayerView setEnable:NO];
        NSLog(@"Start a free shot");
        [actionBoxView_Freeshot deselectAll];
        [actionBoxView_Freeshot setEnable:YES];
        [actionBoxView_Freeshot setFlashing:YES];
        freeShotCount ++;
        return;
    } else {
        if (numberOfFreeShots > 0) {
            [self transformIntoActionBox];
            lastPlayerIndex = -1;
        }
        isInFreeShot = NO;
        isFouled = NO;
        numberOfFreeShots = 0;
        freeShotTeamIndex = -1;
        freeShotCount = 0;
        if (!_clockView.isContMode) {
            if (_clockView.remainTime > 0 || _clockView.remainTime == kDisabledValue) {
                [_clockView setFlashing:YES];
                [actionBoxView_Freeshot setEnable:NO];
                [actionBoxView_Freeshot setFlashing:NO];
                [actionBoxView_Statistics setFlashing:NO];
                [actionBoxView_Statistics setEnable:YES];
                [actionBoxView_Scoring setFlashing:NO];
                [actionBoxView_Scoring setEnable:YES];
                [teamAPlayerView stop];
                [teamBPlayerView stop];
                [self toggleAddPlayerButton:YES];
            } else {
                [actionBoxView_Statistics setFlashing:YES];
                [actionBoxView_Scoring setFlashing:YES];
            }
        } else {
            [teamAPlayerView start];
            [teamBPlayerView start];
            [teamAPlayerView setEnable:NO];
            [teamBPlayerView setEnable:NO];
            [leftSub setEnabled:YES];
            [rightSub setEnabled:YES];
            [actionBoxView_Statistics setFlashing:YES];
            [actionBoxView_Scoring setFlashing:YES];
        }
        [_clockView setUserInteractionEnabled:YES];
        [_clockView setAdjustRemainingTimeEnable:YES];
        [btnEditCheck setEnabled:YES];
        [btnRedoLast setEnabled:YES];
        [leftTimeOut setEnable:YES];
        [rightTimeOut setEnable:YES];
        [teamA setIsEditable:YES];
        [teamB setIsEditable:YES];
        if (isTechFoulByTeam) {
//            [_clockView start];
            isTechFoulByTeam = NO;
        }
        if (isClockDisabled) {
            [self disableClock];
        }
    }
}
- (void)clockViewDidStop:(BBClockView *)clockView{
    F_RELEASE(arrSubbing);
    isSubbing = NO;
    NSLog(@"Clock did stop");
    [self toggleAddPlayerButton:YES];
    if (!isEditingAction) {
        [teamAPlayerView stop];
        [teamBPlayerView stop];
        [teamAPlayerView setFlashing:NO];
        [teamBPlayerView setFlashing:NO];
//        [actionBoxView_Scoring setEnable:NO];
//        [actionBoxView_Statistics setEnable:NO];
        [actionBoxView_Scoring setFlashing:NO];
        [actionBoxView_Statistics setFlashing:NO];
        [actionBoxView_Scoring setEnable:YES
                                forTypes:[NSArray arrayWithObject:[NSNumber numberWithInt:ACTION_TYPE_TECHFOUL]]];
        [actionBoxView_Statistics setEnable:YES
                                forTypes:[NSArray arrayWithObject:[NSNumber numberWithInt:ACTION_TYPE_TECHFOUL]]];
        [actionBoxView_Scoring deselectAll];
        [actionBoxView_Statistics deselectAll];
        
        [shotGraphicView setEnable:NO];
        
        //            [teamAPlayerView setEnable:YES];
        //            [teamBPlayerView setEnable:YES];
        //            [teamAPlayerView setFlashing:NO];
        //            [teamBPlayerView setFlashing:NO];
        
        [teamA setIsEditable:YES];
        [teamB setIsEditable:YES];
        
        //        [leftTimeOut setEnable:NO];
        //        [rightTimeOut setEnable:NO];
        if ([clockView remainTime] == 0) {
//            [btnPeriodEnd setEnabled:YES];
//            isStartANewPeriod = YES;
//            [self initialAction];
//            [bbAction setActionType:ACTION_TYPE_QRTEND];
//            [bbAction setActionTime:clockView.remainTime];
//            [self saveAction];
        }
//        [self completeTimeOn];
        [leftSub setHidden:YES];
        [rightSub setHidden:YES];


    }  
}
- (void) completeTimeOn{
    for (BBPlayer *player in teamAPlayerView.players) {
        if ((player.beginTimes && player.endTimes && player.beginTimes.count > player.endTimes.count)) {
            [player addEndTime:_clockView.remainTime];
        }
    }
    
    for (BBPlayer *player in teamBPlayerView.players) {
        if ((player.beginTimes && player.endTimes && player.beginTimes.count > player.endTimes.count)) {
            [player addEndTime:_clockView.remainTime];
        }
    }
}

- (void) subOnPlayerWhenStartANewPeriod{
    for (BBPlayer *player in teamAPlayerView.players) {
        if (player.isSelected) {
            [player addBeginTime:_clockView.remainTime];
        }
    }
    for (BBPlayer *player in teamBPlayerView.players) {
        if (player.isSelected) {
            [player addBeginTime:_clockView.remainTime];
        }
    }
}
- (void) addSubbingAction{
    if (arrSubbing) {
        if (!arrActions) {
            arrActions = [[NSMutableArray alloc] init];
        }
        for (BBActionRef *action in arrSubbing) {
            BBPlayer *player;
            BBPlayerTableView *teamTableView = nil;
            if (action.teamIndex == 0) {
                teamTableView = teamAPlayerView;
            } else {
                teamTableView = teamBPlayerView;
            }
            
            for (BBPlayer *plr in teamTableView.players) {
                if (plr.index == action.playerIndex) {
                    player = plr;
                    break;
                }
            }
            if (action.actionType == ACTION_TYPE_PLAYERON) {
                [player addBeginTime:action.actionTime];
                [player setIsSubbedOnWithoutNotify:YES];
            } else if (action.actionType == ACTION_TYPE_PLAYEROFF){
                [player addEndTime:action.actionTime];
                [player setIsSubbedOnWithoutNotify:NO];
            }
            [arrActions addObject:action];
        }
        F_RELEASE(arrSubbing);
    }
}
- (void)clockViewDidTapToStart:(BBClockView *)clockView{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationClockDidStart
                                                        object:nil];

}
- (void)clockViewDidStart:(BBClockView *)clockView{
    ////
    NSArray *arrTeamA = [teamAPlayerView arrayOfSelectedPlayer];
    NSArray *arrTeamB = [teamBPlayerView arrayOfSelectedPlayer];
    F_RELEASE(bbAction);
    BOOL shouldRemind = ![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefauluKey_DontRemindLessThan5] boolValue];
    if (arrTeamA.count < 2) {
        [_clockView stopCountDownTimer];
//        [actionBoxView_Scoring setEnable:NO];
//        [actionBoxView_Statistics setEnable:NO];
        [CommonUtils showAlertViewWithTag:ALERTVIEW_TAG_NOT_ENOUGH_PLAYER
                                 delegate:self
                                withTitle:LOCALIZE(@"")
                                  message:LOCALIZE(kMessageNotEnoughPlayer) 
                        cancelButtonTitle:LOCALIZE(kButtonTitleOk)
                        otherButtonTitles:nil];
        return;
    }  else if (arrTeamA.count > 5 || arrTeamB.count > 5){
        [_clockView stopCountDownTimer];

        [CommonUtils showAlertViewWithTag:ALERTVIEW_TAG_NOT_ENOUGH_PLAYER
                                 delegate:self
                                withTitle:LOCALIZE(@"")
                                  message:LOCALIZE(kMessageMoreThan5PlayersInTeam) 
                        cancelButtonTitle:LOCALIZE(kButtonTitleOk)
                        otherButtonTitles:nil];
        return;
    } else if (((arrTeamA.count < 5 || (arrTeamB.count < 5 && !shouldIgnoreTeamB)) || arrTeamA.count > 5) && shouldRemind && !shouldStartWithLessThan5Players && numberOfIgnorance == 0){
        [_clockView stopCountDownTimer];

        if (!shouldIgnoreTeamB) {
            [CommonUtils showAlertViewWithTag:ALERTVIEW_TAG_LESSTHAN5PLAYER
                                     delegate:self
                                    withTitle:LOCALIZE(@"")
                                      message:LOCALIZE(kMessageLessThan5PlayersInTeam)
                            cancelButtonTitle:LOCALIZE(kButtonTitleIWillFix)
                            otherButtonTitles:LOCALIZE(kButtonTitleIgnore),LOCALIZE(kButtonTitleDonRemindAgain),LOCALIZE(kButtonTitleIgnoreB),nil];
        } else {
            [CommonUtils showAlertViewWithTag:ALERTVIEW_TAG_LESSTHAN5PLAYER
                                     delegate:self
                                    withTitle:LOCALIZE(@"")
                                      message:LOCALIZE(kMessageLessThan5PlayersInTeam)
                            cancelButtonTitle:LOCALIZE(kButtonTitleIWillFix)
                            otherButtonTitles:LOCALIZE(kButtonTitleIgnore),LOCALIZE(kButtonTitleDonRemindAgain),nil];
        }
        [self toggleAddPlayerButton:YES];
        return;
        
    } else if (teamAPlayerView.hasPlayerReachedTheFoulLimit || teamBPlayerView.hasPlayerReachedTheFoulLimit) {
        if (!shouldIgnoreSubOffFoulPlayer) {
            [_clockView stop];
            [CommonUtils displayAlertWithTitle:nil
                                       message:kMessageHasPlayerThatReachedLimit
                                   cancelTitle:LOCALIZE(kButtonTitleIgnore)
                                           tag:ALERTVIEW_TAG_PLAYER_REACH_LIMIT
                                      delegate:self
                             otherButtonTitles:LOCALIZE(kButtonTitleOk),nil];
        } else{
            shouldIgnoreSubOffFoulPlayer = NO;
            goto ignoreSubbedPlayer;
        }
    }

    else {
    ignoreSubbedPlayer:
        if (isStartANewMatch) {
            [btnDisableClock setEnabled:NO];
            [btnRemovePlayer setEnabled:NO];

            [[DataManager defaultManager] setPeriod:period];
            isStartANewMatch = NO;

            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (isStartANewPeriod) {
            [self initialAction];
            [bbAction setActionType:ACTION_TYPE_QRTSTART];
            [bbAction setActionTime:clockView.remainTime];
            [self saveAction];
            isStartANewPeriod = NO;
        }
        if (shouldIgnoreTeamB) {
            [(BBPlayer*)[teamBPlayerView.players objectAtIndex:0] setIsSelected:YES];
        }
        [teamA setIsEditable:NO];
        [teamB setIsEditable:NO];
        [leftTimeOut setEnable:YES];
        [rightTimeOut setEnable:YES];
        isEditingAction = NO;
        [teamAPlayerView setEnable:NO];
        [teamBPlayerView setEnable:NO];
//        [shotGraphicView setEnable:NO];
        
        PLAYER_APPEARANCE appearance;
        if (period < 3) {
            appearance = PLAYER_APPEARANCE_FIRSTHALF;
        } else {
            appearance = PLAYER_APPEARANCE_SECONDHALF;
        }
        for (BBPlayer *player in teamAPlayerView.players) {
            if (player.isSelected) {
                [player addAppearsAtHalf:appearance];
            }
        }
        
        for (BBPlayer *player in teamBPlayerView.players) {
            if (player.isSelected) {
                [player addAppearsAtHalf:appearance];
            }
        }

        [teamAPlayerView start];
        [teamBPlayerView start];
        [actionBoxView_Scoring setEnable:YES];
        [actionBoxView_Statistics setEnable:YES];
        [actionBoxView_Scoring setFlashing:YES];
        [actionBoxView_Statistics setFlashing:YES];
        [self didChangeContMode:nil];
        isSubbing = NO;
        NSLog(@"Clock did start");
        [self toggleAddPlayerButton:NO];
        ///Disable Done button
        isInFreeShot = NO;
        numberOfFreeShots = 0;
        [leftDoneButton setEnabled:NO];
        [rightDoneButton setEnabled:NO];
    }
    numberOfIgnorance = 0;
    [self addSubbingAction];
}

- (void)clockViewDidEndOfPeriod:(BBClockView *)clockView{
    NSLog(@"End of period");
    if (!isSubbing) {
        [teamA setIsEditable:YES];
        [teamB setIsEditable:YES];

        if (/*!bbAction && */period < 4 && period > 0) {
            [btnPeriodEnd setEnabled:YES];
            [btnPeriodEnd toggleFlashing:YES];
        }
        if (period % 2 == 0 && period > 0) {
            [btnEnd setEnabled:YES];
            [btnEnd toggleFlashing:YES];
        }
        [self completeTimeOn];
        for (BBPlayer *player in teamAPlayerView.players) {
            [player endOfPeriod];
        }
        for (BBPlayer *player in teamBPlayerView.players) {
            [player endOfPeriod];
        }
        
        [leftSub setHidden:YES];
        [rightSub setHidden:YES];
    }
}


#pragma mark - Handling notification
     
- (void) shotPinDidChangeValue:(NSNotification*)notification{
    if (!bbAction) {
        [self initialAction];
    }    
    if (bbAction.teamIndex > -1) {
        [leftDoneButton setEnabled:YES];
        [rightDoneButton setEnabled:YES];
        [leftDoneButton toggleFlashing:YES];
        [rightDoneButton toggleFlashing:YES];
        
        BBShotPin *shotPin = (BBShotPin*)[notification object];
        [bbAction setActionLocation:shotPin.location];
        NSLog(@"Did change value of shot pin");

    }
    [self checkCompletenessOfInfomation];
}
- (void) playerViewDidLongPressed:(NSNotification*)notification{
//    [teamAPlayerView setEnable:NO];
//    [teamBPlayerView setEnable:NO];
    [self.view setUserInteractionEnabled:NO];
    [tfHiddenPlayerView becomeFirstResponder];
    editingPlayerView = [notification object];
    tfPlayerNum.text = editingPlayerView.player.number;
    tfPlayerName.text = editingPlayerView.player.name;
}

- (IBAction)exitButtonDidTap:(id)sender{
    [CommonUtils displayAlertWithTitle:nil
                               message:LOCALIZE(kMessageConfirmTurnOff)
                           cancelTitle:kButtonTitleNo
                                   tag:ALERTVIEW_TAG_QUIT
                              delegate:self
                     otherButtonTitles:kButtonTitleYes, nil];
}
- (IBAction) startEditingTeamName:(id)sender{
    onEditingTeamName = sender;
    [tfHiddenTeam becomeFirstResponder];
}

- (IBAction)cancelEdit:(id)sender{
    [tfPlayerName resignFirstResponder];
    [tfPlayerNum resignFirstResponder];
    [tfTeamName resignFirstResponder];
    
}
- (IBAction)doneEditingPlayerViewWithNumberOnly:(id)sender{
    [tfPlayerName setText:@""];
    if (tfPlayerNum.text.length > 0) {
        if (editingPlayerView.tag == 1) {
            shouldIgnoreTeamB = NO;
        }
        [editingPlayerView setNumber:[[tfPlayerNum text] intValue]];
        [editingPlayerView setName:@""];
    }
    [editingPlayerView.player setIsSelected:NO];
    [tfPlayerName resignFirstResponder];
    [tfPlayerNum resignFirstResponder];
    
    
    [tfPlayerNum setText:@""];
    [tfPlayerName setText:@""];
    
    NSInteger teamIndex = editingPlayerView.player.teamIndex;
    BBPlayerTableView *playerTableView = nil;
    if (teamIndex == 0) {
        playerTableView = teamAPlayerView;
    } else {
        playerTableView = teamBPlayerView;
    }
    
    [playerTableView sortPlayersByNumber];
//    [playerTableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                   withRowAnimation:UITableViewRowAnimationAutomatic];
    editingPlayerView = nil;
    [self.view setUserInteractionEnabled:YES];
}

- (IBAction)removePlayerFromTeam:(id)sender{
    BBPlayerTableView *playerTableView = nil;
    BBPlayer *player = editingPlayerView.player;
    if (player.teamIndex == 0) {
        playerTableView = teamAPlayerView;
    } else {
        playerTableView = teamBPlayerView;
    }
    [playerTableView removePlayer:editingPlayerView.player];
    editingPlayerView = nil;
    [tfPlayerName resignFirstResponder];
    [tfPlayerNum resignFirstResponder];
    [self saveTeam];
}
- (IBAction)doneEditingPlayerView:(id)sender{
    [tfPlayerName resignFirstResponder];
    [tfPlayerNum resignFirstResponder];
    [self.view setUserInteractionEnabled:YES];
    if (editingPlayerView) {
        NSString *name = [tfPlayerName.text capitalizedString];
        if (name && name.length > 0 && tfPlayerNum.text.length > 0) {
            if (tfPlayerNum.text.length > 0) {
                [editingPlayerView setNumber:[[tfPlayerNum text] intValue]];
            }
            if (tfPlayerName.text.length > 0) {
                [[DataManager defaultManager] addPlayerName:name];
            }
            [editingPlayerView  setName:name];
        }
        [editingPlayerView.player setIsSelected:NO];
        [editingPlayerView setNeedsLayout];
    }
    [tfPlayerNum setText:@""];
    [tfPlayerName setText:@""];
    
    NSInteger teamIndex = editingPlayerView.player.teamIndex;
    BBPlayerTableView *playerTableView = nil;
    if (teamIndex == 0) {
        playerTableView = teamAPlayerView;
    } else {
        playerTableView = teamBPlayerView;
    }
    
    [playerTableView sortPlayersByNumber];  
    editingPlayerView = nil;
    
    [self saveTeam];
}

- (void) saveTeam{
    [[NSUserDefaults standardUserDefaults] setObject:[teamAPlayerView arrayOfPlayer]
                                              forKey:[teamA teamName]];
    [[NSUserDefaults standardUserDefaults] setObject:[teamBPlayerView arrayOfPlayer]
                                              forKey:[teamB teamName]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void) toggleAddPlayerButton:(BOOL)visible{
    [teamAPlayerView toggleAddPlayerButtonVisible:visible];

    [teamBPlayerView toggleAddPlayerButtonVisible:(shouldIgnoreTeamB)?NO:visible];
}
- (void) showAddPlayerButtonInView:(BBTeamPlayerView*)teamPlayerView{
    
//    NSInteger index = -1;
//    for (int i = 0; i < kNumberOfPlayer; ++i) {
//        UIView *subview = [teamPlayerView.subviews objectAtIndex:i];
//        if (subview.hidden) {
//            index = i;
//            break;
//        }
//    }
//    if (index > -1) {
//        BBPlayerView *playerView = [teamPlayerView.subviews objectAtIndex:index];
//        UIButton *button = nil;
//        if (teamPlayerView == teamAPlayerView) {
//            button = addPlayerA;
//        } else {
//            button = addPlayerB;
//        }
//        CGRect frame = button.frame;
//        frame.origin.y = playerView.frame.origin.y;
//        if (teamPlayerView == teamAPlayerView) {
//            frame.origin.x = 15;
//        }
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                            [button setFrame:frame];                             
//                         } completion:^(BOOL finished) {
//                             if (!button.superview) {
//                                 [teamPlayerView addSubview:button];
//                             }                             
//                         }];
//
//    } else {
//        UIButton *button = nil;
//        if (teamPlayerView == teamAPlayerView) {
//            button = addPlayerA;
//        } else {
//            button = addPlayerB;
//        }
//        [button removeFromSuperview];
//    }
}

- (IBAction)doneEditingTeamName:(id)sender{
    NSString *name = nil;
    if (![tfTeamName.text isEqualToString:DEFAULTNAME_TEAMA] && ![tfTeamName.text isEqualToString:DEFAULTNAME_TEAMB]) {
        name = [tfTeamName.text capitalizedString];
    } else {
        name = @"";
    }
    [self.view setUserInteractionEnabled:YES];
    if ([name length] > 0) {
        [onEditingTeamName setTeamName:name];
        [[DataManager defaultManager] addTeamName:name];
    } else {
        if (onEditingTeamName == teamA) {
            [onEditingTeamName setTeamName:DEFAULTNAME_TEAMA];
        }
        else {
            [onEditingTeamName setTeamName:DEFAULTNAME_TEAMB];
        }
    }
    [tfTeamName resignFirstResponder];
    [tfHiddenTeam resignFirstResponder];
    [tfTeamName setText:@""];
    if (onEditingTeamName == teamA) {
        [teamAPlayerView setPlayerInfoWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:name]];
    } else {
        [teamBPlayerView setPlayerInfoWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:name]];
    }


}




#pragma mark - BBTeamNameViewDelegate
- (void)teamNameViewDidTechFoul:(BBTeamNameView *)teamName{
    isFouled = YES;
    [teamA toggleFlashing:NO];
    [teamB toggleFlashing:NO];
    if (teamName == teamA) {
        [teamB setIsSelected:NO];
    } else {
        [teamA setIsSelected:NO];
    }
    [teamAPlayerView setFlashing:NO];
    [teamBPlayerView setFlashing:NO];
    [teamAPlayerView deselectAll];  
    [teamBPlayerView deselectAll];
    [leftDoneButton setEnabled:YES];
    [rightDoneButton setEnabled:YES];
    if (bbAction.teamIndex == -1) {
        [leftDoneButton toggleFlashing:YES];
        [rightDoneButton toggleFlashing:YES];
    }
    [bbAction setTeamIndex:teamName.tag];
    [bbAction setPlayerIndex:0];
}
- (void)teamNameViewDidTapped:(BBTeamNameView *)teamName{
    if (!popOverViewController || !popOverViewController.isPopoverVisible) {
        [self displayTeamNameSuggestionPopOverWithTeam:teamName];
    }
}

- (void) addNewTeamName:(BBTeamNameView*)teamName{
    [popOverViewController dismissPopoverAnimated:YES];
    onEditingTeamName = currentTeamName;
    [self.view setUserInteractionEnabled:NO];
    [tfHiddenTeam becomeFirstResponder];
}
- (void)teamNameViewDidLongPressed:(BBTeamNameView *)teamName{

}


#pragma mark - Handling keyboard notification
- (void) keyBoardDidShow:(NSNotification*)notification{
    if ([tfHiddenTeam isFirstResponder]) {
        [tfTeamName becomeFirstResponder];
    } 
    else if([tfHiddenPlayerView isFirstResponder]){
        [tfPlayerName becomeFirstResponder];
    }
}

- (void) keyBoardDidHide:(NSNotification*)notification{
    NSLog(@"Keyboard did hide");
    if (popOverContentViewController) {
        [popOverViewController dismissPopoverAnimated:YES];
    }
    if (currentTeamName) {
        [currentTeamName setTeamName:currentTeamName.teamName];
    }
    [tfPlayerName setText:@""];
    [tfPlayerNum setText:@""];
    [tfTeamName setText:@""];
    if (editingPlayerView) {
        [editingPlayerView.player setIsSelected:NO];
        editingPlayerView = nil;
    }
    [self.view setUserInteractionEnabled:YES];
}
#pragma mark - BBTeamPlayerViewDelegate
- (void)playerViewDidSubbedOff:(BBPlayerView *)playerView{
    NSInteger playerIndex = [playerView.superview.subviews indexOfObject:playerView]+1;
    NSInteger teamIndex = playerView.superview.tag;
    NSInteger time = [_clockView remainTime];
    BBActionRef *newAction = [[BBActionRef alloc] init];
    [newAction setPlayerIndex:playerIndex];
    [newAction setTeamIndex:teamIndex];
    [newAction setActionTime:time];
    [newAction setActionType:ACTION_TYPE_PLAYEROFF];
    [newAction setPeriod:period];
    if (!arrSubbing) {
        arrSubbing = [[NSMutableArray alloc] init];
    }
    if (!isSubbing) {
        NSInteger count = 0;
    redo:
        for (BBActionRef *action in arrSubbing) {
            if (action.teamIndex == teamIndex && action.playerIndex == playerIndex && action.actionTime <= time) {
//                if (action.actionType == ACTION_TYPE_PLAYERON) {
                    [arrSubbing removeObject:action];
                count ++;
                goto redo;
//                }
//                return;
            }
        }
        if (count % 2 == 0) {
            [arrSubbing addObject:newAction];
        }
    } else {

    }
    F_RELEASE(newAction);
}
    

- (void)playerViewDidSubbedOn:(BBPlayerView *)playerView{
    NSInteger playerIndex = [playerView.superview.subviews indexOfObject:playerView]+1;
    NSInteger teamIndex = playerView.superview.tag;
    NSInteger time = [_clockView remainTime];
    BBActionRef *newAction = [[BBActionRef alloc] init];
    [newAction setPlayerIndex:playerIndex];
    [newAction setTeamIndex:teamIndex];
    [newAction setActionTime:time];
    [newAction setActionType:ACTION_TYPE_PLAYERON];
    if (!isSubbing) {
        if (!arrSubbing) {
            arrSubbing = [[NSMutableArray alloc] init];
        }
        NSInteger count = 0;
    redo:
        for (BBActionRef *action in arrSubbing) {
            if (action.teamIndex == teamIndex && action.playerIndex == playerIndex && action.actionTime <= time) {
//                if (action.actionType == ACTION_TYPE_PLAYEROFF) {
                    [arrSubbing removeObject:action];
                count ++;
                goto redo;
//                }
//                return;
            }
        }
        if (count % 2 == 0) {
            [arrSubbing addObject:newAction];   
        }
    } else {
//        for (BBAction *action in arrSubbing) {
//            if (action.teamIndex == teamIndex && action.playerIndex == playerIndex) {
//                [arrSubbing removeObject:action];
//                return;
//            }
//        }
//        [arrSubbing addObject:newAction];
    }
    F_RELEASE(newAction);
}
- (void)playerViewDidTapped:(BBPlayerView *)playerView{
    [leftDoneButton setEnabled:YES];
    [rightDoneButton setEnabled:YES];
    [teamA setIsSelected:NO];
    [teamB setIsSelected:NO];

    if (playerView.superview.tag == TEAMPLAYERVIEW_TAG_A) {

        [teamBPlayerView deselectAll];
    }
    else {

        [teamAPlayerView deselectAll];
    }
    
    
    [self playerDidChooseWithIndex:playerView.index
                       inTeamIndex:playerView.superview.tag isOnAction:playerView.isOnAction];
}


#pragma mark - BBToggleButtonViewDelegate
- (void)toggleButtonView:(BBActionBoxView *)toggleButtonView actionViewDidTapped:(BBActionView *)actionView{
    if ((!bbAction && !_clockView.isRunning && actionView.tag !=ACTION_TYPE_TECHFOUL && !isFouled && _clockView.remainTime > 0) || (actionView.tag == ACTION_TYPE_TECHFOUL && teamAPlayerView.arrayOfSelectedPlayer.count < 2)) {
        [CommonUtils displayAlertWithTitle:nil
                                   message:kMessageNotTurnOnClockYet
                               cancelTitle:LOCALIZE(kButtonTitleOk)
                                       tag:ALERTVIEW_TAG_CLOCK_NOT_RUNNING
                                  delegate:self
                         otherButtonTitles:nil];
        [toggleButtonView deselectAll];
        return;
    } else if (actionView.tag == ACTION_TYPE_TECHFOUL && isFouled && teamAPlayerView.arrayOfSelectedPlayer.count < 2){
        [toggleButtonView deselectAll];
        return;
    }
    if (!bbAction) {
        [self initialAction];
        [self toggleAddPlayerButton:NO];
    }
//    [bbAction setActionLocation:CGPointZero];
//    [toggleButtonView setEnable:NO];
    [actionView setSelected:YES];
    [bbAction setActionType:[actionView tag]];
    [shotGraphicView setActionType:[actionView tag]];
    
    if (!isEditingAction) {
        [actionBoxView_Scoring setFlashing:NO];
        [actionBoxView_Statistics setFlashing:NO];
        if (bbAction.actionType == ACTION_TYPE_FOUL || bbAction.actionType == ACTION_TYPE_TECHFOUL || bbAction.actionType == ACTION_TYPE_FOUL1 || bbAction.actionType == ACTION_TYPE_FOUL2 || bbAction.actionType == ACTION_TYPE_FOUL3){
            if (!_clockView.isContMode) {
                [_clockView stopByFoul:bbAction.actionType];
            } else {
                switch (bbAction.actionType) {
                    case ACTION_TYPE_FOUL:
                        numberOfFreeShots = 0;
                        break;
                    case ACTION_TYPE_FOUL1:
                        numberOfFreeShots = kFoul1FreeShots;
                        break;
                    case ACTION_TYPE_FOUL2:
                        numberOfFreeShots = kFoul2FreeShots;
                        break;
                    case ACTION_TYPE_FOUL3:
                        numberOfFreeShots = kFoul3FreeShots;
                        break;
                    case ACTION_TYPE_TECHFOUL:
                        numberOfFreeShots = 2;
                    default:
                        break;
                }
//                numberOfFreeShots = 0;
            }
        } else {
            if (!isFouled) {
                freeShotCount = 0;
                freeShotTeamIndex = -1;
                if ((bbAction.actionType == ACTION_TYPE_TWOMADE || bbAction.actionType == ACTION_TYPE_THREEMADE) && _clockView.isAllMode) {
                    [_clockView stop];
                }
            } else {
                BBPlayerTableView *freeshotTeam = nil;
                if (freeShotTeamIndex == 0) {
                    freeshotTeam = teamAPlayerView;
                } else {
                    freeshotTeam = teamBPlayerView;
                }
                if (freeshotTeam.arrayOfSelectedPlayer.count == 0) {
                    BBTeamNameView *teamNameView;
                    if (freeShotTeamIndex == 0) {
                        teamNameView = teamA;
                    } else {
                        teamNameView = teamB;
                    }
                    
                    [teamNameView setIsInTechFoul:YES];
                }
            }
        }
        if (bbAction.teamIndex == -1 && bbAction.playerIndex == 0) {
            if (isFouled || isInFreeShot) {
                if (freeShotTeamIndex == 0) {
                    //20/01/13
                    if (lastPlayerIndex == -1) {
                        [teamAPlayerView setFlashing:YES];
                        [teamAPlayerView setEnable:YES];

                    } else {
                        [teamAPlayerView setEnable:YES];
                        [teamAPlayerView setFlashing:YES
                                             atIndex:lastPlayerIndex];
                    }
                } else {
                    if (lastPlayerIndex == -1) {
                        [teamBPlayerView setFlashing:YES];
                        [teamBPlayerView setEnable:YES];

                    } else {
                        [teamBPlayerView setEnable:YES];
                        [teamBPlayerView setFlashing:YES
                                             atIndex:lastPlayerIndex];
                    }
                }
                [bbAction setTeamIndex:freeShotTeamIndex];
            } else {
                [teamAPlayerView setEnable:YES];
                [teamBPlayerView setEnable:YES];
                [teamAPlayerView setFlashing:YES];
                [teamBPlayerView setFlashing:YES];
            }

        }
    } else{
        if (bbAction.actionType == ACTION_TYPE_TWOMADE || bbAction.actionType == ACTION_TYPE_TWOMISS || bbAction.actionType == ACTION_TYPE_THREEMADE || bbAction.actionType == ACTION_TYPE_THREEMISS) {
            [shotGraphicView setEnable:YES];
            if (((bbAction.actionType == ACTION_TYPE_TWOMADE || bbAction.actionType == ACTION_TYPE_TWOMISS) && [shotGraphicView score] == 3) ||((bbAction.actionType == ACTION_TYPE_THREEMADE || bbAction.actionType == ACTION_TYPE_THREEMISS) && [shotGraphicView score] == 2)) {
                [shotGraphicView clear];
            }
        }
    }
    
    if (bbAction.actionType != ACTION_TYPE_THREEMADE && bbAction.actionType != ACTION_TYPE_THREEMISS && bbAction.actionType != ACTION_TYPE_TWOMADE && bbAction.actionType != ACTION_TYPE_TWOMISS) {
        [bbAction setActionLocation:CGPointZero];
        [shotGraphicView clear];
        [shotGraphicView setEnable:NO];
        if (bbAction.playerIndex > 0 && bbAction.teamIndex > -1) {
            [leftDoneButton toggleFlashing:YES];
            [rightDoneButton toggleFlashing:YES];
        }
    } else{
        if (bbAction.actionType == ACTION_TYPE_TWOMADE || bbAction.actionType == ACTION_TYPE_THREEMADE) {
            if (shotGraphicView.shotPin.superview == shotGraphicView) {
                [shotGraphicView shotPinSetMade];
            }
        } else {
            if (shotGraphicView.shotPin.superview == shotGraphicView) {
                [shotGraphicView shotPinSetMiss];
            }
        }
    }
    if (bbAction.actionType == ACTION_TYPE_TECHFOUL) {
        [teamA setIsInTechFoul:YES];
        [teamB setIsInTechFoul:YES];
    } else {
        [teamA setIsInTechFoul:NO];
        [teamB setIsInTechFoul:NO];
    }
    if (bbAction.actionType == ACTION_TYPE_FOUL || bbAction.actionType == ACTION_TYPE_FOUL1 || bbAction.actionType == ACTION_TYPE_FOUL2 || bbAction.actionType == ACTION_TYPE_FOUL3){
        if (bbAction.actionType != ACTION_TYPE_TECHFOUL) {
//            if (teamBPlayerView.arrayOfSelectedPlayerView.count == 0) {
//                [teamB setIsInTechFoul:YES];
//            }
        }
    }
    [actionBoxView_Scoring setFlashing:NO];
    [actionBoxView_Statistics setFlashing:NO];
    [actionBoxView_Freeshot setFlashing:NO];

    BBActionBoxView *another = nil;
    if (toggleButtonView == actionBoxView_Scoring) {
        another = actionBoxView_Statistics;
    } else {
        another = actionBoxView_Scoring;
    }
    
    [another selectActionType:actionView.tag];
    
//    [self checkCompletenessOfInfomation];

    NSLog(@"Did select action");
}


#pragma mark - BBTimeOutViewDelegate
- (void)timeOutViewDidIncreaseValue:(BBTimeOutView *)timeOutView{
    isEditingFreeShot = NO;
    F_RELEASE(arrSubbing);
    F_RELEASE(bbAction);
    [self initialAction];
    [bbAction setActionType:ACTION_TYPE_TIMEOUT];
    [bbAction setTeamIndex:timeOutView.tag];
    [self saveAction];
    [_clockView stop];

    
    [actionBoxView_Scoring deselectAll];
    [actionBoxView_Statistics deselectAll];
    
    [shotGraphicView setEnable:NO];
    
    [teamA setIsEditable:YES];
    [teamB setIsEditable:YES];
    
    [leftDoneButton setEnabled:NO];
    [leftDoneButton toggleFlashing:NO];
    [rightDoneButton setEnabled:NO];
    [rightDoneButton toggleFlashing:NO];
//    [actionBoxView_Scoring setEnable:NO];
//    [actionBoxView_Statistics setEnable:NO];
    [actionBoxView_Statistics setFlashing:NO];
    [actionBoxView_Scoring setFlashing:NO];
    [teamAPlayerView setFlashing:NO];
    [teamBPlayerView setFlashing:NO];
    [teamAPlayerView stop];
    [teamBPlayerView stop];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == ALERTVIEW_TAG_RESETTEAMFOUL) {
        if (buttonIndex == 0) {
            [leftFouls reset];
            [rightFouls reset];
            BBActionView *actionView = (BBActionView*)[actionBoxView_Statistics viewWithTag:ACTION_TYPE_FOUL2];
            [actionView setImage:[UIImage imageNamed:@"foul21.png"]
                        forState:UIControlStateNormal];
            [actionView setImage:[UIImage imageNamed:@"foul22.png"]
                        forState:UIControlStateSelected];
            actionView = (BBActionView*)[actionBoxView_Scoring viewWithTag:ACTION_TYPE_FOUL2];
            [actionView setImage:[UIImage imageNamed:@"foul21_scoring.png"]
                        forState:UIControlStateNormal];
            [actionView setImage:[UIImage imageNamed:@"foul22_scoring.png"]
                        forState:UIControlStateSelected];

        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:LOCALIZE(kMessageConfirmResetTeamTimeOut)
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:LOCALIZE(kButtonTitleYes),LOCALIZE(kButtonTitleNo), nil];
        [alert setTag:ALERTVIEW_TAG_RESETTEAMTIMEOUT];
        [alert show];
        F_RELEASE(alert);
    } else if (alertView.tag == ALERTVIEW_TAG_RESETTEAMTIMEOUT){
        if (buttonIndex == 0) {
            [leftTimeOut reset];
            [rightTimeOut reset];
        }

    } else if (alertView.tag == ALERTVIEW_TAG_DELETEINFOTEAM){
        if (buttonIndex == 1){
            [teamAPlayerView reset];
            [teamA setTeamName:DEFAULTNAME_TEAMA];
        } else if (buttonIndex == 2){
            [teamBPlayerView reset];
            [teamB setTeamName:DEFAULTNAME_TEAMB];
        } else if (buttonIndex == 3) {
            [teamAPlayerView reset];
            [teamA setTeamName:DEFAULTNAME_TEAMA];
            [teamBPlayerView reset];
            [teamB setTeamName:DEFAULTNAME_TEAMB];
        }
    }else if (alertView.tag == ALERTVIEW_TAG_LESSTHAN5PLAYER){
        if (buttonIndex == 1) { //Ignore Team B
            numberOfIgnorance = 1;
            if (teamBPlayerView.arrayOfSelectedPlayer.count == 0) {
                BBPlayer *player = [[BBPlayer alloc] init];
                [player setNumber:@"-1"];
                [player setName:@""];
                [player setIsSelected:YES];
                [teamBPlayerView setPlayers:[NSArray arrayWithObject:player]];
            }
            [btnDisableClock setEnabled:NO];
            [_clockView start];
        } else if (buttonIndex == 2){ //Ignore all
            shouldStartWithLessThan5Players = YES;
            if (teamBPlayerView.arrayOfSelectedPlayer.count == 0) {
                BBPlayer *player = [[BBPlayer alloc] init];
                [player setNumber:@"-1"];
                [player setName:@""];
                [player setIsSelected:YES];
                [teamBPlayerView setPlayers:[NSArray arrayWithObject:player]];
                shouldIgnoreTeamB = YES;
            }
            [btnDisableClock setEnabled:NO];
            [_clockView start];
        } else if (buttonIndex == 3) {
            [self ignoreTeamB];
        }
    } else if (alertView.tag == ALERTVIEW_TAG_QUIT){
        if (buttonIndex == 1) {
            [self dismissModalViewControllerAnimated:YES];
            [DataManager userDefaultRemoveObjectForKey:kKey_QuickSave];

        }
    } else if (alertView.tag == ALERTVIEW_TAG_PLAYER_REACH_LIMIT){
        if (buttonIndex == 0) {
            shouldIgnoreSubOffFoulPlayer = YES;
            [_clockView start];
        } else {
            [teamAPlayerView stop];
            [teamBPlayerView stop];
        }
    } else if (alertView.tag == ALERTVIEW_TAG_TEAM_REACH_LIMIT){
//        [_clockView start];
    } else if (alertView.tag == ALERTVIEW_TAG_CONFIRM_LOAD_PREVIOUSDATA){
        if (buttonIndex == 0) {
            if (previousDataHasLoaded) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:LOCALIZE(kActionSheetTitle_DeleteTeamInfo)
                                                               delegate:self
                                                      cancelButtonTitle:LOCALIZE(kButtonTitleKeepBoth)
                                                      otherButtonTitles:LOCALIZE(kButtonTitleDeleteA),LOCALIZE(kButtonTitleDeleteB),LOCALIZE(kButtonTitleDeleteAll), nil];
                [alert setTag:ALERTVIEW_TAG_DELETEINFOTEAM];
                [alert show];
                [alert release];
            }
        } else if (buttonIndex == 1){
            [self loadPreviousMatchData];
        }
    } else if (alertView.tag == ALERTVIEW_TAG_DISABLE_CLOCK){
        NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if ([btnTitle isEqualToString:@"Yes"]) {
            [self disableClock];
        }
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (popOverDataSource) {
        return popOverDataSource.count;
    }    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *textLabel = nil;
    NSString *reusableIdentifier = nil;
    UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
    BOOL isReplaced = NO;
    if (tableView.tag == TAG_AUTOFILLTABLEVIEW_TEAM || tableView.tag == TAG_AUTOFILLTABLEVIEW_PLAYER) {
        textLabel = (NSString*)[popOverDataSource objectAtIndex:indexPath.row];
        reusableIdentifier = REUSABLE_IDENTIFIER_AUTOFILL;
        cellStyle = UITableViewCellStyleDefault;
    }
    else if (tableView.tag == TAG_SUGGESTIONTABLEVIEW){
        textLabel = (NSString*)[popOverDataSource objectAtIndex:indexPath.row];
        reusableIdentifier = REUSABLE_IDENTIFIER_TEAMSUGGESTION;
        cellStyle = UITableViewCellStyleDefault;
    }
    else if (tableView.tag == TAG_ACTIONLISTTABLEVIEW){
        cellStyle = UITableViewCellStyleDefault;
        reusableIdentifier = REUSABLE_IDENTIFIER_ACTIONLIST;
        textLabel = [arrActionNames objectAtIndex:indexPath.row];
        BBActionRef *action = [popOverDataSource objectAtIndex:indexPath.row];
        isReplaced = [action isReplaced];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:reusableIdentifier] autorelease];
    }
    if (tableView.tag != TAG_ACTIONLISTTABLEVIEW) {
        //        [cell.textLabel setTextColor:[UIColor whiteColor]];
    } else {
        if (isReplaced) {
            [cell.contentView setBackgroundColor:[UIColor grayColor]];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setTextColor:[UIColor lightGrayColor]];
            [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        } else {
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        }
    }
    [cell.textLabel setText:textLabel];
    return cell;
}


#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == TAG_ACTIONLISTTABLEVIEW) {
        return NO;
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView.tag == TAG_AUTOFILLTABLEVIEW_TEAM || tableView.tag == TAG_SUGGESTIONTABLEVIEW) {
            NSString *teamName = [popOverDataSource objectAtIndex:indexPath.row];
            [DataManager deleteTeamName:teamName];
            F_RELEASE(popOverDataSource);
            popOverDataSource = [[NSArray alloc] initWithArray:[DataManager arrayOfRecordedTeamsWithKeyWord:tfTeamName.text]];
            [self setPopOverContentSizeWithNumberOfLine:popOverDataSource.count];
        } else if (tableView.tag == TAG_AUTOFILLTABLEVIEW_PLAYER) {
            NSString *playerName = [popOverDataSource objectAtIndex:indexPath.row];
            [DataManager deletePlayerName:playerName];
            F_RELEASE(popOverDataSource);
            popOverDataSource = [[NSArray alloc] initWithArray:[DataManager arrayOfRecordedPlayersNameWithKeyWord:tfPlayerName.text]];
            [self setPopOverContentSizeWithNumberOfLine:popOverDataSource.count];
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];

    }
//    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == TAG_AUTOFILLTABLEVIEW_TEAM) {
        if (tfTeamName) {
            [tfTeamName setText:(NSString*)[popOverDataSource objectAtIndex:indexPath.row]];
            [popOverViewController dismissPopoverAnimated:YES];
        }
    } else if (tableView.tag == TAG_AUTOFILLTABLEVIEW_PLAYER){
        if (tfPlayerName) {
            [tfPlayerName setText:(NSString*)[popOverDataSource objectAtIndex:indexPath.row]];
            [popOverViewController dismissPopoverAnimated:YES];
        }
    } else if (tableView.tag == TAG_ACTIONLISTTABLEVIEW){
        isEditingFreeShot = NO;
        BBActionRef *action = [popOverDataSource objectAtIndex:indexPath.row];
        if (!action.isReplaced) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWillEditAction
//                                                                object:action];
            [self editAction:action];
            [popOverViewController dismissPopoverAnimated:YES];
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        
    } else if (tableView.tag == TAG_SUGGESTIONTABLEVIEW){
        NSString *name = (NSString*)[popOverDataSource objectAtIndex:indexPath.row];
        [currentTeamName setTeamName:(NSString*)[popOverDataSource objectAtIndex:indexPath.row]];
        [popOverViewController dismissPopoverAnimated:YES];
        if (currentTeamName == teamA) {
            [teamAPlayerView setPlayerInfoWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:name]];
        } else {
            [teamBPlayerView setPlayerInfoWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:name]];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIPopOverDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"PopOver did dismissed");
    [currentTeamName setTeamName:currentTeamName.teamName];
    [teamA desellect];
    [teamB desellect];
    F_RELEASE(popOverViewController);
    F_RELEASE(popOverDataSource);
//    F_RELEASE(popOverContentViewController);
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == TAG_ACTIONSHEET_DELETEINFO) {
        if (buttonIndex == 0) {
            [teamAPlayerView reset];
            [teamA setTeamName:DEFAULTNAME_TEAMA];
            [teamBPlayerView reset];
            [teamB setTeamName:DEFAULTNAME_TEAMB];
        } else if (buttonIndex == 1){
            [teamAPlayerView reset];
            [teamA setTeamName:DEFAULTNAME_TEAMA];
        } else if (buttonIndex == 2){
            [teamBPlayerView reset];
            [teamB setTeamName:DEFAULTNAME_TEAMB];
        }
    } else if (actionSheet.tag == TAG_ACTIONSHEET_LESSTHAN5PLAYER){
        if (buttonIndex == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                                      forKey:kUserDefauluKey_DontRemindLessThan5];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [_clockView start];
        }
        [self.view setUserInteractionEnabled:YES];
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [tfPlayerNum setText:[NSString stringWithFormat:@"%d",row+1]];
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
             
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 1;
    }
    return 99;
}
                                                                       

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return @"Number";
    }
    return [NSString stringWithFormat:@"%d",row+1];
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

#pragma mark - BBPlayerCellDelegate
- (void)playerDidSelectedForAction:(BBPlayer *)player{
    [leftDoneButton setEnabled:YES];
    [rightDoneButton setEnabled:YES];
    [teamA setIsSelected:NO];
    [teamB setIsSelected:NO];
    
    if (player.teamIndex == TEAMPLAYERVIEW_TAG_A) {
        [teamBPlayerView deselectAll];
        [teamAPlayerView selectPlayerForAction:player];
    }
    else {
        [teamBPlayerView selectPlayerForAction:player];
        [teamAPlayerView deselectAll];
    }
    
    
    [self playerDidChooseWithIndex:player.index
                       inTeamIndex:player.teamIndex
                        isOnAction:player.isOnAction];
}

- (void)playerDidSubbedOff:(BBPlayer *)player{
    NSInteger playerIndex = player.index;
    NSInteger teamIndex = player.teamIndex;
    NSInteger time = [_clockView remainTime];
    BBActionRef *newAction = [[BBActionRef alloc] init];
    [newAction setPlayerIndex:playerIndex];
    [newAction setTeamIndex:teamIndex];
    [newAction setActionTime:time];
    [newAction setActionType:ACTION_TYPE_PLAYEROFF];
    [newAction setPeriod:period];
    if (!arrSubbing) {
        arrSubbing = [[NSMutableArray alloc] init];
    }
    if (!isSubbing) {
        NSInteger count = 0;
    redo:
        for (BBActionRef *action in arrSubbing) {
            if (action.teamIndex == teamIndex && action.playerIndex == playerIndex && action.actionTime <= time) {
                //                if (action.actionType == ACTION_TYPE_PLAYERON) {
                [arrSubbing removeObject:action];
                count ++;
                goto redo;
                //                }
                //                return;
            }
        }
        if (count % 2 == 0) {
            [arrSubbing addObject:newAction];
        }
    } else {
        
    }
    F_RELEASE(newAction);
}


- (void)playerDidSubbedOn:(BBPlayer *)player{
    NSInteger playerIndex = player.index;
    NSInteger teamIndex = player.teamIndex;
    NSInteger time = [_clockView remainTime];
    BBActionRef *newAction = [[BBActionRef alloc] init];
    [newAction setPlayerIndex:playerIndex];
    [newAction setTeamIndex:teamIndex];
    [newAction setActionTime:time];
    [newAction setActionType:ACTION_TYPE_PLAYERON];
    if (!isSubbing) {
        if (!arrSubbing) {
            arrSubbing = [[NSMutableArray alloc] init];
        }
        NSInteger count = 0;
    redo:
        for (BBActionRef *action in arrSubbing) {
            if (action.teamIndex == teamIndex && action.playerIndex == playerIndex && action.actionTime <= time) {
                //                if (action.actionType == ACTION_TYPE_PLAYEROFF) {
                [arrSubbing removeObject:action];
                count ++;
                goto redo;
                //                }
                //                return;
            }
        }
        if (count % 2 == 0) {
            [arrSubbing addObject:newAction];
        }
    } else {
        //        for (BBAction *action in arrSubbing) {
        //            if (action.teamIndex == teamIndex && action.playerIndex == playerIndex) {
        //                [arrSubbing removeObject:action];
        //                return;
        //            }
        //        }
        //        [arrSubbing addObject:newAction];
    }
    F_RELEASE(newAction);
}

@end
