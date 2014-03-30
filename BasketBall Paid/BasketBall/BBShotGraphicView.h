//
//  BBShotGraphicView.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBShotPin.h"
#define INLINE_RADIUS               223.0
@interface BBShotGraphicView : UIView<UIGestureRecognizerDelegate>{
    BBShotPin *shotPin;
    CGPoint location;
    UIImageView *imageView, *imvFlashing;
    ACTION_TYPE _actionType;
    BOOL isFlashing, couldStartFlashing, interaction;
    NSTimer *flashingTimer;
}
@property (nonatomic) ACTION_TYPE actionType;
@property (nonatomic, readonly) BBShotPin *shotPin;

- (void) setEnable:(BOOL)enable;
- (CGPoint) shotLocation;
- (BBShotPin*) shotPin;
- (void) clear;
- (NSInteger) score;
- (void) setShotPinWithLocation:(CGPoint)pinLocation andType:(ACTION_TYPE)type;
- (void) shotPinSetMade;
- (void) shotPinSetMiss;
- (NSInteger) pointForLocation:(CGPoint)aLocation;
@end
