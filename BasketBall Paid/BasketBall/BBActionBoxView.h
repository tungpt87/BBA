//
//  BBToggleButtonsView.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBActionView.h"
#define kDistanceBetweenButtons         10
#define kLeftMargin                     10

@class BBActionBoxView;

@protocol BBtoggleButtonViewDelegate <NSObject>

@required
- (void) toggleButtonView:(BBActionBoxView*)toggleButtonView actionViewDidTapped:(BBActionView*)actionView;

@end

@interface BBActionBoxView : UIView<UIGestureRecognizerDelegate>{
    CGFloat buttonHeight, buttonWidth;
    id <BBtoggleButtonViewDelegate> delegate;
}

@property (nonatomic, retain) id <BBtoggleButtonViewDelegate> delegate;

- (void) setButtonWidth:(CGFloat)width;
- (void) setButtonHeight:(CGFloat)height;
- (void) setButtonTitles:(NSArray*)titles;
- (void) deselectAll;
- (BBActionView*) selectedButton;
- (void) setEnable:(BOOL)enable;
- (void) setActionWithType:(ACTION_TYPE)actionType;
- (void) setFlashing:(BOOL)flashing;
- (void) setFlashing:(BOOL)flashing forType:(ACTION_TYPE)actionType;
- (void) setFlashing:(BOOL)flashing forTypes:(NSArray*)actionTypes;
- (void) setEnable:(BOOL)enable forTypes:(NSArray*)actionTypes;
- (void) selectActionType:(ACTION_TYPE)actionType;

@end
