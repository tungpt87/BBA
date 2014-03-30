//
//  DataManager.m
//  AppIcon
//
//  Created by Dat Nguyen on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"

static DataManager * _instance;

@interface DataManager (Privates)
- (void) popUpBarButtonDidTapped:(id)sender;

@end
@implementation DataManager
@synthesize remainingTime;
@synthesize period;
+ (DataManager *)defaultManager;
{
    @synchronized(_instance) {
        if (_instance == nil) {
            _instance = [[DataManager alloc]init];
        }
    }
    
    return _instance;
}

- (void) displayActionListPopOverWithDatasource:(NSArray*)dataSource names:(NSArray*)arrName delegate:(id)delegate rect:(CGRect)rect inView:(UIView*)view animated:(BOOL)animated{
    [self dismissPopOverViewWithAnimated:NO];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        BBActionRef *action = (BBActionRef*)evaluatedObject;
        if (action.actionType != ACTION_TYPE_QRTEND && action.actionType != ACTION_TYPE_QRTSTART && action.actionType != ACTION_TYPE_TIMEOUT && action.isSaved) {
            return YES;
        } else {
            return NO;
        }
    }];
    arrActionNames = [[NSArray alloc] initWithArray:arrName];
    arrActions = [[dataSource filteredArrayUsingPredicate:predicate] retain];
    UITableViewController *contentViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [contentViewController.tableView setDelegate:self];
    [contentViewController.tableView setDataSource:self];
    [contentViewController.tableView setTag:TAG_ACTIONLISTTABLEVIEW];
    [contentViewController setTitle:TITLE_ACTIONLIST];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:contentViewController];
//    [contentViewController.tableView setBackgroundColor:[UIColor clearColor]];
    if (!popOverViewController) {
        popOverViewController = [[UIPopoverController alloc] initWithContentViewController:navController];
        
        [popOverViewController setDelegate:delegate];
        [popOverViewController setPopoverContentSize:CGSizeMake(kActionListPopOverSize_Width,kActionListPopOverSize_Height)];

    }
    [navController release];
    F_RELEASE(contentViewController);
    [popOverViewController presentPopoverFromRect:rect 
                                           inView:view
                         permittedArrowDirections:UIPopoverArrowDirectionDown
                                         animated:YES];
}
- (void) dismissPopOverViewWithAnimated:(BOOL)animated{
    [popOverViewController dismissPopoverAnimated:animated];
    NSLog(@"Did dismiss pop over view controller");
    F_RELEASE(teamSuggestionDataSource);
    F_RELEASE(popOverViewController);
    F_RELEASE(arrActions);
    F_RELEASE(autoFillDataSource);
    F_RELEASE(teamSuggestionDataSource);
    
    F_RELEASE(teamNames);
    F_RELEASE(playerNames);
    displayedTableViewController = nil;
//    F_RELEASE(arrRecordedTeams);
//    F_RELEASE(arrRecordedPlayers);



}




#pragma mark - Data management in and out
+ (NSArray*) arrayOfRecordedTeamsWithKeyWord:(NSString*)keyWord{
    //Logic sequence for loading array of recorded teams
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(NSString*)evaluatedObject uppercaseString]rangeOfString:[keyWord uppercaseString]].length > 0 && [[(NSString*)evaluatedObject uppercaseString]rangeOfString:[keyWord uppercaseString]].location == 0) {
            return YES;
        } else {
            return NO;
        }
    }];

    NSArray *arrTeams;
//    if (!arrRecordedTeams) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[CommonUtils documentPathForFile:kFileName_ListTeams]]) {
            NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[CommonUtils documentPathForFile:kFileName_ListTeams]];
            arrTeams = [dictionary objectForKey:kKey_TeamList];
        }
        else {
            arrTeams = [NSMutableArray array];
        }
//    }
    if (keyWord && keyWord.length > 0) {
        arrTeams = [arrTeams filteredArrayUsingPredicate:predicate];
    }
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
    arrTeams = [arrTeams sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return arrTeams;
}

