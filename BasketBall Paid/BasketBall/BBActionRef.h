//
//  BBAction.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBActionRef : NSObject{
    ACTION_TYPE actionType;
    CGPoint actionLocation;
    CGFloat actionTime;
    
    NSInteger teamIndex;
    NSInteger playerIndex;
    NSInteger period;
    BOOL isReplaced;
    BOOL isSaved;
}
@property (nonatomic) BOOL isSaved;
@property (nonatomic) BOOL isReplaced;
@property (nonatomic) NSInteger period;
@property (nonatomic) ACTION_TYPE actionType;
@property (nonatomic) CGPoint actionLocation;
@property (nonatomic) CGFloat actionTime;
@property (nonatomic) NSInteger playerIndex;
@property (nonatomic) NSInteger teamIndex;
- (id) initWithTime:(CGFloat)time;
- (id) initWithAction:(BBActionRef*)anAction;
- (id) initWithDictionary:(NSDictionary*)dictionary;
- (CGPoint) locationInView:(UIView*)view;
- (NSDictionary*) dictionary;
@end
