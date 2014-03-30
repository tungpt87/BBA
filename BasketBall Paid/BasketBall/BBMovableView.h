//
//  BBMovableView.h
//  BasketBall
//
//  Created by TungPT on 1/6/13.
//
//

#import <UIKit/UIKit.h>

@interface BBMovableView : UIView
- (void) moveBegan;
- (void) moving;
- (void) moveEnd;
- (void) hitToView:(UIView*)view;
@end