- (void) addTeamName:(NSString*)teamName{
    NSString *name = [teamName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    NSMutableArray *arrTeams = nil;
    if (!arrTeams) {
        if ([CommonUtils existingOfFileWithName:kFileName_ListTeams]) {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[CommonUtils documentPathForFile:kFileName_ListTeams]];
            arrTeams = [NSMutableArray arrayWithArray:[dict objectForKey:kKey_TeamList]];
        }
        else {
            arrTeams = [NSMutableArray array];
        }
        
    }
    BOOL isExist = NO;
    for (NSString *string in arrTeams) {
        if ([[string uppercaseString] isEqualToString:[name uppercaseString]]) {
            isExist = YES;
            break;
        }
    }
    if (!isExist) {
        [arrTeams addObject:name];
    }

    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:arrTeams forKey:kKey_TeamList];
//    F_RELEASE(arrRecordedTeams);
    [dictionary writeToFile:[CommonUtils documentPathForFile:kFileName_ListTeams] atomically:NO];
//    arrRecordedTeams = [[NSMutableArray alloc] initWithArray:[self arrayOfRecordedTeams]];

}

+ (void) deleteTeamName:(NSString*)aTeamName{
    NSMutableArray *arrRecordedTeams = [NSMutableArray arrayWithArray:[self arrayOfRecordedTeamsWithKeyWord:@""]];
    if (!arrRecordedTeams || arrRecordedTeams.count == 0) {
        return;
    }
    for (NSString *string in arrRecordedTeams) {
        if ([string isEqualToString:aTeamName]) {
            [arrRecordedTeams removeObject:string];
            break;
        }
    }
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:arrRecordedTeams forKey:kKey_TeamList];
    [dictionary writeToFile:[CommonUtils documentPathForFile:kFileName_ListTeams] atomically:NO];

}


+ (NSArray*) arrayOfRecordedPlayersNameWithKeyWord:(NSString*)keyWord{
    NSArray *arrPlayers;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(NSString*)evaluatedObject uppercaseString]rangeOfString:[keyWord uppercaseString]].length > 0 && [[(NSString*)evaluatedObject uppercaseString]rangeOfString:[keyWord uppercaseString]].location == 0) {
            return YES;
        } else {
            return NO;
        }
    }];

//    if (!arrRecordedPlayers) {
        if ([CommonUtils existingOfFileWithName:kFileName_ListPlayers]) {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[CommonUtils documentPathForFile:kFileName_ListPlayers]];
            arrPlayers = [dict objectForKey:kKey_PlayerList];
        }
        else {
            arrPlayers = [NSMutableArray array];
        }

//    }

    if (keyWord && keyWord.length > 0) {
        arrPlayers = [arrPlayers filteredArrayUsingPredicate:predicate];
    }
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
    arrPlayers = [arrPlayers sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    return arrPlayers;

}

- (void) addPlayerName:(NSString*)playerName{
    NSString *name = [playerName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    NSMutableArray *arrPlayers = nil;
    if ([CommonUtils existingOfFileWithName:kFileName_ListPlayers]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[CommonUtils documentPathForFile:kFileName_ListPlayers]];
        arrPlayers = [NSMutableArray arrayWithArray:[dict objectForKey:kKey_PlayerList]];
    }
    else {
        arrPlayers = [NSMutableArray array];
    }

    BOOL isExist = NO;
    for (NSString *string in arrPlayers) {
        if ([[string uppercaseString] isEqualToString:[name uppercaseString]]) {
            isExist = YES;
            break;
        }
    }
    
    if (!isExist) {
        [arrPlayers addObject:name];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:arrPlayers forKey:kKey_PlayerList];
    [dict writeToFile:[CommonUtils documentPathForFile:kFileName_ListPlayers] atomically:NO];
//    F_RELEASE(arrRecordedPlayers);
//    arrRecordedPlayers = (NSMutableArray*)[[self arrayOfRecordedPlayersName] retain];
    
}

