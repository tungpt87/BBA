//
//  BBReportCardViewController.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBReportCardViewController.h"
#import "BBPlayerReportCardViewController.h"
@interface BBReportCardViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation BBReportCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    if (self) {
        _dictionary = [[NSDictionary alloc] initWithDictionary:dictionary];
        UIBarButtonItem *barButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                    target:self
                                                                                    action:@selector(barButtonDidTap:)] autorelease];
        self.navigationItem.rightBarButtonItem = barButton;
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadStatisticsWithTeamIndex:0];
    [self loadStatisticsWithTeamIndex:1];
    CGRect frame = webViewA.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    currentWebView = webViewA;
    webViewA.frame = frame;
    frame = webViewB.frame;
    frame.origin.x = frame.size.width;
    frame.origin.y = 0;
    webViewB.frame = frame;
    [_scrollView addSubview:webViewA];
    [_scrollView addSubview:webViewB];
    [_scrollView setContentSize:CGSizeMake(frame.size.width*2, frame.size.height)];
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    NSArray *arrTeams = (NSArray*)[_dictionary objectForKey:kKey_TeamName];
    [self setTitle:[NSString stringWithFormat:LOCALIZE(TITLE_REPORTCARD),(NSString*)[arrTeams objectAtIndex:_scrollView.contentOffset.x / _scrollView.frame.size.width]]];
    
    

}


