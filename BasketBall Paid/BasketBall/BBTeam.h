//
//  BBTeam.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTeam : NSObject{
    NSString *matchId;
    NSString *teamId;
    NSString *name;
}

@property (nonatomic, retain) NSString *name;
@end
