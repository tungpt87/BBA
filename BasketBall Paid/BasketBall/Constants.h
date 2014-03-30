//
//  Constants.h
//  
//
//  Created by Tung Pham on 29/05/2012
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//  Contains every constants those're used in the whole program
#define RELEASE
#ifdef RELEASE
//#define NSLog(...)      /*NSLog(...)*/
#endif


#define kLineWidth              30

#define kButtonToggleLineDraw_On        @"Turn off line draw"
#define kButtonToggleLineDraw_Off       @"Turn on line draw"
typedef enum {
    ACTION_BOX_TYPE_STATISTICS = 0,
    ACTION_BOX_TYPE_SCORING = 1,
    ACTION_BOX_TYPE_FREESHOT = 2,
}ACTION_BOX_TYPE;

typedef enum {
    TEXTFIELD_TYPE_TEAM = 0,
    TEXTFIELD_TYPE_PLAYER = 1,
}TEXTFIELD_TYPE;


typedef enum {
    ACTION_TYPE_UNKNOWN = -1,
    ACTION_TYPE_ONEMADE = 1,
    ACTION_TYPE_ONEMISS = 2,
    ACTION_TYPE_TWOMADE = 3,
    ACTION_TYPE_TWOMISS = 4,
    ACTION_TYPE_THREEMADE = 5,
    ACTION_TYPE_THREEMISS = 6,
    ACTION_TYPE_FOUL = 7,
    ACTION_TYPE_TECHFOUL = 8,
    ACTION_TYPE_ASSIST = 9,
    ACTION_TYPE_REBOUND = 10,
    ACTION_TYPE_STEAL = 11,
    ACTION_TYPE_TURNOVER = 12,
    ACTION_TYPE_FOUL1 = 13,
    ACTION_TYPE_FOUL2 = 14,
    ACTION_TYPE_TIMEOUT = 15,
    ACTION_TYPE_QRTSTART = 16,
    ACTION_TYPE_QRTEND = 17,
    ACTION_TYPE_FOUL3 = 18,
    ACTION_TYPE_PLAYERON = 19,
    ACTION_TYPE_PLAYEROFF = 20,
}ACTION_TYPE;


typedef enum {
    ALERTVIEW_TAG_RESETTEAMFOUL = 0,
    ALERTVIEW_TAG_RESETTEAMTIMEOUT,
    ALERTVIEW_TAG_DELETEINFOTEAM,
    ALERTVIEW_TAG_NOT_ENOUGH_PLAYER,
    ALERTVIEW_TAG_LESSTHAN5PLAYER,
    ALERTVIEW_TAG_QUIT,
    ALERTVIEW_TAG_PLAYER_REACH_LIMIT,
    ALERTVIEW_TAG_CLOCK_NOT_RUNNING,
    ALERTVIEW_TAG_TEAM_REACH_LIMIT,
    ALERTVIEW_TAG_CONFIRM_LOAD_PREVIOUSDATA,
    ALERTVIEW_TAG_SUBBING_FAILED,
    ALERTVIEW_TAG_DISABLE_CLOCK,
}ALERTVIEW_TAG;

#define kDisabledValue              -100

#define UIControlStateFlashing      100

#define kScrollableWebViewTag       100

#define ROOT_VIEW           [[[[UIApplication sharedApplication] delegate] window] rootViewController].view

#define ROOT_VIEW_CONTROLLER        [[[[UIApplication sharedApplication] delegate] window] rootViewController]

#define kNumberOfPlayer         12

#define kPlayerNameUnknown      @"UNKNOWN"

#define kHomePageUrl            @"www.assistapps.com.au"

#define kDisableTimeTitle       @"--:--"

/////////Number of free shots
#define kFoul1FreeShots         1
#define kFoul2FreeShots         2
#define kFoul3FreeShots         3
#define kTechFoulFreeShots      2

