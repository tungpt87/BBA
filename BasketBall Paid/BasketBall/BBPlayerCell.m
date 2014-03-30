//
//  BBPlayerCell.m
//  BasketBall
//
//  Created by TungPT on 12/18/12.
//
//

#import "BBPlayerCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation BBPlayerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(didTap:)];
        
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(didLongPress:)];
        [longpress setDelegate:self];
        [tapGesture requireGestureRecognizerToFail:longpress];
        [self addGestureRecognizer:tapGesture];
        [self addGestureRecognizer:longpress];
        [tapGesture release];
        [longpress release];
    }
    return self;
}
- (void)setEnable:(BOOL)enable{
    [self setUserInteractionEnabled:enable];
}
- (void) didTap:(UITapGestureRecognizer*) tapGesture{
    if (!self.player.isOnPlayingTime) {
        if ([self.player.number length] > 0) {
            self.player.isSelected = !self.player.isSelected;
            if (self.player.isSelected) {
                [self.delegate playerDidSubbedOn:self.player];
            } else{
                [self.delegate playerDidSubbedOff:self.player];
            }
        }
    } else {

        [self toggleFlashing:NO];
        [self.player setIsOnAction:YES];
        if (self.delegate) {
//            [self.delegate playerViewDidTapped:self];
            [self.delegate playerDidSelectedForAction:self.player];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlayerDidTap
                                                        object:self];
    [self setNeedsLayout];

}

- (void) didLongPress:(UILongPressGestureRecognizer*)longpress{
    if (longpress.state == UIGestureRecognizerStateBegan) {
        CGPoint loc = [longpress locationInView:gvBackground];
        if (CGRectContainsPoint(lblFoul.frame, loc)) {
            [tfHidden becomeFirstResponder];
            [(UIPickerView*)tfHidden.inputView reloadAllComponents];
            [(UIPickerView*)tfHidden.inputView selectRow:[DataManager foulDangerLimit] - 1
                                             inComponent:0
                                                animated:NO];
            NSLog(@"[Player foul] Long pressed");
            NSLog(@"View: %@",[longpress view].description);
        } else {
            [self.player setIsSelected:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlayerViewDidLongPressed
                                                                object:self];
        }

        [self setNeedsLayout];
    }

}

- (void) foulLongPress:(UILongPressGestureRecognizer*)longpress{
    if (longpress.state == UIGestureRecognizerStateBegan) {

    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (!gvBackground) {
        gvBackground = [[BBGradientView alloc] initWithFrame:CGRectMake(20, 2, self.frame.size.width - 22, self.frame.size.height - 4)];
        [gvBackground setCornerRadius:10];
        [gvBackground setColor:[UIColor lightGrayColor]];
        [gvBackground setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight];
        [self addSubview:gvBackground];
        
        gvFlashing = [[BBGradientView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 22, self.frame.size.height - 4)];
        [gvFlashing setCornerRadius:10];
        [gvFlashing setColor:[UIColor orangeColor]];
        [gvFlashing setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight];
        [gvBackground addSubview:gvFlashing];
        
        firstCircle = [[BBGradientView alloc] initWithFrame:CGRectMake(0, 7, 15, 15)];
        [firstCircle setCornerRadius:7.5];
        [firstCircle setColor:[UIColor blackColor]];
        [self addSubview:firstCircle];
        
        secondCircle = [[BBGradientView alloc] initWithFrame:CGRectMake(0, 25, 15, 15)];
        [secondCircle setCornerRadius:7.5];
        [secondCircle setColor:[UIColor blackColor]];
        [self addSubview:secondCircle];
        
        [firstCircle setHidden:YES];
        [secondCircle setHidden:YES];
        gvFlashing.alpha = 0;
        
        lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 30, self.frame.size.height - 4)];
        [lblNumber setBackgroundColor:[UIColor clearColor]];
        [lblNumber setTextAlignment:NSTextAlignmentCenter];
        [lblNumber setFont:[UIFont boldSystemFontOfSize:17]];
        [lblNumber setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight];
        [self addSubview:lblNumber];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(50, 2, self.frame.size.width - 130, self.frame.size.height - 4)];
        [lblName setBackgroundColor:[UIColor clearColor]];
        [lblName setFont:[UIFont boldSystemFontOfSize:17]];
        [lblName setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight];
        [self addSubview:lblName];
        
        lblScore = [[UILabel alloc] initWithFrame:CGRectMake(gvBackground.frame.size.width - 40, 0, 40, gvBackground.frame.size.height)];
        [lblScore setBackgroundColor:[UIColor colorWithRed:14.0/255 green:66.0/255 blue:97.0/255 alpha:1]];
        [lblScore setTextColor:[UIColor whiteColor]];
        [lblScore setTextAlignment:NSTextAlignmentCenter];
        [lblScore setFont:[UIFont boldSystemFontOfSize:17]];
        [lblScore setAutoresizingMask:UIViewAutoresizingNone];
        [gvBackground addSubview:lblScore];
        
        
        lblFoul = [[UILabel alloc] initWithFrame:CGRectMake(gvBackground.frame.size.width - 80, 0, 40, gvBackground.frame.size.height)];
        [lblFoul setBackgroundColor:[UIColor greenColor]];
        [lblFoul setTextColor:[UIColor whiteColor]];
        [lblFoul setTextAlignment:NSTextAlignmentCenter];
        [lblFoul setFont:[UIFont boldSystemFontOfSize:17]];
        [lblFoul setAutoresizingMask:UIViewAutoresizingNone];

        [lblFoul setUserInteractionEnabled:YES];
        UILongPressGestureRecognizer *foulLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                    action:@selector(foulLongPress:)];
        [lblFoul addGestureRecognizer:foulLongPress];
        [foulLongPress release];
        
        [gvBackground addSubview:lblFoul];
        
        tfHidden = [[UITextField alloc] initWithFrame:CGRectZero];
        [tfHidden setHidden:YES];
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 200)];
        [pickerView setShowsSelectionIndicator:YES];
        [pickerView setDataSource:self];
        [pickerView setDelegate:self];
        [tfHidden setInputView:pickerView];
        UINavigationBar *tfToolBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 44)];
        [tfToolBar setBarStyle:UIBarStyleBlackTranslucent];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:tfHidden
                                                                                   action:@selector(resignFirstResponder)];
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:BARTITLE_SETFOULDANGERLIMIT];
        navItem.rightBarButtonItem = barButton;
        [tfToolBar pushNavigationItem:navItem animated:YES];
        [navItem release];
        [barButton release];
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT)];
        [blackView setBackgroundColor:[UIColor clearColor]];
        CGRect frame = tfToolBar.frame;
        frame.origin.x = 0;
        frame.origin.y = SCREEN_SIZE_HEIGHT - frame.size.height;
        [tfToolBar setFrame:frame];
        [blackView addSubview:tfToolBar];
        [tfHidden setInputAccessoryView:blackView];
        [tfToolBar release];
        [blackView release];
        [self addSubview:tfHidden];
        [pickerView release];
    } else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGPoint center = lblScore.center;
                             center.y = self.frame.size.height / 2;
                             lblScore.center = center;
                             center = lblFoul.center;
                             center.y = self.frame.size.height / 2;
                             lblFoul.center = center;
                         }];
        
    }
    //TODO:
    if ([self.player.number intValue] > 0) {
        if ((self.player.appearance & PLAYER_APPEARANCE_FIRSTHALF) == PLAYER_APPEARANCE_FIRSTHALF){
            [firstCircle setHidden:NO];
        }
        
        if ((self.player.appearance & PLAYER_APPEARANCE_SECONDHALF) == PLAYER_APPEARANCE_SECONDHALF){
            [secondCircle setHidden:NO];
        }
    } else {
        [firstCircle setHidden:YES];
        [secondCircle setHidden:YES];
    }

    
    if (self.player.isSelected) {
        [gvBackground setColor:[UIColor colorWithRed:30.0/255 green:97.0/255 blue:135.0/255 alpha:1]];
    } else {
        [gvBackground setColor:[UIColor lightGrayColor]];
    }
    
    if (self.player.isOnAction) {
        gvFlashing.hidden = NO;
        [gvFlashing setAlpha:1];
    } else {
        [gvFlashing setAlpha:0];
    }
    
    [self loadData];
    [self toggleFlashing:self.player.isFlashing];
    
    NSInteger foulDanger = [DataManager foulDangerLimit];
    if (self.player.fouls < foulDanger && self.player.techFouls < kTechFoulDangerLimit) {
        [lblFoul setBackgroundColor:[UIColor greenColor]];
    } else {
        [lblFoul setBackgroundColor:[UIColor redColor]];
    }
}
- (void) setNumber:(NSInteger)number;{
    [self.player setNumber:[NSString stringWithFormat:@"%d",number]];
    [self setNeedsLayout];
}
- (void) setName:(NSString*)name;{
    [self.player setName:name];
    [self setNeedsLayout];
}
- (void) loadData{
    if ([self.player.number integerValue] > 0) {
        [lblNumber setText:self.player.number];
    } else {
        [lblNumber setText:@""];
    }

    [lblName setText:self.player.name];
    [lblScore setText:[NSString stringWithFormat:@"%d",self.player.scores]];
    [lblFoul setText:[NSString stringWithFormat:@"%d",self.player.fouls]];
}
- (void) toggleFlashing:(BOOL)flashing{
    isFlashing = flashing;
    [gvFlashing setAlpha:(self.player.isOnAction)?1:0];
    if (flashingTimer) {
        [flashingTimer invalidate];
        flashingTimer = nil;
    }
    
    if (isFlashing) {
        //            NSLog(@"Start flashing");

        [self flashingIn];
        flashingTimer = [NSTimer scheduledTimerWithTimeInterval:2*kFlashingDuration
                                                         target:self
                                                       selector:@selector(flashingIn)
                                                       userInfo:nil
                                                        repeats:YES];
        
    }
    [self.player setIsFlashing:flashing];
}

- (void) flashingIn{
    if (isFlashing) {
        //        NSLog(@"Flashing In");

        [UIView animateWithDuration:kFlashingDuration
                         animations:^{
                             [gvFlashing setAlpha:1];
                         } completion:^(BOOL finished) {
                             [self flashingOut];
                         }];
    }
    
}

- (void) flashingOut{
    [UIView animateWithDuration:kFlashingDuration
                     animations:^{
                         [gvFlashing setAlpha:(self.player.isOnAction)?1:0];
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{


    // Configure the view for the selected state
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d",row+1];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [DataManager setFoulDangerLimit:row+1];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 300;
}

@end
