//
//  BBPlayerReportCardViewController.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBPlayerReportCardViewController.h"
#import "BBShotKey.h"
@interface BBPlayerReportCardViewController ()

@end

@implementation BBPlayerReportCardViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithPlayerIndex:(NSInteger)playerIndex teamIndex:(NSInteger)teamIndex matchDictionary:(NSDictionary*)dictionary{
    self = [super init];
    if (self) {
        arrLocationOfFieldShot = [[NSMutableArray alloc] init];
        _playerIndex = playerIndex;
        _teamIndex = teamIndex;
        dictMatch = [[NSDictionary alloc] initWithDictionary:dictionary];
    }
    return self;
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
    [self setTitle:LOCALIZE(TITLE_PLAYERREPORTCARD)];
    
    ////Set barbutton


    /////////////////////
    CGFloat timeOnCourt = 0;
    if (_playerIndex == 0) {
        timeOnCourt = [[dictMatch objectForKey:kKey_Match_TotalTimeOn] floatValue];
    } else{
        NSString *teamKey = (_teamIndex == 0)?kKey_Player_TeamA:kKey_Player_TeamB;
        NSArray *arrPlayers = (NSArray*)[dictMatch objectForKey:teamKey];
        NSDictionary *dictPlayer = [arrPlayers objectAtIndex:_playerIndex - 1];
        timeOnCourt = [[dictPlayer objectForKey:kKey_Player_TimeOn]  floatValue];
    }
    NSString *strHTML = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kFileNamePlayerReportTemplate ofType:nil]
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];

    NSArray *arrActions = (NSArray*)[dictMatch objectForKey:kKey_Actions];
    NSInteger fouls = 0, foulShots = 0, foulShotsTotal = 0, fieldShots2 = 0, fieldShots2Total = 0, fieldShots3 = 0, fieldShots3Total = 0, turnOvers = 0, steals = 0, rebounds = 0, assists = 0, totalPoints = 0;
    
    NSString *playerName, *teamName, *matchName;
    
    matchName = (NSString*)[dictMatch objectForKey:kKey_Match_MatchName];
    NSString *teamKey = (_teamIndex == 0)?kKey_Player_TeamA:kKey_Player_TeamB;
    NSArray *arrPlayers = (NSArray*)[dictMatch objectForKey:teamKey];
    if (_playerIndex == 0) {
        playerName = @"All";
    } else {
        NSDictionary *player = [arrPlayers objectAtIndex:_playerIndex-1];
        playerName = [NSString stringWithFormat:@"%d %@",[[player objectForKey:kKey_PlayerNumber] intValue],(NSString*)[player objectForKey:kKey_PlayerName]];
    }
    
    if (!playerName || playerName.length == 0) {
        playerName = [NSString stringWithFormat:@"Player %d",_playerIndex];
    }
    NSArray *arrTeams = (NSArray*)[dictMatch objectForKey:kKey_TeamName];
    teamName = (NSString*)[arrTeams objectAtIndex:_teamIndex];
    for (NSDictionary *action in arrActions) {
        NSInteger playerIndex = [(NSNumber*)[action objectForKey:kKey_Action_PlayerIndex] intValue]+1;
        NSInteger teamIndex = [(NSNumber*)[action objectForKey:kKey_Action_TeamIndex] intValue];
        ACTION_TYPE actionType = [(NSNumber*)[action objectForKey:kKey_Action_ActionType] intValue];
        if (_playerIndex == 0) {
            /////TODO: Report card for all
            if (teamIndex == _teamIndex) {
                if (actionType == ACTION_TYPE_ONEMADE || actionType == ACTION_TYPE_ONEMISS) {
                    foulShotsTotal ++;
                    if (actionType == ACTION_TYPE_ONEMADE) {
                        foulShots ++;
                        totalPoints ++;
                    }
                } else if(actionType == ACTION_TYPE_TWOMADE || actionType == ACTION_TYPE_TWOMISS){
                    fieldShots2Total ++;
                    if (actionType == ACTION_TYPE_TWOMADE) {
                        fieldShots2 ++;
                        totalPoints += 2;
                    }
                } else if (actionType == ACTION_TYPE_THREEMADE || actionType == ACTION_TYPE_THREEMISS){
                    fieldShots3Total ++;
                    if (actionType == ACTION_TYPE_THREEMADE) {
                        fieldShots3 ++;
                        totalPoints += 3;
                    }
                } else if (actionType == ACTION_TYPE_FOUL || actionType == ACTION_TYPE_FOUL1 || actionType == ACTION_TYPE_FOUL2 || actionType == ACTION_TYPE_FOUL3 || actionType == ACTION_TYPE_TECHFOUL){
                    fouls ++;
                } else if (actionType == ACTION_TYPE_REBOUND){
                    rebounds ++;
                } else if (actionType == ACTION_TYPE_STEAL){
                    steals ++;
                } else if (actionType == ACTION_TYPE_TURNOVER){
                    turnOvers ++;
                } else if (actionType == ACTION_TYPE_ASSIST){
                    assists ++;
                } 
            }
        } else {
            if (playerIndex == _playerIndex && teamIndex == _teamIndex) {
                if (actionType == ACTION_TYPE_ONEMADE || actionType == ACTION_TYPE_ONEMISS) {
                    foulShotsTotal ++;
                    if (actionType == ACTION_TYPE_ONEMADE) {
                        foulShots ++;
                        totalPoints ++;
                    }
                } else if(actionType == ACTION_TYPE_TWOMADE || actionType == ACTION_TYPE_TWOMISS){
                    fieldShots2Total ++;
                    if (actionType == ACTION_TYPE_TWOMADE) {
                        fieldShots2 ++;
                        totalPoints += 2;
                    }
                } else if (actionType == ACTION_TYPE_THREEMADE || actionType == ACTION_TYPE_THREEMISS){
                    fieldShots3Total ++;
                    if (actionType == ACTION_TYPE_THREEMADE) {
                        fieldShots3 ++;
                        totalPoints += 3;
                    }
                } else if (actionType == ACTION_TYPE_FOUL || actionType == ACTION_TYPE_FOUL1 || actionType == ACTION_TYPE_FOUL2 || actionType == ACTION_TYPE_FOUL3 || actionType == ACTION_TYPE_TECHFOUL){
                    fouls ++;
                } else if (actionType == ACTION_TYPE_REBOUND){
                    rebounds ++;
                } else if (actionType == ACTION_TYPE_STEAL){
                    steals ++;
                } else if (actionType == ACTION_TYPE_TURNOVER){
                    turnOvers ++;
                } else if (actionType == ACTION_TYPE_ASSIST){
                    assists ++;
                }
                
            }
        }
    }

        

            
