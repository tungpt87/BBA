//
//  BBShotPin.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBShotPin : UIView{
    BOOL _isScored;
}

@property (nonatomic) BOOL isScored;

- (CGPoint) location;
- (void) removeSelf;
@end
