//
//  BBTeamNameView.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define labelFontSize                        24

@class BBTeamNameView;

@protocol BBTeamNameViewDelegate <NSObject>

@required
- (void) teamNameViewDidTapped:(BBTeamNameView*)teamName;
- (void) teamNameViewDidLongPressed:(BBTeamNameView*)teamName;
- (void) teamNameViewDidTechFoul:(BBTeamNameView*)teamName;
@end
@interface BBTeamNameView : UIView{
    UILabel *label;
    UIView *flashingView;
    NSTimer *tmFlashing;
    id <BBTeamNameViewDelegate> delegate;
    BOOL isEditable;
    BOOL _isInTechFoul;
    BOOL _isSelected;
}
@property (nonatomic) BOOL isSelected;
@property (nonatomic) BOOL isInTechFoul;
@property (nonatomic,retain) id <BBTeamNameViewDelegate> delegate;
- (void) setTeamName:(NSString*)teamName;
- (NSString*)teamName;
- (void) setIsEditable:(BOOL)editable;
- (void) desellect;
- (void)toggleFlashing:(BOOL)flashing;
@end