+ (void) deletePlayerName:(NSString*)aPlayerName{
    NSMutableArray *arrPlayers;
    if ([CommonUtils existingOfFileWithName:kFileName_ListPlayers]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[CommonUtils documentPathForFile:kFileName_ListPlayers]];
        arrPlayers = [NSMutableArray arrayWithArray:[dict objectForKey:kKey_PlayerList]];
    }
    else {
        return;
    }

    for (NSString *string in arrPlayers) {
        if ([string isEqualToString:aPlayerName]) {
            [arrPlayers removeObject:string];
            break;
        }
    }
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:arrPlayers forKey:kKey_PlayerList];
    [dict writeToFile:[CommonUtils documentPathForFile:kFileName_ListPlayers] atomically:NO];
}


+ (void) addMatchWithDictionary:(NSDictionary*)aDictionary matchName:(NSString*)aMatchName{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmm"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.plist",strDate,aMatchName];
    [aDictionary writeToFile:[CommonUtils documentPathForFile:[NSString stringWithFormat:@"%@",fileName]]
                  atomically:NO];
    NSString *date = [aDictionary objectForKey:kKey_NewMatch_Date];
    NSString *filePath = [CommonUtils documentPathForFile:kFileName_MatchsList];
    NSMutableArray *matchList;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        matchList = [NSMutableArray arrayWithArray:[dict objectForKey:kKey_MatchList]];
    }
    else {
        matchList = [NSMutableArray array];
    }
    NSDictionary *match = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:aMatchName,fileName,date, nil]
                                                      forKeys:[NSArray arrayWithObjects:kKey_Match_MatchName,kKey_Match_FileName,kKey_Match_Date, nil]];
    [matchList addObject:match];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:matchList
                                                     forKey:kKey_MatchList];
    [dict writeToFile:filePath atomically:NO];

}

+ (void) deleteMatchWithIndex:(NSInteger)index{
    NSMutableArray *matchList;
    NSString *filePath = [CommonUtils documentPathForFile:kFileName_MatchsList];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        matchList = [NSMutableArray arrayWithArray:[dict objectForKey:kKey_MatchList]];
    }
    else {
        matchList = [NSMutableArray array];
    }
    if (index < [matchList count]) {
        NSDictionary *matchInfo = [matchList objectAtIndex:index];
        NSString *fileName = [matchInfo objectForKey:kKey_Match_FileName];
        NSString *filePath = [CommonUtils documentPathForFile:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                       error:nil];
        }
        [matchList removeObjectAtIndex:index];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObject:matchList
                                                     forKey:kKey_MatchList];
    [dict writeToFile:filePath
           atomically:NO];
}

+ (NSDictionary*) statisicDictionaryWithFile:(NSString*)fileName{
    NSString *filePath = [CommonUtils documentPathForFile:fileName];
    NSDictionary *dictMatch = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dictMatch;
}

+ (NSArray*) arrayOfRecordedMatchs{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[CommonUtils documentPathForFile:kFileName_MatchsList]];
    NSArray *arrMatchs = [dict objectForKey:kKey_MatchList];
    return arrMatchs;
}

+ (void) setFoulDangerLimit:(NSInteger)aNumber{
    NSLog(@"Set foul danger limit: %d",aNumber);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:aNumber]
                                              forKey:kUserDefaultKey_FoulDangerLimit];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidChangeDangerLimit
                                                        object:[NSNumber numberWithInt:aNumber]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShouldCheckTeamFoul
                                                        object:nil];
}
+ (void) setTeamFoulDangerLimit:(NSInteger)aNumber{
    NSLog(@"Set foul danger limit: %d",aNumber);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:aNumber]
                                              forKey:kUserDefaultKey_TeamFoulDangerLimit];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidChangeTeamDangerLimit
                                                        object:[NSNumber numberWithInt:aNumber]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShouldCheckTeamFoul
                                                        object:nil];
}
+ (NSInteger) foulDangerLimit{
    NSNumber *foulDanger = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKey_FoulDangerLimit];
    if (foulDanger && [foulDanger intValue] > 0) {
        return [foulDanger intValue];
    }
    return 5;
}
+ (NSInteger) teamFoulDangerLimit{
    NSNumber *foulDanger = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKey_TeamFoulDangerLimit];
    if (foulDanger && [foulDanger intValue] > 0) {
        return [foulDanger intValue];
    }
    return 5;
}

