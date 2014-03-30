//
//  BBPlayerPin.h
//  BasketBall
//
//  Created by TungPT on 1/5/13.
//
//

#import <UIKit/UIKit.h>
#import "BBMovableView.h"
#import "BBPlayer.h"
@interface BBPlayerPin : BBMovableView{
    UIImageView *imvBall;
    UILabel *lblNumber;
}
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) BBPlayer *player;
- (id) initWithPlayer:(BBPlayer*)player;
@end
