//
//  BBNewMatchViewController.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBClockView.h"
#import "BBFoulView.h"
#import "BBPlayerView.h"
#import "BBActionBoxView.h"
#import "BBTeamPlayerView.h"
#import "BBTeamNameView.h"
#import "BBShotGraphicView.h"
#import "BBTimeOutView.h"
#import "BBScoreBoard.h"
#import "BBFlashingButton.h"
#import "BBTableViewController.h"
#import "BBStatisticOptionViewController.h"
#import "BBPlayerTableView.h"
#import "BBPlayer.h"
@interface BBNewMatchViewController : UIViewController<UITextFieldDelegate, BBClockViewDelegate, BBTeamNameViewDelegate,BBPlayerViewDelegate, BBtoggleButtonViewDelegate,UIGestureRecognizerDelegate, BBTimeOutViewDelegate,UIAlertViewDelegate, UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIWebViewDelegate, BBPlayerCellDelegate>{
    UIMenuController *menuController;
    id menuControllerSender;
    IBOutlet BBClockView *_clockView;
    IBOutlet BBFoulView *leftFouls, *rightFouls;
    IBOutlet BBTimeOutView *leftTimeOut, *rightTimeOut;
    IBOutlet BBActionBoxView *actionBoxView_Statistics, *actionBoxView_Scoring, *topActionBox, *actionBoxView_Freeshot;
    IBOutlet BBPlayerTableView *teamAPlayerView, *teamBPlayerView;
    IBOutlet UIView *actionBoxParent;
    IBOutlet UIView *inputAccessoryViewPlayer, *inputAccessoryViewTeam;
    
    IBOutlet UITextField *tfPlayerNum, *tfPlayerName;
    
    IBOutlet UITextField *tfTeamName;
    
    IBOutlet UITextField *tfHiddenPlayerView, *tfHiddenTeam;
    
    IBOutlet BBTeamNameView *teamA, *teamB;
    BBTeamNameView *currentTeamName;
    
    IBOutlet BBShotGraphicView *shotGraphicView;
    
    IBOutlet BBFlashingButton *leftDoneButton, *rightDoneButton, *btnPeriodEnd, *btnEnd;
    
    IBOutlet BBScoreBoard *scoreBoard;
    
    IBOutlet UILabel *lblPeriod;
    
    IBOutlet UIPickerView *pickerView;
    
    IBOutlet UIButton *btnEditCheck, *btnRedoLast, *leftSub, *rightSub, *addPlayerA, *addPlayerB, *leftDelete, *rightDelete, *foulA, *foulB;
    
    IBOutlet UIView *editTimeOutView;
    
    IBOutlet UIView *instructionView;
    
    IBOutlet UIWebView *instructionWebView;
    
    IBOutlet UIButton *btnRemovePlayer;
    
    IBOutlet UIButton *btnDisableClock;
    BBTeamNameView *onEditingTeamName;
    
    BBPlayerCell *editingPlayerView;
    
    BBActionRef *bbAction;
    
    NSInteger period, numberOfIgnorance;
    
    NSMutableArray *arrActions;
    
    NSMutableArray *arrSubbing;
    
    NSString *matchId;
    
    BOOL isLoadingPreviousData;
    
    BOOL isStartANewMatch;
    
    BOOL isStartANewPeriod;
    
    BOOL isEnd;
    
    BOOL isEditingAction;
    /////Set YES if the match stoped by a foul
    BOOL isInFreeShot;
    
    BOOL previousDataHasLoaded;
    
    BOOL shouldStartWithLessThan5Players;
    
    BOOL shouldIgnoreTeamB;
    
    BOOL isFouled;
    
    BOOL isEditingFreeShot;
    
    BOOL isInitialLoadActionList;
    
    BOOL isSubbing;
    
    BOOL shouldIgnoreSubOffFoulPlayer;
    
    BOOL isTechFoulByTeam;
    
    BOOL isClockDisabled;
    NSInteger freeShotTeamIndex;
    NSInteger numberOfFreeShots;
    NSInteger freeShotCount;

    NSInteger subbingCount;
    
    UIView *tempView;
    
    NSArray *popOverDataSource;
    NSArray *arrActionNames;
    UIPopoverController *popOverViewController;
    BBTableViewController *popOverContentViewController;
    
    dispatch_queue_t subbedQueue;
    CGFloat totalTimeOn;
    NSDate *matchDate;
    NSDictionary *previousMatchData;
    NSInteger lastPlayerIndex;
}
- (void) displayPopupButtonsBar:(id)sender;
- (void) dismissPopupButtonBar;


@end