//    [self setTitle:[NSString stringWithFormat:@"%@ : %@",teamName, playerName]];
    
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_MATCHNAME
                                                 withString:matchName];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_PLAYERNAME
                                                 withString:playerName];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_TEAMNAME
                                                 withString:teamName];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_FOULS
                                                 withString:[NSString stringWithFormat:@"%d",fouls]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_FOULSHOTS
                                                 withString:[NSString stringWithFormat:@"%d",foulShots]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_FOULSHOTSTOTAL
                                                 withString:[NSString stringWithFormat:@"%d",foulShotsTotal]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_FOULSHOTSPERCENT
                                                 withString:[NSString stringWithFormat:@"%d",[CommonUtils percentFrom:foulShots to:foulShotsTotal]]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_FIELDSHOTS2
                                                 withString:[NSString stringWithFormat:@"%d",fieldShots2]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_FIELDSHOTS2TOTAL
                                                 withString:[NSString stringWithFormat:@"%d",fieldShots2Total]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_FIELDSHOTS2PERCENT
                                                 withString:[NSString stringWithFormat:@"%d",[CommonUtils percentFrom:fieldShots2 to:fieldShots2Total]]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_FIELDSHOTS3
                                                 withString:[NSString stringWithFormat:@"%d",fieldShots3]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_FIELDSHOTS3TOTAL  
                                                 withString:[NSString stringWithFormat:@"%d",fieldShots3Total]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_FIELDSHOTS3PERCENT
                                                 withString:[NSString stringWithFormat:@"%d",[CommonUtils percentFrom:fieldShots3 to:fieldShots3Total]]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_TOTALPOINTS
                                                 withString:[NSString stringWithFormat:@"%d",totalPoints]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_TURNOVERS
                                                 withString:[NSString stringWithFormat:@"%d",turnOvers]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_STEALS
                                                 withString:[NSString stringWithFormat:@"%d",steals]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_ASSISTS
                                                 withString:[NSString stringWithFormat:@"%d",assists]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_REBOUNDS
                                                 withString:[NSString stringWithFormat:@"%d",rebounds]];
    
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_TIMEONCOURT
                                                 withString:[CommonUtils dateTimeStringWithDate:[NSDate dateWithTimeIntervalSince1970:timeOnCourt] formatString:@"mm:ss"]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_PLAYERREPORT_FIELDSHOTTOTAL
                                                 withString:[NSString stringWithFormat:@"%d",fieldShots2+fieldShots3]];
    for (NSDictionary *action in arrActions) {
        if ([(NSNumber*)[action objectForKey:kKey_Action_ActionType] intValue] == ACTION_TYPE_TWOMADE || [(NSNumber*)[action objectForKey:kKey_Action_ActionType] intValue] == ACTION_TYPE_THREEMADE || [(NSNumber*)[action objectForKey:kKey_Action_ActionType] intValue] == ACTION_TYPE_TWOMISS || [(NSNumber*)[action objectForKey:kKey_Action_ActionType] intValue] == ACTION_TYPE_THREEMISS) {
            if (_playerIndex == 0) {
                NSInteger teamIndex = [(NSNumber*)[action objectForKey:kKey_Action_TeamIndex] intValue];
                if (teamIndex == _teamIndex) {
                    CGFloat x,y;
                    NSDictionary *location = (NSDictionary*)[action objectForKey:kKey_Action_ActionLocation];
                    x = [(NSNumber*)[location objectForKey:kKey_Action_Location_X] floatValue];
                    y = [(NSNumber*)[location objectForKey:kKey_Action_Location_Y] floatValue];
                    if (x > 0 || y > 0) {
                        x = x*imageView.frame.size.width;
                        y = y*imageView.frame.size.height;
                        BBShotKey *shotKey = [[BBShotKey alloc] initWithFrame:CGRectMake(x, y, SHOTPIN_LARGE_SIZE, SHOTPIN_LARGE_SIZE)];
                        [imageView addSubview:shotKey];
                        if ([(NSNumber*)[action objectForKey:kKey_Action_ActionType] intValue] == ACTION_TYPE_TWOMADE || [(NSNumber*)[action objectForKey:kKey_Action_ActionType] intValue] == ACTION_TYPE_THREEMADE) {
                            [shotKey setIsShotMade:YES];
                        }
                        
                        NSString *teamKey;
                        if (teamIndex == 0) {
                            teamKey = kKey_Player_TeamA;
                        }else {
                            teamKey = kKey_Player_TeamB;
                        }
                        
                        NSArray *arrPlayer = (NSArray*)[dictMatch objectForKey:teamKey];
                        NSInteger playerIndex = [(NSNumber*)[action objectForKey:kKey_Action_PlayerIndex] intValue];
                        NSString *playerNumber = (NSString*)[(NSDictionary*)[arrPlayer objectAtIndex:playerIndex-1] objectForKey:kKey_PlayerNumber];
                        [shotKey setPlayerNumber:playerNumber];
                        [shotKey release];
                    }
                }
            } else {
                if ([(NSNumber*)[action objectForKey:kKey_Action_PlayerIndex] intValue] == _playerIndex && [(NSNumber*)[action objectForKey:kKey_Action_TeamIndex] intValue] == _teamIndex) {
                    CGFloat x,y;
                    NSDictionary *location = (NSDictionary*)[action objectForKey:kKey_Action_ActionLocation];
                    x = [(NSNumber*)[location objectForKey:kKey_Action_Location_X] floatValue];
                    y = [(NSNumber*)[location objectForKey:kKey_Action_Location_Y] floatValue];
                    if (x > 0 || y > 0) {
                        x = x*imageView.frame.size.width;
                        y = y*imageView.frame.size.height;
                        BBShotKey *shotKey = [[BBShotKey alloc] initWithFrame:CGRectMake(x, y, SHOTPIN_LARGE_SIZE, SHOTPIN_LARGE_SIZE)];
                        [imageView addSubview:shotKey];
                        if ([(NSNumber*)[action objectForKey:kKey_Action_ActionType] intValue] == ACTION_TYPE_TWOMADE || [(NSNumber*)[action objectForKey:kKey_Action_ActionType] intValue] == ACTION_TYPE_THREEMADE) {
                            [shotKey setIsShotMade:YES];
                        }
                        
                        NSInteger teamIndex = [(NSNumber*)[action objectForKey:kKey_Action_TeamIndex] intValue];
                        NSString *teamKey;
                        if (teamIndex == 0) {
                            teamKey = kKey_Player_TeamA;
                        }else {
                            teamKey = kKey_Player_TeamB;
                        }
                        
                        NSArray *arrPlayer = (NSArray*)[dictMatch objectForKey:teamKey];
                        NSInteger playerIndex = [(NSNumber*)[action objectForKey:kKey_Action_PlayerIndex] intValue];
                        NSString *playerNumber = (NSString*)[(NSDictionary*)[arrPlayer objectAtIndex:playerIndex-1] objectForKey:kKey_PlayerNumber];
                        [shotKey setPlayerNumber:playerNumber];
                        [shotKey release];

                    }                    
                }
            }
        }
        
    }
    [webView loadHTMLString:strHTML
                    baseURL:nil];