- (void) loadStatisticsWithTeamIndex:(NSInteger)teamIndex{
    _teamIndex = teamIndex;
    int score1[kNumberOfPlayer], shot1[kNumberOfPlayer],score2[kNumberOfPlayer],shot2[kNumberOfPlayer],score3[kNumberOfPlayer],shot3[kNumberOfPlayer],foul[kNumberOfPlayer],turnOver[kNumberOfPlayer],steal[kNumberOfPlayer],assist[kNumberOfPlayer],rebound[kNumberOfPlayer], fieldScore[kNumberOfPlayer], fieldShot[kNumberOfPlayer], timeOn[kNumberOfPlayer], position[kNumberOfPlayer];
    BOOL isClockDisabled = [[_dictionary objectForKey:kKey_Match_IsClockDisabled] boolValue];
    NSInteger unknownScore1 = 0, unknownShot1 = 0, unknownScore2 = 0, unknownShot2 = 0, unknownScore3 = 0, unknownShot3 = 0;
    for (int i = 0; i < kNumberOfPlayer; ++i) {
        position[i] = 0;
        score1[i] = 0;
        shot1[i] = 0;
        score2[i] = 0;
        shot2[i] = 0;
        score3[i] = 0;
        shot3[i] = 0;
        foul[i] = 0;
        turnOver[i] = 0;
        steal[i] = 0;
        assist[i] = 0;
        rebound[i] = 0;
        fieldScore[i] = 0;
        fieldShot[i] = 0;
        timeOn[i] = 0;
    }
    
    NSInteger allFoul=0, allTurnOver=0, allSteal=0, allAssist=0, allRebound=0, allTimeOn=0, allFieldScore=0, allFieldShot=0, allTotalScores = 0, allTotalShots = 0;
//////////////////////////////////////////
    allTimeOn = [[_dictionary objectForKey:kKey_Match_TotalTimeOn] floatValue];
    NSString *strHTML = [NSString stringWithContentsOfFile:[CommonUtils bundlePathWithFile:kFileNameReportCardTemplate]
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    NSString *key;
    if (teamIndex == 0) {
        key = kKey_Player_TeamA;
    } else {
        key = kKey_Player_TeamB;
    }
    NSArray *teams = (NSArray*)[_dictionary objectForKey:kKey_TeamName];
    if (teams) {
        NSString *teamName = (NSString*)[teams objectAtIndex:teamIndex];
        if (teamName) {
            strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_REPORTCARD_TAG_TEAMNAME
                                                         withString:teamName];
        }

    }
    NSArray *arrPlayers = [_dictionary objectForKey:key];
    if (arrPlayers) {
        for (int i = 0; i < kNumberOfPlayer; ++i) {
            if (i < arrPlayers.count) {
                NSDictionary *player = (NSDictionary*)[arrPlayers objectAtIndex:i];
                position[[[player objectForKey:kKey_Player_Index] intValue]-1] = i;
                NSString *playerNoTag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERNO,i+1];
                if (player) {
                    strHTML = [strHTML stringByReplacingOccurrencesOfString:playerNoTag
                                                                 withString:(NSString*)[player objectForKey:kKey_PlayerNumber]];
                    NSInteger timeOn = (NSInteger)round([(NSNumber*)[player objectForKey:kKey_Player_TimeOn] floatValue]);

                    NSString *strTimeOn = nil;
                    if (isClockDisabled) {
                        strTimeOn = kDisableTimeTitle;
                    } else {
                        strTimeOn = [NSString stringWithFormat:@"%.2d:%.2d",timeOn/60,timeOn%60];

                    }
                    strHTML = [strHTML stringByReplacingOccurrencesOfString:[NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERTIMEON,i+1]
                                                                 withString:strTimeOn];
                }
            } else {
                NSString *playerNoTag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERNO,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:playerNoTag
                                                             withString:@""];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:[NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERTIMEON,i+1]
                                                             withString:@""];
            }
        }

    }
    
    
    NSArray *arrActions = [_dictionary objectForKey:kKey_Actions];
    if (arrActions) {
        int points[kNumberOfPlayer];
        for (int i = 0; i < kNumberOfPlayer; i++) {
            points[i] = 0;
        }
        for (int i = 0; i < arrActions.count; ++i) {
            NSDictionary *action = (NSDictionary*)[arrActions objectAtIndex:i];
            ACTION_TYPE actionType = [[action objectForKey:kKey_Action_ActionType] intValue];
            if (action && actionType != ACTION_TYPE_QRTSTART && actionType != ACTION_TYPE_QRTEND && actionType != ACTION_TYPE_PLAYERON && actionType != ACTION_TYPE_PLAYEROFF && actionType != ACTION_TYPE_UNKNOWN) {
                if ([[action objectForKey:kKey_Action_TeamIndex] intValue] == teamIndex) {
                    NSInteger playerIndex = [[action objectForKey:kKey_Action_PlayerIndex] intValue] - 1;
                    if (actionType == ACTION_TYPE_ONEMADE || actionType == ACTION_TYPE_ONEMISS) {
                        if (playerIndex > -1) {
                            shot1[position[playerIndex]] ++;
                            if (actionType == ACTION_TYPE_ONEMADE) {
                                score1[position[playerIndex]] ++;
                                points[playerIndex] ++;
                            }
                        } else {
                            unknownShot1 ++;
                            if (actionType == ACTION_TYPE_ONEMADE) {
                                unknownScore1 ++;
                            }
                        }
                    } else if (actionType == ACTION_TYPE_TWOMADE || actionType == ACTION_TYPE_TWOMISS) {
                        if (playerIndex > -1) {
                            fieldShot[position[playerIndex]] ++;
                            shot2[position[playerIndex]] ++;
                            if (actionType == ACTION_TYPE_TWOMADE) {
                                score2[position[playerIndex]] ++;
                                fieldScore[position[playerIndex]]++;
                                points[playerIndex] += 2;
                            }
                        } else {
                            unknownShot2 ++;
                            if (actionType == ACTION_TYPE_TWOMADE) {
                                unknownScore2 ++;
                            }
                        } 
                    } else if (actionType == ACTION_TYPE_THREEMADE || actionType == ACTION_TYPE_THREEMISS) {
                        if (playerIndex > -1) {
                            shot3[position[playerIndex]] ++;
                            fieldShot[position[playerIndex]] ++;
                            if (actionType == ACTION_TYPE_THREEMADE) {
                                score3[position[playerIndex]] ++;
                                fieldScore[position[playerIndex]] ++;
                                points[playerIndex] += 3;
                            }
                        } else {
                            unknownShot3 ++;
                            if (actionType == ACTION_TYPE_THREEMADE) {
                                unknownScore3 ++;
                            }
                        }
                    } else if (actionType == ACTION_TYPE_FOUL || actionType == ACTION_TYPE_TECHFOUL || actionType == ACTION_TYPE_FOUL1 || actionType == ACTION_TYPE_FOUL2 || actionType == ACTION_TYPE_FOUL3) {
                        if (playerIndex > -1) {
                            foul[position[playerIndex]] ++;
                        }
                        allFoul ++;
                    } else if (actionType == ACTION_TYPE_STEAL) {
                        if (playerIndex > -1) {
                            steal[position[playerIndex]] ++;
                        }
                    } else if (actionType == ACTION_TYPE_ASSIST) {
                        if (playerIndex > -1) {
                            assist[position[playerIndex]] ++;
                        }
                    } else if (actionType == ACTION_TYPE_REBOUND) {
                        if (playerIndex > -1) {
                            rebound[position[playerIndex]] ++;
                        }
                    } else if (actionType == ACTION_TYPE_TURNOVER) {
                        if (playerIndex > -1) {
                            turnOver[position[playerIndex]] ++;
                        }
                    } 
                    if (playerIndex > -1) {
                        fieldShot[position[playerIndex]] = shot2[position[playerIndex]] + shot3[position[playerIndex]];
                        fieldScore[position[playerIndex]] = score2[position[playerIndex]] + score3[position[playerIndex]];
                    }
                }
            }
        }
        for (int i = 0; i < kNumberOfPlayer ; ++i) {
            if (i < arrPlayers.count) {
                NSString *tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSCORE,i+1,1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",score1[i]]];
                
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSHOT,i+1,1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",shot1[i]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSCORE,i+1,2];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",score2[i]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSHOT,i+1,2];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",shot2[i]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSCORE,i+1,3];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",score3[i]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSHOT,i+1,3];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",shot3[i]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERFOUL,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",foul[i]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERTURNOVER,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",turnOver[i]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSTEAL,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",steal[i]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERASSIST,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",assist[i]]];
                
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERREBOUND,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",rebound[i]]];
                
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERTIMEON,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",timeOn[i]]];
                //        tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERTIMEON,i+1];
                //        strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                //                                                     withString:[NSString stringWithFormat:@"%d",timeOn[i]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERFIELDSHOTMADE,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",fieldScore[i]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERFIELDSHOT,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",fieldShot[i]]];
                
                
                
                ////Calculate and fill percent of scores on shots
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSHOTPERCENT,i+1,1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",[CommonUtils percentFrom:score1[i] to:shot1[i]]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSHOTPERCENT,i+1,2];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",[CommonUtils percentFrom:score2[i] to:shot2[i]]]];
                
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSHOTPERCENT,i+1,3];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",[CommonUtils percentFrom:score3[i] to:shot3[i]]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERFIELDSHOTPERCENT,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",[CommonUtils percentFrom:fieldScore[i] to:fieldShot[i]]]];
                
                NSInteger totalScore = score1[i]+score2[i] + score3[i];
                NSInteger totalShots = shot1[i] + shot2[i] + shot3[i];
                NSInteger totalPercent = 0;
                NSInteger allPoints = 0;
                for (int i = 0; i< kNumberOfPlayer; i++) {
                    allPoints += points[i];
                }
                if (totalShots != 0) {
                    totalPercent = (NSInteger)round(100*(CGFloat)totalScore/(CGFloat)totalShots);
                }
                
                tag = HTMLFORM_REPORTCARD_TAG_ALLPOINTS;
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",allPoints]];
                
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_TOTALSCORE,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",totalScore]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_POINTS,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",points[i]]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_TOTALSHOT,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",totalShots]];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_TOTALPERCENT,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:[NSString stringWithFormat:@"%d",totalPercent]];
                allTotalScores += totalScore;
                allTotalShots += totalShots;
                ///Canculate total of all field
                allAssist += assist[i];
                allFieldScore += score2[i] + score3[i];
                allFieldShot += shot2[i] + shot3[i];
                allRebound += rebound[i];
                allSteal += steal[i];
                allTurnOver +=turnOver[i];
            } else {
                NSString *tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSCORE,i+1,1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_POINTS,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSHOT,i+1,1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSCORE,i+1,2];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSHOT,i+1,2];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSCORE,i+1,3];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSHOT,i+1,3];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERFOUL,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERTURNOVER,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSTEAL,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERASSIST,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERREBOUND,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERTIMEON,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERFIELDSHOTMADE,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERFIELDSHOT,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                
                
                
                ////Calculate and fill percent of scores on shots
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSHOTPERCENT,i+1,1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSHOTPERCENT,i+1,2];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERSHOTPERCENT,i+1,3];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_PLAYERFIELDSHOTPERCENT,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                
                
                
                
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_TOTALSCORE,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_TOTALSHOT,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
                tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_TOTALPERCENT,i+1];
                strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                             withString:@""];
            }
            
            
            
        }

    }
        
    NSString *tag;
    NSInteger allTotalPercent = 0;
    allTotalShots += unknownShot1 + unknownShot2 + unknownShot3;
    allTotalScores += unknownScore1 + unknownScore2 + unknownScore3;
    if (allTotalShots != 0) {
        allTotalPercent = (NSInteger)round(100*(CGFloat)allTotalScores/(CGFloat)allTotalShots);
    }

    tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_TOTALSCORE,0];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                 withString:[NSString stringWithFormat:@"%d",allTotalScores]];
    tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_TOTALSHOT,0];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                 withString:[NSString stringWithFormat:@"%d",allTotalShots]];
    tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_TOTALPERCENT,0];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                 withString:[NSString stringWithFormat:@"%d",allTotalPercent]];
    
    for (int i=1; i <= 3; i++) {
        NSInteger allScore = 0;
        NSInteger allShot = 0;
        tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_ALLSCORE,i];
        
        int *score;
        NSInteger unknownShot, unknownScore;
        switch (i) {
            case 1:
                score = score1;
                unknownShot = unknownShot1;
                unknownScore = unknownScore1;
                break;
            case 2:
                score = score2;
                unknownShot = unknownShot2;
                unknownScore = unknownScore2;
                break;
            case 3:
                score = score3;
                unknownShot = unknownShot3;
                unknownScore = unknownScore3;
                break;
            default:
                break;
        }
        for (int i = 0; i<kNumberOfPlayer; i++) {
            allScore += score[i];
        }
        allScore += unknownScore;
        strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                     withString:[NSString stringWithFormat:@"%d",allScore]];
        
        tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_ALLSHOT,i];
        int *shot;
        switch (i) {
            case 1:
                shot = shot1;
                break;
            case 2:
                shot = shot2;
                break;
            case 3:
                shot = shot3;
                break;
            default:
                break;
        }
        for (int i = 0; i<kNumberOfPlayer; i++) {
            allShot += shot[i];
        }
        
        allShot += unknownShot;
        strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                     withString:[NSString stringWithFormat:@"%d",allShot]];
        
        tag = [NSString stringWithFormat:HTMLFORM_REPORTCARD_TAG_ALLSHOTPERCENT,i];
        NSInteger percent = [CommonUtils percentFrom:allScore to:allShot];

        
        strHTML = [strHTML stringByReplacingOccurrencesOfString:tag
                                                     withString:[NSString stringWithFormat:@"%d",percent]];
    }


    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_REPORTCARD_TAG_ALLFOUL
                                                 withString:[NSString stringWithFormat:@"%d",allFoul]];

    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_REPORTCARD_TAG_ALLTURNOVER
                                                 withString:[NSString stringWithFormat:@"%d",allTurnOver]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_REPORTCARD_TAG_ALLSTEAL
                                                 withString:[NSString stringWithFormat:@"%d",allSteal]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_REPORTCARD_TAG_ALLASSIST
                                                 withString:[NSString stringWithFormat:@"%d",allAssist]];
