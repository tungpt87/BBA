//
//  BBScoreCardViewController.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBScoreCardViewController.h"
#import "BBMatchesListTableViewController.h"
#import "BBStatisticOptionViewController.h"

@interface BBScoreCardViewController ()

@end

@implementation BBScoreCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithMatchDictionary:(NSDictionary*)dictionary defaultName:(NSString*)defaultName{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
        if (defaultName) {
            _defaultName = [[NSString alloc] initWithString:defaultName];
        }
        [self setTitle:LOCALIZE(TITLE_SCORECARD)];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([(NSNumber*)[_dictionary objectForKey:kKey_Match_isSaved] boolValue]) {
        [btnPrint setHidden:YES];
        [btnEmail setHidden:YES];
        [btnOpen setHidden:YES];
        [btnDone setHidden:YES];
    } else {
        [btnPrint setHidden:NO];
        [btnEmail setHidden:NO];
        [btnOpen setHidden:NO];
        [btnDone setHidden:NO];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIBarButtonItem *barButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                target:self
                                                                                action:@selector(barButtonDidTap:)] autorelease];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = barButton;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    int position[kNumberOfPlayer*2];
    for (int i = 0; i < kNumberOfPlayer*2; i++) {
        position[i] = 0;
    }
    NSString *strHTML = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kFileNameScoreCardTemplate ofType:nil]
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    
    if (_defaultName && [_defaultName length] > 0) {
        strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_MATCHNAME
                                                     withString:[NSString stringWithFormat:INPUT_TEXT,HTML_ID_MATCHNAME]];
    } else {
        [lblTitle setHidden:YES];
        NSString *matchName = (NSString*)[_dictionary objectForKey:kKey_Match_MatchName];
        if (!matchName) {
            matchName = @"";
        }
        
        strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_MATCHNAME
                                                     withString:matchName];

    }
    //Parse Player number and name
    NSArray *arrPlayers = [_dictionary objectForKey:kKey_Player_TeamA];
    if (arrPlayers) {
        for (int i = 0; i < kNumberOfPlayer; ++i) {
            if (i < arrPlayers.count) {
                NSDictionary *player = (NSDictionary*)[arrPlayers objectAtIndex:i];
                position[[[player objectForKey:kKey_Player_Index] intValue]-1] = i;
                NSString *playerNoTag = [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_PLAYERNUMBER,@"A",i+1];
                if (player) {
                    NSString *playerNumber = (NSString*)[player objectForKey:kKey_PlayerNumber];
                    if (playerNumber) {
                        strHTML = [strHTML stringByReplacingOccurrencesOfString:playerNoTag
                                                                     withString:playerNumber];
                    }
                    NSString *playerName = (NSString *)[player objectForKey:kKey_PlayerName];
                    if (!playerName || playerName.length == 0) {
                        playerName = kPlayerNameUnknown;
                    }
                    if (playerName) {
                        if (playerName.length > 20) {
                            playerName = [playerName substringToIndex:17];
                            playerName = [playerName stringByAppendingString:@"..."];
                        }
                        strHTML = [strHTML stringByReplacingOccurrencesOfString: [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_PLAYERNAME,@"A",i+1]
                                                                     withString:playerName];
                    }
                    
                    //                BOOL isInTheCourt = [(NSNumber*)[player objectForKey:kKey_Player_IsInTheCourt] boolValue];
                    NSInteger halves = [[player objectForKey:kKey_Player_NumberOfHalves] intValue];
                    UIImage *oneDot = [UIImage imageNamed:@"scoreonedot.png"];
                    UIImage *twoDot = [UIImage imageNamed:@"scoretwodot.png"];
                    
                    if (halves == 1) {
                        strHTML = [strHTML stringByReplacingOccurrencesOfString:[NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_DOT,@"A",i+1]
                                                                     withString:[NSString stringWithFormat:HTML_IMG_BASE64,[UIImagePNGRepresentation(oneDot) base64Encoding]]];
                    } else if (halves == 2){
                        strHTML = [strHTML stringByReplacingOccurrencesOfString:[NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_DOT,@"A",i+1]
                                                                     withString:[NSString stringWithFormat:HTML_IMG_BASE64,[UIImagePNGRepresentation(twoDot) base64Encoding]]];
                    }
                    else {
                        strHTML = [strHTML stringByReplacingOccurrencesOfString:[NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_DOT,@"A",i+1]
                                                                     withString:@""];
                    }
                    
                }

            } else {
                NSString *playerNoTag = [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_PLAYERNUMBER,@"A",i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:playerNoTag
                                                             withString:@""];
                NSString *playerName = @"";
                if (playerName) {
                    if (playerName.length > 20) {
                        playerName = [playerName substringToIndex:17];
                        playerName = [playerName stringByAppendingString:@"..."];
                    }
                    strHTML = [strHTML stringByReplacingOccurrencesOfString: [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_PLAYERNAME,@"A",i+1]
                                                                 withString:playerName];
                }
                
                //                BOOL isInTheCourt = [(NSNumber*)[player objectForKey:kKey_Player_IsInTheCourt] boolValue];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:[NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_DOT,@"A",i+1]
                                                             withString:@""];

            }
                        
        }

    }
        
    arrPlayers = [_dictionary objectForKey:kKey_Player_TeamB];
    if (arrPlayers) {
        for (int i = 0; i < kNumberOfPlayer; ++i) {
            if (i < arrPlayers.count) {
                NSDictionary *player = (NSDictionary*)[arrPlayers objectAtIndex:i];
                position[kNumberOfPlayer+[[player objectForKey:kKey_Player_Index] intValue]-1] = i;
                NSString *playerNoTag = [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_PLAYERNUMBER,@"B",i+1];
                if (player) {
                    NSString *playerNumber = (NSString*)[player objectForKey:kKey_PlayerNumber];
                    if (playerNumber) {
                        strHTML = [strHTML stringByReplacingOccurrencesOfString:playerNoTag
                                                                     withString:playerNumber];
                    }
                    NSString *playerName = (NSString *)[player objectForKey:kKey_PlayerName];
                    if (!playerName || playerName.length == 0) {
                        playerName = kPlayerNameUnknown;
                    }
                    if (playerName) {
                        if (playerName.length > 20) {
                            playerName = [playerName substringToIndex:17];
                            playerName = [playerName stringByAppendingString:@"..."];
                        }
                        strHTML = [strHTML stringByReplacingOccurrencesOfString: [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_PLAYERNAME,@"B",i+1]
                                                                     withString:playerName];
                    }
                    NSInteger halves = [[player objectForKey:kKey_Player_NumberOfHalves] intValue];
                    UIImage *oneDot = [UIImage imageNamed:@"scoreonedot.png"];
                    UIImage *twoDot = [UIImage imageNamed:@"scoretwodot.png"];
                    
                    if (halves == 1) {
                        strHTML = [strHTML stringByReplacingOccurrencesOfString:[NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_DOT,@"B",i+1]
                                                                     withString:[NSString stringWithFormat:HTML_IMG_BASE64,[UIImagePNGRepresentation(oneDot) base64Encoding]]];
                    } else if (halves == 2){
                        strHTML = [strHTML stringByReplacingOccurrencesOfString:[NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_DOT,@"B",i+1]
                                                                     withString:[NSString stringWithFormat:HTML_IMG_BASE64,[UIImagePNGRepresentation(twoDot) base64Encoding]]];
                    }
                    else {
                        strHTML = [strHTML stringByReplacingOccurrencesOfString:[NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_DOT,@"B",i+1]
                                                                     withString:@""];
                    }
                }
            } else {
                NSString *playerNoTag = [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_PLAYERNUMBER,@"B",i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:playerNoTag
                                                             withString:@""];
                NSString *playerName = @"";
                if (playerName) {
                    if (playerName.length > 20) {
                        playerName = [playerName substringToIndex:17];
                        playerName = [playerName stringByAppendingString:@"..."];
                    }
                    strHTML = [strHTML stringByReplacingOccurrencesOfString: [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_PLAYERNAME,@"B",i+1]
                                                                 withString:playerName];
                }

                strHTML = [strHTML stringByReplacingOccurrencesOfString:[NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_DOT,@"B",i+1]
                                                                 withString:@""];

            }
        }
    }
    

    //Parse and replace score and fouls
    int score[2][12],fouls[2][12],periodScore[2][4], periodFouls[2][4], periodTimeOut[2][4], total[2];
    int techFoulA = 0,techFoulB = 0;
    total[0] = 0;
    total[1] = 0;
    for (int i = 0; i < kNumberOfPlayer; ++i) {
        score[0][i] = 0;
        score[1][i] = 0;
        fouls[0][i] = 0;
        fouls[1][i] = 0;
    }
    
    for (int i = 0; i < 4; ++i) {
        periodFouls[0][i] = 0;
        periodFouls[1][i] = 0;
        periodScore[0][i] = 0;
        periodScore[1][i] = 0;
        periodTimeOut[0][i] = 0;
        periodTimeOut[1][i] = 0;
    }
    NSArray *arrActions = [_dictionary objectForKey:kKey_Actions];
    if (arrActions) {
        for (int i = 0; i < arrActions.count; ++i) {
            NSDictionary *action = (NSDictionary*)[arrActions objectAtIndex:i];
            if (action) {
                NSInteger teamIndex = [(NSNumber*)[action objectForKey:kKey_Action_TeamIndex] intValue];
                NSInteger playerIndex = [(NSNumber*)[action objectForKey:kKey_Action_PlayerIndex] intValue];
                NSInteger periodIndex = [(NSNumber*)[action objectForKey:kKey_Action_Period] intValue];
                NSInteger s = 0;
                ACTION_TYPE actionType = [(NSNumber*)[action objectForKey:kKey_Action_ActionType] intValue];
                switch (actionType) {
                    case ACTION_TYPE_ONEMADE:
                        s = 1;
                        break;
                    case ACTION_TYPE_TWOMADE:
                        s = 2;
                        break;   
                    case ACTION_TYPE_THREEMADE:
                        s = 3;
                        break;
                    default:
                        break;
                }
                if (teamIndex >= 0) {
                    if (playerIndex > 0) {
                        score[teamIndex][position[playerIndex-1+teamIndex*kNumberOfPlayer]] += s;
                    }
                    periodScore[teamIndex][periodIndex-1] += s;
                    total[teamIndex] += s;
                }

                
                
                if (actionType == ACTION_TYPE_FOUL || actionType == ACTION_TYPE_FOUL1 || actionType == ACTION_TYPE_FOUL2 || actionType == ACTION_TYPE_FOUL3 || actionType == ACTION_TYPE_TECHFOUL) {
                    if (teamIndex >= 0) {
                        if (playerIndex > 0) {
                            fouls[teamIndex][position[playerIndex-1+teamIndex*kNumberOfPlayer]] ++;
                        }
                        periodFouls[teamIndex][periodIndex-1] ++;
                    }
                    if (actionType == ACTION_TYPE_TECHFOUL && playerIndex == 0) {
                        if (teamIndex == 0) {
                            techFoulA ++;
                        } else if (teamIndex == 1){
                            techFoulB ++;
                        }
                    }
                }
                
                if (actionType == ACTION_TYPE_TIMEOUT) {
                    if (teamIndex >= 0) {
                        periodTimeOut[teamIndex][periodIndex-1] ++;
                    }
                }
            }
        }
    }
        
    for (int j =0; j < 2; ++j) {
        NSString *teamLabel;
        if (j == 0) {
            teamLabel = @"A";
        }else {
            teamLabel = @"B";
        }
        
        NSString *tag = [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_TEAMNAME,teamLabel];
        NSString *teamName = (NSString*)[(NSArray*)[_dictionary objectForKey:kKey_TeamName] objectAtIndex:j];
        if (teamName && teamName.length > 10) {
            teamName = [[teamName substringToIndex:7] stringByAppendingString:@"..."];
        }
        if (teamName) {
            strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                         withString:teamName];
        }
        for (int i = 0; i < kNumberOfPlayer; ++i) {
            tag = [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_PLAYERSCORE,teamLabel,i+1];
            strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                         withString:[NSString stringWithFormat:@"%d",score[j][i]]];
            tag = [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_PLAYERFOULS,teamLabel,i+1];
            strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                         withString:[NSString stringWithFormat:@"%d",fouls[j][i]]];
        }
        
        
        for (int i = 0; i < 4; ++i) {
            NSString *tag = [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_SCORE,i+1,teamLabel];
            strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                         withString:[NSString stringWithFormat:@"%d",periodScore[j][i]]];
            tag = [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_FOULS,i+1,teamLabel];
            strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                         withString:[NSString stringWithFormat:@"%d",periodFouls[j][i]]];
            
            tag = [NSString stringWithFormat:HTMLFORM_SCORECARD_TAG_TIMEOUT,i+1,teamLabel];
            strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                         withString:[NSString stringWithFormat:@"%d",periodTimeOut[j][i]]];
            
        }

    }
    
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_TEAMATOTAL
                                                 withString:[NSString stringWithFormat:@"%d",total[0]]];
    
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_TEAMBTOTAL
                                                 withString:[NSString stringWithFormat:@"%d",total[1]]];

    NSString *referees  = (NSString*)[_dictionary objectForKey:kKey_Match_Referees];
    if (referees) {
        if (referees.length > 40) {
            referees = [NSString stringWithFormat:@"%@...",[referees substringToIndex:27]];
        }
        strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_REFEREES
                                                     withString:referees];
    } else {
        strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_REFEREES
                                                     withString:[NSString stringWithFormat:INPUT_TEXT,HTML_ID_REFEREES]];
    }
    NSString *timeKeeper  = (NSString*)[_dictionary objectForKey:kKey_Match_TIMEKEEPER];
    if (timeKeeper) {
        if (timeKeeper.length > 40) {
            timeKeeper = [NSString stringWithFormat:@"%@...",[timeKeeper substringToIndex:27]];
        }
        strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_TIMEKEEPER
                                                     withString:timeKeeper];
    } else {
        strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_TIMEKEEPER
                                                     withString:[NSString stringWithFormat:INPUT_TEXT,HTML_ID_TIMEKEEPER]];
    }
    NSString *scoreKeeper  = (NSString*)[_dictionary objectForKey:kKey_Match_SCOREKEEPER];
    if (scoreKeeper) {
        if (scoreKeeper.length > 40) {
            scoreKeeper = [NSString stringWithFormat:@"%@...",[scoreKeeper substringToIndex:27]];
        }
        strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_SCOREKEEPER
                                                     withString:scoreKeeper];
    } else {
        strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_SCOREKEEPER
                                                     withString:[NSString stringWithFormat:INPUT_TEXT,HTML_ID_SCOREKEEPER]];
    }
    
    NSString *teamACoach  = (NSString*)[_dictionary objectForKey:kKey_Match_TeamACoach];
    if (teamACoach) {
        if (teamACoach.length > 25) {
            teamACoach = [NSString stringWithFormat:@"%@...",[teamACoach substringToIndex:22]];
        }
        strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_TEAMACOACH
                                                     withString:teamACoach];
    } else {
        strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_TEAMACOACH
                                                     withString:[NSString stringWithFormat:INPUT_TEXT,HTML_ID_TEAMACOACH]];
    }
    NSString *teamBCoach  = (NSString*)[_dictionary objectForKey:kKey_Match_TeamBCoach];
    if (teamBCoach) {
        if (teamBCoach.length > 25) {
            teamBCoach = [NSString stringWithFormat:@"%@...",[teamBCoach substringToIndex:22]];
        }
        strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_TEAMBCOACH
                                                     withString:teamBCoach];
    } else {
        strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_TEAMBCOACH
                                                     withString:[NSString stringWithFormat:INPUT_TEXT,HTML_ID_TEAMBCOACH]];
    }
    
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_TECHFOULA withString:[NSString stringWithFormat:@"%d",techFoulA]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_SCORECARD_TAG_TECHFOULB withString:[NSString stringWithFormat:@"%d",techFoulB]];
    strHTML = [strHTML stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:META_VIEWPORT];
    [webView loadHTMLString:strHTML
                    baseURL:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)btnDoneTapped:(id)sender{


    if (_defaultName) {
        NSString *referees = [CommonUtils getElementValueFromWebView:webView
                                                                byId:HTML_ID_REFEREES];
        NSString *matchName = [CommonUtils getElementValueFromWebView:webView
                                                                 byId:HTML_ID_MATCHNAME];
        NSString *timeKeeper = [CommonUtils getElementValueFromWebView:webView
                                                                  byId:HTML_ID_TIMEKEEPER];
        NSString *scoreKeeper = [CommonUtils getElementValueFromWebView:webView
                                                                   byId:HTML_ID_SCOREKEEPER];
        NSString *teamACoach = [CommonUtils getElementValueFromWebView:webView
                                                                  byId:HTML_ID_TEAMACOACH];
        NSString *teamBCoach = [CommonUtils getElementValueFromWebView:webView
                                                                  byId:HTML_ID_TEAMBCOACH];
        NSLog(@"Did get elements value from webView");
        NSLog(@"Referees: %@",referees);
        NSLog(@"Time Keeper: %@",timeKeeper);
        NSLog(@"Score Keeper: %@",scoreKeeper);
        NSLog(@"Match Name: %@",matchName);
        
        [_dictionary setValue:referees
                       forKey:kKey_Match_Referees];
        [_dictionary setValue:timeKeeper
                       forKey:kKey_Match_TIMEKEEPER];
        [_dictionary setValue:scoreKeeper
                       forKey:kKey_Match_SCOREKEEPER];
        [_dictionary setValue:matchName
                       forKey:kKey_Match_MatchName];
        [_dictionary setValue:teamACoach
                       forKey:kKey_Match_TeamACoach];
        [_dictionary setValue:teamBCoach
                       forKey:kKey_Match_TeamBCoach];
        NSString *fileName;
        if (matchName && matchName.length > 0) {
            fileName = matchName;
        }else {
            fileName = _defaultName;
        }
        [_dictionary setObject:fileName forKey:kKey_Match_MatchName];
        [_dictionary setObject:[NSNumber numberWithBool:YES]
                        forKey:kKey_Match_isSaved];

        [DataManager addMatchWithDictionary:_dictionary
                                  matchName:fileName];
        [DataManager userDefaultRemoveObjectForKey:kKey_QuickSave];
    }

    BBMatchesListTableViewController *matchList = [[BBMatchesListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    BBStatisticOptionViewController *statOption = [[BBStatisticOptionViewController alloc] initWithDictionary:_dictionary];
    BBScoreCardViewController *scoreCard = [[BBScoreCardViewController alloc] initWithMatchDictionary:_dictionary defaultName:nil];
    UINavigationController *navController = [[UINavigationController alloc] init];
    [navController setViewControllers:[NSArray arrayWithObjects:matchList,statOption,scoreCard, nil]];
    [matchList release];
    [statOption release];
    [scoreCard release];
    [navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [navController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self presentModalViewController:navController
                            animated:YES];
    [navController release];
//    [self dismissModalViewControllerAnimated:YES];
//    [ROOT_VIEW_CONTROLLER dismissModalViewControllerAnimated:YES];
}

#pragma mark - IBAction
- (IBAction)btnPrintTapped:(id)sender{
//    [CommonUtils printViewContent:webView delegate:self];
    if (sender) {
        [CommonUtils printViewContent:webView
                             fromRect:[(UIButton*)sender frame]
                               inView:self.view
                             delegate:self];
    } else {
        [CommonUtils printViewcontent:webView
                    fromBarButtonItem:self.navigationController.navigationBar.topItem.rightBarButtonItem
                             delegate:self];
    }
}

- (IBAction)btnEmailTapped:(id)sender{
    NSString *matchName = [_dictionary objectForKey:kKey_Match_MatchName];
    [CommonUtils createEmailFromImageOfView:webView 
                                    subject:[NSString stringWithFormat:@"%@ %@",kEmailSubject_ScoreCard,matchName]
                                  matchName:matchName
                                   delegate:self];
}

- (IBAction)btnSaveTapped:(id)sender{
    NSString *matchName = [_dictionary objectForKey:kKey_Match_MatchName];
    NSString *fileName = [NSString stringWithFormat:@"ScoreCard_%@.pdf",matchName];
    fileName = [fileName stringByStandardizingPath];
    fileName = [fileName stringByReplacingOccurrencesOfString:@" "
                                                   withString:@""];
    [CommonUtils createPDFfromUIView:webView
         saveToDocumentsWithFileName:fileName];
    
    NSString *filePath = [CommonUtils documentPathForFile:fileName];

    if (sender) {
        [CommonUtils displayOptionMenuWithFilePath:filePath
                                          fromRect:[(UIButton*)sender frame]
                                            inView:self.view
                                          delegate:self];
    }else {
        [CommonUtils displayOptionMenuFromBarButton:self.navigationController.navigationBar.topItem.rightBarButtonItem
                                           filePath:filePath
                                           delegate:self];

    }

}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Private Methods
- (void) barButtonDidTap:(id)sender{
    
    if (as) {
        [as dismissWithClickedButtonIndex:-1
                                 animated:NO];
        F_RELEASE(as);
    }
    if ([(NSNumber*)[_dictionary objectForKey:kKey_Match_isSaved] boolValue]) {
        as = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Print",@"Email",@"Open", nil];
    }else {
        as = [[UIActionSheet alloc] initWithTitle:nil
                                         delegate:self
                                cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                                otherButtonTitles:@"Print",@"Email",@"Open",@"Done", nil];
    }
    
    [as dismissWithClickedButtonIndex:-1
                             animated:NO];
    [as showFromBarButtonItem:self.navigationController.navigationBar.topItem.rightBarButtonItem
                     animated:YES];
//    F_RELEASE(as);
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self btnPrintTapped:nil];
            break;
        case 1:
            [self btnEmailTapped:nil];
            break;
        case 2:
            [self btnSaveTapped:nil];
            break;
        case 3:
            [self btnDoneTapped:nil];
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    F_RELEASE(as);
}
#pragma mar - documentinteraction
- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application{
    NSString *filePath = [[[[controller URL] filePathURL] absoluteString] lastPathComponent];

    filePath = [CommonUtils documentPathForFile:filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                   error:nil];
    }
    NSLog(@"URL: %@",filePath);
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{

}
@end