//    [self setWantsFullScreenLayout:YES];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ((interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
        return YES;
    }
    return NO;
}

- (IBAction)btnPrintTapped:(id)sender{
    [CommonUtils printViewContent:imageView delegate:self];
}

- (IBAction)btnEmailTapped:(id)sender{
    NSString *matchName = [dictMatch objectForKey:kKey_Match_MatchName];
    NSString *teamName = [[dictMatch objectForKey:kKey_TeamName] objectAtIndex:_teamIndex];
    NSString *playerName = nil;
    if (_teamIndex == 0) {
        playerName = [[[dictMatch objectForKey:kKey_Player_TeamA] objectAtIndex:_playerIndex-1] objectForKey:kKey_PlayerName];
    } else {
        playerName = [[[dictMatch objectForKey:kKey_Player_TeamB] objectAtIndex:_playerIndex-1] objectForKey:kKey_PlayerName];
    }
    
    [CommonUtils createEmailFromImageOfView:self.view
                                    subject:[NSString stringWithFormat:kEmailSubject_PlayerCard,playerName,teamName,matchName]
                                  matchName:matchName
                                   delegate:self];
//    [CommonUtils createEmailFromImageOfView:imageView 
//                                    matchName:matchName
//                                   delegate:self];
    
}


- (IBAction)btnSaveTapped:(id)sender{
    NSArray *teams = (NSArray*)[dictMatch objectForKey:kKey_TeamName];
    NSString *teamName = (NSString*)[teams objectAtIndex:_teamIndex];
    NSString *matchName = (NSString*)[dictMatch objectForKey:kKey_Match_MatchName];
    NSArray *players = (NSArray*)[dictMatch objectForKey:kKey_PlayerList];
    NSString *playerName = (NSString*)[(NSDictionary*)[players objectAtIndex:_playerIndex] objectForKey:kKey_PlayerName];
    NSString *fileName = [NSString stringWithFormat:@"PlayerReportCard_%@_%@_%@.pdf",matchName,teamName,playerName];
    fileName = [fileName stringByReplacingOccurrencesOfString:@" "
                                                   withString:@""];
    [CommonUtils createPDFfromUIView:imageView
         saveToDocumentsWithFileName:fileName];
    NSString *filePath = [CommonUtils documentPathForFile:fileName];
    [CommonUtils displayOptionMenuWithFilePath:filePath
                                      fromRect:[(UIButton*)sender frame]
                                        inView:self.view
                                      delegate:self];
}