//    NSDate *dateTimeOn = [NSDate dateWithTimeIntervalSince1970:allTimeOn];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *strTimeOn = nil;
    if (isClockDisabled) {
        strTimeOn = kDisableTimeTitle;
    } else {
//        strTimeOn = [dateFormatter stringFromDate:dateTimeOn];
        strTimeOn = [NSString stringWithFormat:@"%.2d:%.2d",allTimeOn/60,allTimeOn%60];
    }
//    [dateFormatter release];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_REPORTCARD_TAG_ALLTIMEON
                                                 withString:strTimeOn];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_REPORTCARD_TAG_ALLREBOUND
                                                 withString:[NSString stringWithFormat:@"%d",allRebound]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_REPORTCARD_TAG_ALLFIELDSHOTMADE
                                                 withString:[NSString stringWithFormat:@"%d",allFieldScore]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_REPORTCARD_TAG_ALLFIELDSHOT
                                                 withString:[NSString stringWithFormat:@"%d",allFieldShot]];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:HTMLFORM_REPORTCARD_TAG_ALLFIELDSHOTPERCENT
                                                 withString:[NSString stringWithFormat:@"%d",[CommonUtils percentFrom:allFieldScore to:allFieldShot]]];


    strHTML = [strHTML stringByReplacingOccurrencesOfString:@"<p>/</p>" withString:@""];
    strHTML = [strHTML stringByReplacingOccurrencesOfString:@"<p>%</p>" withString:@""];

    //TODO: Add viewport
    strHTML = [strHTML stringByReplacingCharactersInRange:NSMakeRange(0, 0)
                                               withString:META_VIEWPORT];
    ///TODO: Start loading score card into webview
    if (teamIndex == 0) {
        [webViewA loadHTMLString:strHTML
                         baseURL:nil];
    }else {
        [webViewB loadHTMLString:strHTML
                         baseURL:nil];
    }

    // Do any additional setup after loading the view from its nib.

    //////Set title