#define kFlashingDuration       0.5
#define kLongPressInterval      0.3
#define kRawData_FontSize       24
#define kTechFoulDangerLimit    2
#define kTimeOutDangerLimit     2

//////Raw data
#define RAWDATA_TECHFOUL @"FT"
#define RAWDATA_FOUL @"F"
#define RAWDATA_FOUL1 @"F1"
#define RAWDATA_FOUL2 @"F2"
#define RAWDATA_FOUL3 @"F3"
#define RAWDATA_THREEMADE @"3P"
#define RAWDATA_TWOMADE @"2P"
#define RAWDATA_ONEMADE @"1P"
#define RAWDATA_QUARTERSTART @"QRT Start"
#define RAWDATA_QUARTEREND @"QRT End"
#define RAWDATA_PLAYERON    @"ON"
#define RAWDATA_PLAYEROFF @"OFF"
#define RAWDATA_TIMEOUT     @"TO"
typedef enum {
    EDITING_TYPE_TEAMNAME = 0,
    EDITING_TYPE_PLAYERNAME = 1,
}EDITING_TYPE;

/////ActionSheet Title
#define kActionSheetTitle_DeleteTeamInfo        @"Previous entries displayed. Choose an option below. If you retain a list, you can add or delete from it later by tap and hold on a name."

#define kMessage_DisableClock                   @"Do you sure want to disable clock?"
/////BarButtonTitle
#define BARBUTTONTITLE_EDIT             @"Edit"
#define BARBUTTONTITLE_HOME             @"Home"

////ACtion Naem
#define ACTION_NAME_ASSIST                  @"Assist"
#define ACTION_NAME_ONEMADE                 @"One Made"
#define ACTION_NAME_ONEMISS                 @"One Miss"
#define ACTION_NAME_TWOMADE                 @"Two Made"
#define ACTION_NAME_TWOMISS                 @"Two Miss"
#define ACTION_NAME_THREEMADE               @"Three Made"
#define ACTION_NAME_THREEMISS               @"Three Miss"
#define ACTION_NAME_FOUL                    @"Foul"
#define ACTION_NAME_TECHFOUL                @"Tech Foul"
#define ACTION_NAME_REBOUND                 @"Rebound"
#define ACTION_NAME_STEAL                   @"Steal"
#define ACTION_NAME_TURNOVER                @"Turn Over"
#define ACTION_NAME_FOUL1                   @"Foul 1"
#define ACTION_NAME_FOUL2                   @"Foul 2"
#define ACTION_NAME_FOUL3                   @"Foul 3"
#define ACTION_NAME_TIMEOUT                 @"Time Out"


#define kMaxNumberOfPlayersInTeam           5


#define kEmailSubject_ScoreCard             @"Score Card for Match"
#define kEmailSubject_ReportCard            @"Report Card for Team: %@ Match: %@"
#define kEmailSubject_PlayerCard            @"Player Report Card for Player: %@ Team: %@ Match: %@"
#define kEmailSubject_RawMatchData          @"Raw Match Data for Match: %@"
/////////Messages
#define kMessageHasPlayerThatReachedLimit   @"Personal foul limit exceeded. Sub player off before starting clock. "
#define kMessageATeamReachLimit             @"A team has exceeded the foul limit. Tap Foul 2/+ on normal fouls from this team."
#define kMessageConfirmTurnOff              @"Are you sure you want to quit this match? Data collected in relation to this match will be lost."
#define kMessageConfirmDeleteTeamAInfo      @"Do you want to delete Team A info"
#define kMessageConfirmDeleteTeamBInfo      @"Do you want to delete Team B info"
#define kMessageConfirmResetTeamFouls       @"Do you want to reset Team Fouls"
#define kMessageConfirmResetTeamTimeOut     @"Do you want to reset Time Outs"
#define kMessageNotEnoughPlayer             @"You must have at least 2 players from Team A on the court at all times, tap on player's name to add them to the court"
#define kMessageMoreThan5PlayersInTeam      @"A team has more than 5 players on the court. Tap on a player's name to remove them."
#define kMessageLessThan5PlayersInTeam      @"One team has less than 5 players on the court"
#define kMessageNotTurnOnClockYet           @"START GAME CLOCK before next action can be entered."
#define kMessageConfirmLoadPreviousData     @"An incomplete match was stored, do you want to recover it?"
#define kMessageSubbingFailed               @"A team has more than 5 players on the court."
//AlertView title
#define kTitle_SubbingFailed                @"Subbing failed"