- (IBAction)btnDoneTapped:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIDocumentInteractionControllerDelegate

#pragma mark - Private Methods
- (void) barButtonDidTap:(id)sender{
    if (as) {
        [as dismissWithClickedButtonIndex:-1
                                 animated:NO];
        F_RELEASE(as);
    }
    as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"Print",@"Email",@"Open", nil];
    
    [as showFromBarButtonItem:self.navigationController.navigationBar.topItem.rightBarButtonItem
                     animated:YES];
//    F_RELEASE(as);
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *matchName = [dictMatch objectForKey:kKey_Match_MatchName];
    switch (buttonIndex) {
        case 0:
            [CommonUtils printViewcontent:self.view
                        fromBarButtonItem:self.navigationController.navigationBar.topItem.rightBarButtonItem
                                 delegate:self];
            break;
        case 1:
        {
            NSString *teamName = [[dictMatch objectForKey:kKey_TeamName] objectAtIndex:_teamIndex];
            NSString *playerName = nil;
            if (_teamIndex == 0) {
                playerName = [[[dictMatch objectForKey:kKey_Player_TeamA] objectAtIndex:_playerIndex-1] objectForKey:kKey_PlayerName];
            } else {
                playerName = [[[dictMatch objectForKey:kKey_Player_TeamB] objectAtIndex:_playerIndex-1] objectForKey:kKey_PlayerName];
            }
            
            if (!playerName || playerName.length == 0) {
                if (_teamIndex == 0) {
                    playerName = [[[dictMatch objectForKey:kKey_Player_TeamA] objectAtIndex:_playerIndex-1] objectForKey:kKey_PlayerNumber];
                } else {
                    playerName = [[[dictMatch objectForKey:kKey_Player_TeamB] objectAtIndex:_playerIndex-1] objectForKey:kKey_PlayerNumber];
                }

            }
            [CommonUtils createEmailFromImageOfView:self.view
                                            subject:[NSString stringWithFormat:kEmailSubject_PlayerCard,playerName,teamName,matchName]
                                          matchName:matchName
                                           delegate:self];
            break;
        }
        case 2:
        {
            NSString *matchName = [dictMatch objectForKey:kKey_Match_MatchName];
            NSString *teamKey = (_teamIndex == 0)?kKey_Player_TeamA:kKey_Player_TeamB;
            NSArray *arrPlayers = (NSArray*)[dictMatch objectForKey:teamKey];
            NSString *playerName, *teamName;
            if (_playerIndex == 0) {
                playerName = @"All";
            } else {
                NSDictionary *player = [arrPlayers objectAtIndex:_playerIndex-1];
                playerName = [NSString stringWithString:(NSString*)[player objectForKey:kKey_PlayerName]];
            }
            
            if (!playerName || playerName.length == 0) {
                playerName = [NSString stringWithFormat:@"Player %d",_playerIndex];
            }
            NSArray *arrTeams = (NSArray*)[dictMatch objectForKey:kKey_TeamName];
            teamName = (NSString*)[arrTeams objectAtIndex:_teamIndex];
            
            NSString *fileName = [NSString stringWithFormat:@"PlayerReportCard_%@_%@_%@.pdf",matchName,teamName,playerName];
            fileName = [fileName stringByStandardizingPath];
            fileName = [fileName stringByReplacingOccurrencesOfString:@" "
                                                           withString:@""];
            [CommonUtils createPDFfromUIView:self.view
                 saveToDocumentsWithFileName:fileName];
            NSString *filePath = [CommonUtils documentPathForFile:fileName];
            [CommonUtils displayOptionMenuFromBarButton:self.navigationController.navigationBar.topItem.rightBarButtonItem
                                               filePath:filePath
                                               delegate:self];
            break;
        }
            
        
                    
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    F_RELEASE(as);
}

#pragma mark - documentinteraction
- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application{
    NSString *filePath = [[[[controller URL] filePathURL] absoluteString] lastPathComponent];
    filePath = [CommonUtils documentPathForFile:filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                   error:nil];
    }
    NSLog(@"URL: %@",filePath);
}

@end