//    NSArray *arrTeams = [_dictionary objectForKey:kKey_TeamName];
//    [self setTitle:[NSString stringWithFormat:TITLE_SCORECARD,(NSString*)[arrTeams objectAtIndex:teamIndex]]];

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
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSArray *arrTeams = (NSArray*)[_dictionary objectForKey:kKey_TeamName];
    NSInteger teamindex = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self setTitle:[NSString stringWithFormat:LOCALIZE(TITLE_REPORTCARD),(NSString*)[arrTeams objectAtIndex:teamindex]]];
    if (teamindex == 0) {
        currentWebView = webViewA;
    }else if (teamindex == 1){
        currentWebView = webViewB;
    }
    
    currentWebView = [scrollView.subviews objectAtIndex:teamindex];
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeOther) {
        NSLog(@"WebView navigation type other");
        NSLog(@"Link: %@",[[request URL] absoluteString]);
        NSString *link = [[request URL] absoluteString];
        if ([link isEqualToString:@"about:blank"]) {
            return YES;
        }else {
            NSInteger playerIndex = [[link lastPathComponent] intValue];
            NSInteger teamIndex = webView.tag;
            NSArray *arrPlayer = nil;
            if (teamIndex == 0) {
                arrPlayer = [_dictionary objectForKey:kKey_Player_TeamA];
            } else {
                arrPlayer = [_dictionary objectForKey:kKey_Player_TeamB];
            }
            
            if (playerIndex <= arrPlayer.count) {
                BBPlayerReportCardViewController *playerReport = [[BBPlayerReportCardViewController alloc] initWithPlayerIndex:playerIndex teamIndex:teamIndex matchDictionary:_dictionary];
                
                [self.navigationController pushViewController:playerReport
                                                     animated:YES];
                [playerReport release];
                
            }
            return NO;
        }

    }
    else{
        return YES;
    }
}
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
                                           otherButtonTitles:@"Print",@"Open",@"Email", nil];
    
    [as showFromBarButtonItem:self.navigationController.navigationBar.topItem.rightBarButtonItem
                     animated:YES];
    F_RELEASE(as);
    
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self btnPrintTapped:nil];
            break;
        case 1:
            [self btnSaveTapped:nil];
            break;
        case 2:
            [self btnEmailTapped:nil];
            break;
        case 3:
