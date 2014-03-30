//
//  BBMatchRunSheetViewController.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBMatchRunSheetViewController.h"

@interface BBMatchRunSheetViewController ()

@end

@implementation BBMatchRunSheetViewController
#pragma mark - Private Methods
- (void) barButtonDidTap:(id)sender{
    if (as) {
        [as dismissWithClickedButtonIndex:-1
                                 animated:NO];
        F_RELEASE(as);
    }
    as = [[UIActionSheet alloc] initWithTitle:nil
                                     delegate:(id)self
                            cancelButtonTitle:nil
                       destructiveButtonTitle:nil
                            otherButtonTitles:@"Print",@"Email",@"Open", nil];
    
    [as showFromBarButtonItem:self.navigationController.navigationBar.topItem.rightBarButtonItem
                     animated:YES];
    //    F_RELEASE(as);
    
}

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
    NSString *strRunSheet = @"| ";
    NSArray *arrActions = (NSArray*)[_dictionary objectForKey:kKey_Actions];
    NSArray *arrTeamName = [_dictionary objectForKey:kKey_TeamName];
    NSString *strTeamNameA = (NSString*)[arrTeamName objectAtIndex:0];
    NSString *strTeamNameB = (NSString*)[arrTeamName objectAtIndex:1];
    BOOL isClockDisabled = [[_dictionary objectForKey:kKey_Match_IsClockDisabled] boolValue];
    if (!strTeamNameA) {
        strTeamNameA = @"";
    }
    
    if (!strTeamNameB) {
        strTeamNameB = @"";
    }
    
    [teamNameA setText:[NSString stringWithFormat:@"A: %@",strTeamNameA]];
    [teamNameB setText:[NSString stringWithFormat:@"B: %@",strTeamNameB]];
    NSInteger totalA = 0, totalB = 0;
    for (NSDictionary *action in arrActions) {
        ACTION_TYPE actionType = [(NSNumber*)[action objectForKey:kKey_Action_ActionType] intValue];
        NSInteger teamIndex = [(NSNumber*)[action objectForKey:kKey_Action_TeamIndex] intValue];
        if (actionType == ACTION_TYPE_QRTEND || actionType == ACTION_TYPE_QRTSTART || actionType == ACTION_TYPE_ONEMADE || actionType == ACTION_TYPE_TWOMADE || actionType == ACTION_TYPE_THREEMADE || actionType == ACTION_TYPE_FOUL || actionType == ACTION_TYPE_TECHFOUL || actionType == ACTION_TYPE_FOUL1 || actionType == ACTION_TYPE_FOUL2 || actionType == ACTION_TYPE_FOUL3 || actionType == ACTION_TYPE_PLAYERON || actionType == ACTION_TYPE_PLAYEROFF || actionType == ACTION_TYPE_TIMEOUT) {
            NSString *strPlayer;
            NSInteger playerIndex = [[action objectForKey:kKey_Action_PlayerIndex] intValue];
            NSArray *arrPlayers = nil;
            if (teamIndex == 0) {
                arrPlayers = [_dictionary objectForKey:kKey_Player_TeamA];
            } else {
                arrPlayers = [_dictionary objectForKey:kKey_Player_TeamB];
            }
            
            if (playerIndex > 0) {
                NSDictionary *dictPlayer = nil;
                for (NSDictionary *dict in arrPlayers) {
                    if ([[dict objectForKey:kKey_Player_Index] intValue] == playerIndex) {
                        dictPlayer = dict;
                        break;
                    }
                }
                NSInteger playerNumber = [(NSNumber*)[dictPlayer objectForKey:kKey_PlayerNumber] intValue];
                if ([(NSNumber*)[action objectForKey:kKey_Action_TeamIndex] intValue] == 0) {
                    strPlayer = [NSString stringWithFormat:@"A%d",playerNumber];
                }else if ([(NSNumber*)[action objectForKey:kKey_Action_TeamIndex] intValue] == 1){
                    strPlayer = [NSString stringWithFormat:@"B%d",playerNumber];
                } else {
                    strPlayer = @"";
                }
            } else {
                if ([(NSNumber*)[action objectForKey:kKey_Action_TeamIndex] intValue] == 0) {
                    strPlayer = @"A";
                }else if ([(NSNumber*)[action objectForKey:kKey_Action_TeamIndex] intValue] == 1){
                    strPlayer = @"B";
                } else {
                    strPlayer = @"";
                }

            }
            NSString *strAction = nil;
            NSInteger point = 0;
            if (actionType == ACTION_TYPE_TECHFOUL) {
                strAction = RAWDATA_TECHFOUL;
            } else if(actionType == ACTION_TYPE_FOUL){
                strAction = RAWDATA_FOUL;
            } else if(actionType == ACTION_TYPE_FOUL1){
                strAction = RAWDATA_FOUL1;
            } else if(actionType == ACTION_TYPE_FOUL2){
                strAction = RAWDATA_FOUL2;
            } else if (actionType == ACTION_TYPE_FOUL3){
                strAction = RAWDATA_FOUL3;
            }
            else if(actionType == ACTION_TYPE_THREEMADE){
                point = 3;
                strAction = RAWDATA_THREEMADE;
            } else if(actionType == ACTION_TYPE_TWOMADE){
                point = 2;
                strAction = RAWDATA_TWOMADE;
            } else if(actionType == ACTION_TYPE_ONEMADE){
                point = 1;
                strAction = RAWDATA_ONEMADE;
            } else if(actionType == ACTION_TYPE_QRTSTART){
                strAction = RAWDATA_QUARTERSTART;
            } else if(actionType == ACTION_TYPE_QRTEND){
                strAction = RAWDATA_QUARTEREND;
            } else if (actionType == ACTION_TYPE_PLAYERON){
                strAction = RAWDATA_PLAYERON;
            } else if (actionType == ACTION_TYPE_PLAYEROFF){
                strAction = RAWDATA_PLAYEROFF;
            } else if (actionType == ACTION_TYPE_TIMEOUT){
                strAction = RAWDATA_TIMEOUT;
            }
            if (point > 0) {
                if (teamIndex == 0) {
                    totalA += point;
                } else {
                    totalB += point;
                }
            }
            CGFloat actionTime = [[action objectForKey:kKey_Action_ActionTime] floatValue];
//            NSString *time = [NSString stringWithFormat:@"%d:%d",intActionTime/60,intActionTime%60];
            NSString *time = nil;
            if (isClockDisabled) {
                time = kDisableTimeTitle;
            } else {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"mm:ss"];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:actionTime];
                time = [dateFormatter stringFromDate:date];
                [dateFormatter release];
            }
            NSString *runSheet = [NSString stringWithFormat:@"%@ %@ %@ | ",time, strPlayer,strAction];
            if (actionType == ACTION_TYPE_QRTEND && action != arrActions.lastObject) {
                runSheet = [runSheet stringByAppendingString:@"\n\n| "];
            }
