//
//  DataManager.h
//  AppIcon
//
//  Created by Dat Nguyen on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTeam.h"
#import "BBMatch.h"
#import "BBPlayer.h"
#import "BBTeamNameView.h"

#define kPopOverSize_Width              300
#define kPopOverSize_Height             400

#define kActionListPopOverSize_Width    600
#define kActionListPopOverSize_Height   500

#define kTableViewCell_Height           44
#define kPopupButtonBar_Width           400
#define kPopupButtonBar_Height          44
////Tag
#define TAG_AUTOFILLTABLEVIEW_TEAM      1011
#define TAG_AUTOFILLTABLEVIEW_PLAYER    1012
#define TAG_SUGGESTIONTABLEVIEW         102
#define TAG_ACTIONLISTTABLEVIEW         103


////ReusableIdentifier
#define REUSABLE_IDENTIFIER_AUTOFILL        @"autofill"
#define REUSABLE_IDENTIFIER_TEAMSUGGESTION  @"teamsuggestion"
#define REUSABLE_IDENTIFIER_ACTIONLIST      @"actionlist"
@class DataManager;

@protocol BarButtonPopOverDelegate <NSObject>

@optional
- (void) barButtonPopOverDidTapAtIndex:(NSInteger)index sender:(id)sender;

@end


@interface DataManager : NSObject<UITableViewDelegate, UITableViewDataSource,UIPopoverControllerDelegate>{

    UIPopoverController *popOverViewController;

    

    UITextField *autoFillTextField;

    NSArray *autoFillDataSource;
    NSArray *teamSuggestionDataSource;
    
    NSMutableArray *teamNames;
    NSMutableArray *playerNames;
    
    NSMutableArray *arrRecordedTeams;
    NSMutableArray *arrRecordedPlayers;
    NSArray *arrActions, *arrActionNames;
    UITableViewController *displayedTableViewController;
    BBTeamNameView *onEditingTeamName;
    
    NSDictionary *dictMatch;
    
    CGFloat remainingTime;
    NSInteger period;
}
@property (nonatomic) NSInteger period;
@property (nonatomic) CGFloat remainingTime;
#pragma mark - Static methods
+ (DataManager *)defaultManager;
+ (NSDictionary*) statisicDictionaryWithFile:(NSString*)fileName;
+ (NSArray*) arrayOfRecordedMatchs;


#pragma mark - Dynamic methods
//- (void) displayAutofillPopOverForTextField:(UITextField*)textField inView:(UIView*)view dataSource:(NSArray*)dataSource delegate:(id)delegate animated:(BOOL)animated;

- (void) displayActionListPopOverWithDatasource:(NSArray*)dataSource names:(NSArray*)arrName delegate:(id)delegate rect:(CGRect)rect inView:(UIView*)view animated:(BOOL)animated;
- (void) dismissPopOverViewWithAnimated:(BOOL)animated;

+ (NSArray*) arrayOfRecordedTeamsWithKeyWord:(NSString*)keyWord;

- (void) addTeamName:(NSString*)teamName;


+ (NSArray*) arrayOfRecordedPlayersNameWithKeyWord:(NSString*)keyWord;
- (void) addPlayerName:(NSString*)playerName;
+ (void) deleteTeamName:(NSString*)aTeamName;
+ (void) deletePlayerName:(NSString*)aPlayerName;
+ (void) addMatchWithDictionary:(NSDictionary*)aDictionary matchName:(NSString*)aFileName;
+ (void) deleteMatchWithIndex:(NSInteger)index;
+ (void) setFoulDangerLimit:(NSInteger)aNumber;
+ (NSInteger) foulDangerLimit;
+ (void) setTeamFoulDangerLimit:(NSInteger)aNumber;
+ (NSInteger) teamFoulDangerLimit;
+ (void) setUserDefaultObject:(id)object forKey:(NSString*)key;
+ (id) userDefaultObjectForKey:(NSString*)key;
+(void) userDefaultRemoveObjectForKey:(NSString*)key;
@end
