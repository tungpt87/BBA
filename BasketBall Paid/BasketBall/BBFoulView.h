//
//  BBValueView.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
typedef enum {
    VALUEVIEW_TYPE_LEFT = 0,
    VALUEVIEW_TYPE_RIGHT = 1,
}VALUEVIEW_TYPE;
@interface BBFoulView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>{
    UILabel *lblValueName;
    UIButton *btnValue;
    NSTimer *longPressTimer;
    NSInteger _value;
    UITextField *tfHidden;
}
- (void) setTitle:(NSString*)title;
- (void) setValue:(NSInteger)value;
- (void) addValue;
- (void) reset;
- (NSInteger) value;
- (void) subtractValue;
- (BOOL) isReachLimit;
@end
