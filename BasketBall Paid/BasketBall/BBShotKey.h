//
//  BBShotKey.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface BBShotKey : UIView{
    UILabel *label;
    
}
- (void) setIsShotMade:(BOOL) isShotMade;
- (void) setPlayerNumber:(NSString*)playerNumber;
- (void) removeSelf;
@end
