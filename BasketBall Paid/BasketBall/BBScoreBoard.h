//
//  BBScoreBoard.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBScoreBoard : UIView{
    UILabel *scoreA, *scoreB;
    NSInteger valueA, valueB;
}
- (void) addValue:(NSInteger)aValue forIndex:(NSInteger)index;
- (void) subtractValue:(NSInteger)aValue forIndex:(NSInteger)index;
- (NSInteger) valueForIndex:(NSInteger)index;
- (void) setValue:(NSInteger)value ForIndex:(NSInteger)index;
@end