/////////ActionSheet tag

#define TAG_ACTIONSHEET_LESSTHAN5PLAYER     1
#define TAG_ACTIONSHEET_DELETEINFO          2

///////// Button Title
#define kButtonTitleDelete                  @"Delete"
#define kButtonTitleOk                      @"Ok"
#define kButtonTitleCancel                  @"Cancel"
#define kButtonTitleYes                     @"Yes"
#define kButtonTitleNo                      @"No"
#define kButtonTitleDeleteAll               @"Delete Both"
#define kButtonTitleDeleteA                 @"Delete Team A"
#define kButtonTitleDeleteB                 @"Delete Team B"
#define kButtonTitleKeepBoth                @"Keep Both"
#define kButtonTitleIWillFix                @"I will fix"
#define kButtonTitleIgnore                  @"Ignore"
#define kButtonTitleIgnoreB                 @"Ignore Team B"
#define kButtonTitleDonRemindAgain          @"Ignore, do not\n\nremind me again"
#define kButtonTitleDone                    @"Done"
#define kMenuItemTitleMade                  @"Made"
#define kMenuItemTitleMiss                  @"Miss"
#define kButtonTitleReturnToMatch           @"Return to Match"

//Cell title
#define kCellTitle_CreateANewName           @"ADD A NEW NAME"
typedef enum {
    NEWMATCH_BUTTON_TAG_LEFTDONE = 11,
    NEWMATCH_BUTTON_TAG_LEFTREDO = 12,
    NEWMATCH_BUTTON_TAG_LEFTEDIT = 13,
    NEWMATCH_BUTTON_TAG_PERIODEND = 14,
    NEWMATCH_BUTTON_TAG_RIGHTDONE = 21,
    NEWMATCH_BUTTON_TAG_RIGHTREDO = 22,
    NEWMATCH_BUTTON_TAG_RIGHTEDIT = 23,
    NEWMATCH_BUTTON_TAG_GAMEEND = 24,
}NEWMATCH_BUTTON_TAG;




///////////Frame

#define SCREEN_SIZE_WIDTH           [[UIScreen mainScreen] bounds].size.width
#define SCREEN_SIZE_HEIGHT          [[UIScreen mainScreen] bounds].size.height


//////////Notification name
#define kNotificationClockDidStart                      @"ClockDidStart"
#define kNotificationPlayerDidSelected                  @"PlayerDidSelected"
#define kNotificationClockViewDidChangeContMode         @"DidChangeContMode"
#define kNotificationPlayerSubbed                       @"PlayerSubbed"
#define kNotificationPlayerViewDidLongPressed           @"PlayerViewLongPress"
#define kNotificationShotPinDidChangeValue              @"ShotPinDidChangeValue"
#define kNotificationShouldCheckTeamFoul                @"ShouldCheckTeamFoul"
#define kNotificationTeamFoulReachedLimit               @"TeamFoulReachedLimit"
#define kNotificationWillEditAction                     @"WillEditAction"
#define kNotificationShotPinDidRemoveFromSuperView      @"ShotPinDidRemoveFromSuperView"
#define kNotificationDidChangeDangerLimit               @"DidChangeDangerLimit"
#define kNotificationDidChangeTeamDangerLimit           @"DidChangeTeamDangerLimit"
#define kNotificationPlayerDidTap                       @"PlayerDidTap"
#define kNotificationShowFullCourt                      @"ShowFullCourt"
#define DEFAULTNAME_TEAMA           @"TEAM A"
#define DEFAULTNAME_TEAMB           @"TEAM B"

