//
//  BBBallPin.h
//  BasketBall
//
//  Created by TungPT on 1/5/13.
//
//

#import <UIKit/UIKit.h>
#import "BBMovableView.h"
@interface BBBallPin : BBMovableView
@property (nonatomic) BOOL isAppeared;
+ (BBBallPin*) defaultBallPin;
@end
