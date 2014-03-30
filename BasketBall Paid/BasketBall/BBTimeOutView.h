//
//  BBTimeOutView.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
typedef enum {
    TIMEOUTVIEW_TYPE_LEFT = 0,
    TIMEOUTVIEW_TYPE_RIGHT = 1,
}TIMEOUTVIEW_TYPE;
@class BBTimeOutView;

@protocol BBTimeOutViewDelegate <NSObject>

@required

- (void) timeOutViewDidIncreaseValue:(BBTimeOutView*)timeOutView;

@end
@interface BBTimeOutView : UIView{
    UIButton *btnValue;
    NSInteger _value;
    
    id <BBTimeOutViewDelegate> delegate;
}

@property (nonatomic,retain) id <BBTimeOutViewDelegate> delegate;

- (void) setEnable:(BOOL)enable;
- (void) reset;
- (void)subtractValue;
- (void)addValue;
- (NSInteger)value;
- (void) setValue:(NSInteger)value;
@end
