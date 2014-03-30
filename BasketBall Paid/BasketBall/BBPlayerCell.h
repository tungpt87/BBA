//
//  BBPlayerCell.h
//  BasketBall
//
//  Created by TungPT on 12/18/12.
//
//

#import <UIKit/UIKit.h>
#import "BBGradientView.h"
#import "BBPlayer.h"


@class BBPlayerCell;

@protocol BBPlayerCellDelegate <NSObject>

- (void) playerCellDidTap:(BBPlayerCell*)playerCell;
- (void) playerCellDidLongPress:(BBPlayerCell*)playerCell;
- (void) playerDidSubbedOn:(BBPlayer*)player;
- (void) playerDidSubbedOff:(BBPlayer*)player;
- (void) playerDidSelectedForAction:(BBPlayer*)player;
@end

@interface BBPlayerCell : UITableViewCell<UIPickerViewDataSource,UIPickerViewDelegate, UIGestureRecognizerDelegate>{
    BBGradientView *gvBackground, *gvFlashing, *firstCircle, *secondCircle;
    BOOL isFlashing;
    NSTimer *flashingTimer;
    UILabel *lblNumber;
    UILabel *lblName;
    UILabel *lblScore;
    UILabel *lblFoul;
    UITextField *hiddenTextField,*tfHidden;
}

@property (nonatomic, assign) BBPlayer *player;
@property (nonatomic, assign) id <BBPlayerCellDelegate> delegate;
- (void) toggleFlashing:(BOOL)flashing;
- (void) setEnable:(BOOL)enable;
- (void) setNumber:(NSInteger)number;
- (void) setName:(NSString*)name;
@end
