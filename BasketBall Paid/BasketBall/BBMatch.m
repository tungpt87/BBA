//
//  BBMatch.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBMatch.h"

@implementation BBMatch

- (id) init{
    self = [super init];
    if (self) {
        matchId = [[self matchId] retain];
    }
    return self;
}
#pragma mark - Private methods
- (NSString*) matchId{
    NSString *mId = [NSDateFormatter localizedStringFromDate:[NSDate date] 
                                                               dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle];
    return mId;
}

- (void) addAction:(BBActionRef*)action{

}

- (void) setATeamName:(NSString*)name{

}

- (void) setBTeamName:(NSString*)name{

}

@end