//            [self btnDoneTapped:nil];
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    F_RELEASE(as);
}
#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - IBAction
- (IBAction)btnPrintTapped:(id)sender{
    if (sender) {
        [CommonUtils printViewContent:currentWebView
                             fromRect:[(UIButton*)sender frame]
                               inView:self.view
                             delegate:self];
    }
    else {
        [CommonUtils printViewcontent:currentWebView
                    fromBarButtonItem:self.navigationController.navigationBar.topItem.rightBarButtonItem
                             delegate:self];

    }
}

- (IBAction)btnEmailTapped:(id)sender{

    NSString *matchName = [_dictionary objectForKey:kKey_Match_MatchName];
    NSString *teamName = nil;
    if (currentWebView == webViewA) {
        teamName = [[_dictionary objectForKey:kKey_TeamName] objectAtIndex:0];
    } else {
        teamName = [[_dictionary objectForKey:kKey_TeamName] objectAtIndex:1];
    }
    [CommonUtils createEmailFromImageOfView:currentWebView
                                    subject:[NSString stringWithFormat:kEmailSubject_ReportCard,teamName,matchName]
                                  matchName:matchName
                                   delegate:self];
}

- (IBAction)btnSaveTapped:(id)sender{
    NSArray *teams = (NSArray*)[_dictionary objectForKey:kKey_TeamName];
    NSString *teamName = (NSString*)[teams objectAtIndex:_teamIndex];
    NSString *matchName = (NSString*)[_dictionary objectForKey:kKey_Match_MatchName];
    NSString *fileName = [NSString stringWithFormat:@"ReportCard_%@_%@.pdf",matchName,teamName];
    fileName = [fileName stringByStandardizingPath];
    fileName = [fileName stringByReplacingOccurrencesOfString:@" "
                                                   withString:@""];
    [CommonUtils createPDFfromUIView:currentWebView
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


@end
