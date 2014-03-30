//
//  BBActionView.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class BBActionView;

@protocol BBActionViewDelegate <NSObject>

@optional
- (void) actionViewDidTap:(BBActionView*)actionView;

@end
@interface BBActionView : UIView{
    ACTION_TYPE actionType;
    BOOL isMade;
    BOOL isFlashing;
    UIImageView *imvFlashing, *imvBackGround;
    UIImage *imNormal, *imSelected, *imFlashing;
    UIButton *button;
    BOOL _selected;
    NSTimer *flashingTimer;
    id <BBActionViewDelegate> delegate;
}

@property (nonatomic, retain) id <BBActionViewDelegate> delegate;
@property (nonatomic) ACTION_TYPE actionType;
@property (nonatomic) BOOL isMade;
@property (nonatomic) BOOL selected;
@property (nonatomic, readonly) BOOL isFlashing;

- (void) toggleFlashing:(BOOL)flashing;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (BOOL) isSelected;
@end