#define LABELTITLE_FOUL             @"Foul"
#define LABELTITLE_TIMEOUT          @"Time Out"

#define BARTITLE_SETFOULDANGERLIMIT @"Foul Limitation"

#define SHOTPIN_SMALL_SIZE    30
#define SHOTPIN_LARGE_SIZE    40

#define TEAMPLAYERVIEW_TAG_A                0
#define TEAMPLAYERVIEW_TAG_B                1


#define kUserDefaultKey_Duration            @"UserDefaultDurationOfAMatch"
#define kUserDefaultKey_FoulDangerLimit     @"FoulDangerLimit"
#define kUserDefaultKey_TeamFoulDangerLimit     @"TeamFoulDangerLimit"

#define kUserDefauluKey_DontRemindLessThan5 @"DontRemindLessThan5"
/////////File name
#define kFileName_ListPlayers               @"playerlist.plist"
#define kFileName_ListTeams                 @"teamlist.plist"
#define kFileName_MatchsList                @"matchlist.plist"
#define kFileNamePrefix_Match               @"Action_"
#define kFileNameReportCardTemplate         @"ReportCard.html"
#define kFileNameScoreCardTemplate          @"ScoreCard.html"
#define kFileNamePlayerReportTemplate       @"PlayerReport.html"



//////Key
#define kKey_QuickSave                      @"QuickSave"
#define kKey_QuickSave_TeamA                @"TeamA"
#define kKey_QuickSave_TeamB                @"TeamB"
#define kKey_QuickSave_TeamNameA            @"TeamNameA"
#define kKey_QuickSave_TeamNameB            @"TeamNameB"
#define kKey_QuickSave_TimeOutA             @"TimeOutA"
#define kKey_QuickSave_TimeOutB             @"TimeOutB"
#define kKey_QuickSave_TeamFoulA            @"TeamFoulA"
#define kKey_QuickSave_TeamFoulB            @"TeamFoulB"
#define kKey_QuickSave_TeamScoreA           @"TeamScoreA"
#define kKey_QuickSave_TeamScoreB           @"TeamScoreB"
#define kKey_QuickSave_RemainingTime        @"RemainingTime"
#define kKey_QuickSave_Period               @"Period"
#define kKey_QuickSave_Duration             @"Duration"
#define kKey_QuickSave_ActionList           @"ActionList"
#define kKey_QuickSave_ShouldIgnoreTeamB    @"ShouldIgnoreTeamB"
#define kKey_QuickSave_DisableClock         @"DisableClock"

#define kKey_PlayerSubbing_Index            @"SubbingIndex"
#define kKey_PlayerSubbing_On               @"SubbingOn"
#define kKey_PlayerSubbing_TeamIndex        @"SubbingTeamIndex"
#define kKey_NewMatch_PlayerListA           @"PlayerListA"
#define kKey_NewMatch_PlayerListB           @"PlayerListB"
#define kKey_NewMatch_TeamNameA             @"TeamNameA"
#define kKey_NewMatch_TeamNameB             @"TeamNameB"
#define kKey_NewMatch_Date                  @"Date"
#define kKey_PlayerList                     @"playerlist"
#define kKey_TeamList                       @"teamlist"

