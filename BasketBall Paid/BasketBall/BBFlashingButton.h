//
//  BBFlashingButton.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBFlashingButton : UIButton{
    UIImageView *_imvBackground, *_imvFlashing;
    UIButton *_button;
    NSTimer *flashingTimer;
}
- (void) toggleFlashing:(BOOL) flashing;
- (void) setFlashingImage:(UIImage*)anImage;
- (void) setBackGroundImage:(UIImage*)anImage;
- (void) addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)event;
@end
