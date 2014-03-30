//
//  BBMatch.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTeam.h"
#import "BBPlayer.h"
#import "BBActionRef.h"
@interface BBMatch : NSObject{
    NSString *matchId;
    NSString *title;
    NSString *teamAId;
    NSString *teamBId;
}
- (void) addAction:(BBActionRef*)action;
- (void) setATeamName:(NSString*)name;
- (void) setBTeamName:(NSString*)name;
@end