#define kKey_PlayerName                     @"playername"
#define kKey_PlayerNumber                   @"playernumber"
#define kKey_Player_IsInTheCourt            @"isInTheCourt"
#define kKey_Player_IsHidden                @"isHidden"
#define kKey_Player_TimeOn                  @"TimeOn"
#define kKey_Player_NumberOfHalves          @"NumberOfHalves"
#define kKey_Player_Index                   @"Index"
#define kKey_Player_TeamIndex               @"TeamIndex"
#define kKey_Player_Selected                @"Selected"
#define kKey_Player_Score                   @"Score"
#define kKey_Player_Foul                    @"Foul"
#define kKey_Player_TimeOn                  @"TimeOn"
#define kKey_Player_BeginTime               @"BeginTime"
#define kKey_Player_EndTime                 @"EndTime"
#define kKey_player_IsSubbedOn              @"IsSubbedOn"
#define kKey_Player_FirstPeriod             @"FirstPeriod"

#define kKey_TeamName           @"teamName"
#define kKey_Player_TeamA       @"playerTeamA"
#define kKey_Player_TeamB       @"playerTeamB"
#define kKey_Actions            @"actions"
#define kKey_MatchId            @"matchId"
#define kKey_MatchList          @"matchList"
#define kKey_Match_Referees     @"referees"
#define kKey_Match_TIMEKEEPER   @"timeKeeper"
#define kKey_Match_SCOREKEEPER  @"scoreKeeper"
#define kKey_Match_MatchName    @"matchName"
#define kKey_Match_isSaved      @"isSaved"
#define kKey_Match_FileName     @"matchFileName"
#define kKey_Match_TeamACoach   @"teamACoach"
#define kKey_Match_TeamBCoach   @"teamBCoach"
#define kKey_Match_TotalTimeOn  @"totalTimeOn"
#define kKey_Match_Date         @"Date"
#define kKey_Match_IsClockDisabled      @"IsClockDisabled"

#define kKey_Action_ActionType              @"actionType"
#define kKey_Action_ActionTime              @"actionTime"
#define kKey_Action_ActionLocation          @"actionLocation"
#define kKey_Action_PlayerIndex             @"playerIndex"
#define kKey_Action_TeamIndex               @"teamIndex"
#define kKey_Action_Period                  @"period"

#define kKey_Action_Location_X              @"locationX"
#define kKey_Action_Location_Y              @"locationY"
#define kKey_Action_IsSaved                 @"isSaved"
#define kKey_Action_IsReplaced              @"isReplaced"





//////Tag for filling content to html form

#define HTMLFORM_REPORTCARD_TAG_PLAYERNO               @"[pn%d]"
#define HTMLFORM_REPORTCARD_TAG_PLAYERSCORE            @"[p%dpo%dscores]"
#define HTMLFORM_REPORTCARD_TAG_PLAYERSHOT             @"[p%dpo%dshots]"
#define HTMLFORM_REPORTCARD_TAG_PLAYERSHOTPERCENT      @"[p%dpo%dpercent]"
#define HTMLFORM_REPORTCARD_TAG_PLAYERFOUL             @"[p%dfouls]"
#define HTMLFORM_REPORTCARD_TAG_PLAYERTURNOVER         @"[p%dto]"
#define HTMLFORM_REPORTCARD_TAG_PLAYERSTEAL            @"[p%dst]"
#define HTMLFORM_REPORTCARD_TAG_PLAYERASSIST           @"[p%das]"
#define HTMLFORM_REPORTCARD_TAG_PLAYERREBOUND          @"[p%drb]"
#define HTMLFORM_REPORTCARD_TAG_PLAYERTIMEON           @"[p%dton]"
#define HTMLFORM_REPORTCARD_TAG_PLAYERFIELDSHOTMADE    @"[p%dfsmade]"
#define HTMLFORM_REPORTCARD_TAG_PLAYERFIELDSHOT        @"[p%dfs]"
#define HTMLFORM_REPORTCARD_TAG_PLAYERFIELDSHOTPERCENT @"[p%dfspercent]"