+(void) userDefaultRemoveObjectForKey:(NSString*)key{
    if ([self userDefaultObjectForKey:key]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
+ (void) setUserDefaultObject:(id)object forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setObject:object
                                              forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id) userDefaultObjectForKey:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == TAG_AUTOFILLTABLEVIEW_TEAM || tableView.tag == TAG_AUTOFILLTABLEVIEW_PLAYER || tableView.tag == TAG_SUGGESTIONTABLEVIEW || tableView.tag == TAG_ACTIONLISTTABLEVIEW) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == TAG_AUTOFILLTABLEVIEW_TEAM || tableView.tag == TAG_AUTOFILLTABLEVIEW_PLAYER) {
        if (autoFillDataSource) {
            return [autoFillDataSource count];
        }
    }
    else if (tableView.tag == TAG_SUGGESTIONTABLEVIEW){
        if (teamSuggestionDataSource) {
            return [teamSuggestionDataSource count];
        }
    } else if (tableView.tag == TAG_ACTIONLISTTABLEVIEW){
        if (arrActions) {
            return [arrActions count];
        }
    }
   return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *textLabel = nil;
    NSString *reusableIdentifier = nil;
    UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
    BOOL isReplaced = NO;
    if (tableView.tag == TAG_AUTOFILLTABLEVIEW_TEAM || tableView.tag == TAG_AUTOFILLTABLEVIEW_PLAYER) {
        textLabel = (NSString*)[autoFillDataSource objectAtIndex:indexPath.row];
        reusableIdentifier = REUSABLE_IDENTIFIER_AUTOFILL;
        cellStyle = UITableViewCellStyleDefault;
    }
    else if (tableView.tag == TAG_SUGGESTIONTABLEVIEW){
        textLabel = (NSString*)[teamSuggestionDataSource objectAtIndex:indexPath.row];
        reusableIdentifier = REUSABLE_IDENTIFIER_TEAMSUGGESTION;
        cellStyle = UITableViewCellStyleDefault;
    }
    else if (tableView.tag == TAG_ACTIONLISTTABLEVIEW){
        cellStyle = UITableViewCellStyleDefault;
        reusableIdentifier = REUSABLE_IDENTIFIER_ACTIONLIST;
        textLabel = [arrActionNames objectAtIndex:indexPath.row];
        BBActionRef *action = [arrActions objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == TAG_AUTOFILLTABLEVIEW_TEAM || tableView.tag == TAG_AUTOFILLTABLEVIEW_PLAYER) {
        if (autoFillTextField) {
            [autoFillTextField setText:(NSString*)[autoFillDataSource objectAtIndex:indexPath.row]];
            [self dismissPopOverViewWithAnimated:YES];
        }
    } else if(tableView.tag == TAG_SUGGESTIONTABLEVIEW){
        if (onEditingTeamName) {
            [onEditingTeamName setTeamName:(NSString*)[teamSuggestionDataSource objectAtIndex:indexPath.row]];
            [self dismissPopOverViewWithAnimated:YES];
        }
    } else if (tableView.tag == TAG_ACTIONLISTTABLEVIEW){
        BBActionRef *action = [arrActions objectAtIndex:indexPath.row];
        if (!action.isReplaced) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWillEditAction
                                                                object:action];
            [self dismissPopOverViewWithAnimated:YES];
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Private methods
- (void) editTableView{
    [displayedTableViewController setEditing:YES
                                    animated:YES];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneEditing)];
    displayedTableViewController.navigationController.navigationBar.topItem.rightBarButtonItem = doneButton;
    [doneButton release];
}

- (void) doneEditing{
    [displayedTableViewController setEditing:NO
                                    animated:YES];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                target:self
                                                                                action:@selector(editTableView)];
    displayedTableViewController.navigationController.navigationBar.topItem.rightBarButtonItem = editButton;
    [editButton release];
//    displayedTableViewController = nil;
}
#pragma mark - PopoverDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    F_RELEASE(popOverViewController);
    F_RELEASE(teamSuggestionDataSource);
    NSLog(@"Dismiss popover view");
}

@end