//            runSheet = [runSheet stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
            strRunSheet = [strRunSheet stringByAppendingFormat:@"%@",runSheet];
        }
    }
    [scoreA setText:[NSString stringWithFormat:@"%d",totalA]];
    [scoreB setText:[NSString stringWithFormat:@"%d",totalB]];
    [textView setText:strRunSheet];
    NSLog(@"Run Sheet: %@",strRunSheet);
    NSString *matchName = (NSString*)[_dictionary objectForKey:kKey_Match_MatchName];
    [self setTitle:[NSString stringWithFormat:TITLE_RAWMATCHDATA,matchName]];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc{
    [super dealloc];
    F_RELEASE(_dictionary);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *matchName = [_dictionary objectForKey:kKey_Match_MatchName];
    switch (buttonIndex) {
        case 0:
            [CommonUtils printViewcontent:self.view
                        fromBarButtonItem:self.navigationController.navigationBar.topItem.rightBarButtonItem
                                 delegate:self];
            break;
        case 1:
            [CommonUtils createEmailFromImageOfView:self.view
                                            subject:[NSString stringWithFormat:kEmailSubject_RawMatchData,matchName]
                                          matchName:matchName
                                           delegate:self];
//            [CommonUtils createEmailFromImageOfView:self.view 
//                                            matchName:matchName
//                                           delegate:self];
            break;
        case 2:
        {
            NSString *matchName = [_dictionary objectForKey:kKey_Match_MatchName];
            NSString *fileName = [NSString stringWithFormat:@"RawData_%@.pdf",matchName];
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
#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissModalViewControllerAnimated:YES];
}
@end