#define HTMLFORM_REPORTCARD_TAG_ALLSCORE            @"[allpo%dscores]"
#define HTMLFORM_REPORTCARD_TAG_ALLSHOT             @"[allpo%dshots]"
#define HTMLFORM_REPORTCARD_TAG_ALLSHOTPERCENT      @"[allpo%dpercent]"
#define HTMLFORM_REPORTCARD_TAG_ALLFOUL             @"[allfouls]"
#define HTMLFORM_REPORTCARD_TAG_ALLTURNOVER         @"[allto]"
#define HTMLFORM_REPORTCARD_TAG_ALLSTEAL            @"[allst]"
#define HTMLFORM_REPORTCARD_TAG_ALLASSIST           @"[allas]"
#define HTMLFORM_REPORTCARD_TAG_ALLREBOUND          @"[allrb]"
#define HTMLFORM_REPORTCARD_TAG_ALLPOINTS           @"[allpoints]"
#define HTMLFORM_REPORTCARD_TAG_ALLTIMEON           @"[allton]"
#define HTMLFORM_REPORTCARD_TAG_ALLFIELDSHOTMADE    @"[allfsmade]"
#define HTMLFORM_REPORTCARD_TAG_ALLFIELDSHOT        @"[allfs]"
#define HTMLFORM_REPORTCARD_TAG_ALLFIELDSHOTPERCENT @"[allfspercent]"
#define HTMLFORM_REPORTCARD_TAG_TOTALSCORE          @"[tt%dscores]"
#define HTMLFORM_REPORTCARD_TAG_TOTALSHOT           @"[tt%dshots]"
#define HTMLFORM_REPORTCARD_TAG_TOTALPERCENT        @"[tt%dpercent]"
#define HTMLFORM_REPORTCARD_TAG_TEAMNAME            @"[teamName]"
#define HTMLFORM_REPORTCARD_TAG_POINTS              @"[tt%dpoints]"
////////Tag for ScoreCard template
#define HTMLFORM_SCORECARD_TAG_TEAMNAME                     @"[teamName%@]"
#define HTMLFORM_SCORECARD_TAG_PLAYERNUMBER                 @"[P%@%d]"
#define HTMLFORM_SCORECARD_TAG_PLAYERNAME                   @"[P%@N%d]"
#define HTMLFORM_SCORECARD_TAG_PLAYERSCORE                  @"[S%@%d]"
#define HTMLFORM_SCORECARD_TAG_PLAYERFOULS                  @"[F%@%d]"
#define HTMLFORM_SCORECARD_TAG_TIMEOUT                      @"[TO%d%@]"
#define HTMLFORM_SCORECARD_TAG_SCORE                        @"[S%d%@]"
#define HTMLFORM_SCORECARD_TAG_FOULS                        @"[F%d%@]"
#define HTMLFORM_SCORECARD_TAG_REFEREES                     @"[referees]"
#define HTMLFORM_SCORECARD_TAG_TIMEKEEPER                   @"[timeKeeper]"
#define HTMLFORM_SCORECARD_TAG_SCOREKEEPER                  @"[scoreKeeper]"
#define HTMLFORM_SCORECARD_TAG_MATCHNAME                    @"[matchName]"
#define HTMLFORM_SCORECARD_TAG_DOT                          @"[D%@%d]"
#define HTMLFORM_SCORECARD_TAG_TEAMACOACH                   @"[teamACoach]"
#define HTMLFORM_SCORECARD_TAG_TEAMBCOACH                   @"[teamBCoach]"
#define HTMLFORM_SCORECARD_TAG_TEAMATOTAL                   @"[teamATotal]"
#define HTMLFORM_SCORECARD_TAG_TEAMBTOTAL                   @"[teamBTotal]"
#define HTMLFORM_SCORECARD_TAG_TECHFOULA                    @"[TechFoulA]"
#define HTMLFORM_SCORECARD_TAG_TECHFOULB                    @"[TechFoulB]"


#define HTMLFORM_PLAYERREPORT_FIELDSHOTTOTAL        @"[fieldShotTotal]"
#define HTMLFORM_PLAYERREPORT_MATCHNAME             @"[matchName]"
#define HTMLFORM_PLAYERREPORT_TEAMNAME              @"[teamName]"
#define HTMLFORM_PLAYERREPORT_PLAYERNAME            @"[playerName]"
#define HTMLFORM_PLAYERREPORT_FOULS                 @"[fouls]"
#define HTMLFORM_PLAYERREPORT_FOULSHOTS             @"[foulShots]"
#define HTMLFORM_PLAYERREPORT_FOULSHOTSTOTAL        @"[foulShotsTotal]"
#define HTMLFORM_PLAYERREPORT_FOULSHOTSPERCENT      @"[foulShotsPercent]"
#define HTMLFORM_PLAYERREPORT_FIELDSHOTS2           @"[fieldShots2]"
#define HTMLFORM_PLAYERREPORT_FIELDSHOTS2TOTAL      @"[fieldShots2Total]"
#define HTMLFORM_PLAYERREPORT_FIELDSHOTS2PERCENT    @"[fieldShots2Percent]"
#define HTMLFORM_PLAYERREPORT_FIELDSHOTS3           @"[fieldShots3]"
#define HTMLFORM_PLAYERREPORT_FIELDSHOTS3TOTAL      @"[fieldShots3Total]"
#define HTMLFORM_PLAYERREPORT_FIELDSHOTS3PERCENT    @"[fieldShots3Percent]"
#define HTMLFORM_PLAYERREPORT_TOTALPOINTS           @"[totalPoints]"
#define HTMLFORM_PLAYERREPORT_FOULS                 @"[fouls]"
#define HTMLFORM_PLAYERREPORT_TURNOVERS             @"[turnOvers]"
#define HTMLFORM_PLAYERREPORT_STEALS                @"[steals]"
#define HTMLFORM_PLAYERREPORT_ASSISTS               @"[assists]"
#define HTMLFORM_PLAYERREPORT_REBOUNDS              @"[rebounds]"
#define HTMLFORM_PLAYERREPORT_TIMEONCOURT           @"[timeOnCourt]"

////////
#define HTML_ID_REFEREES                @"referees"
#define HTML_ID_TIMEKEEPER              @"timeKeeper"
#define HTML_ID_SCOREKEEPER             @"scoreKeeper"
#define HTML_ID_MATCHNAME               @"matchName"
#define HTML_ID_TEAMACOACH              @"teamACoach"
#define HTML_ID_TEAMBCOACH              @"teamBCoach"
//////////
#define HTML_DOT                        @"<div align=\"center\" style=\"font-size:30px\">.</div>"
#define HTML_TWODOT                        @"<div align=\"center\" style=\"font-size:50px\">:</div>"
#define META_VIEWPORT   @"<meta name=\"viewport\" width = \"100%\">"
#define INPUT_TEXT      @"<input type=\"text\" style=\"border-style:dotted\" size=\"35\" id=\"%@\" autocapitalize=\"words\" onkeypress=\"submitonenter(event,this)\"/>"
#define HTML_IMG_BASE64     @"<img src=\"data:image/png;base64,%@\"/>"
#define TITLE_REPORTCARD                @"Report Card: %@"
#define TITLE_MATCHESLIST               @"Match List"
#define TITLE_STATISTICSOPTION          @"Stored Data for match: "
#define TITLE_SCORECARD                 @"Score Card"
#define TITLE_RAWMATCHDATA              @"Raw Match Data: %@"
#define TITLE_MATCHREPORT               @"Match Reports: %@"
#define TITLE_TEAMLIST                  @"Team List"
#define TITLE_PLAYERLIST                @"Player List"
#define TITLE_PLAYERREPORTCARD          @"Player Report Card"
#define TITLE_ACTIONLIST                @"Previous Actions"

#define STATISTICSVIEW_PLAYERINDEX_ALL          0




