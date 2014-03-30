//
//  BBValueView.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBFoulView.h"

@implementation BBFoulView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) dismissPickerView{
    [tfHidden resignFirstResponder];
}
- (void)awakeFromNib{
    ///
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dangerLimitDidChange:)
                                                 name:kNotificationDidChangeTeamDangerLimit
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(dismissPickerView)
                                                 name:kNotificationClockDidStart
                                               object:nil];
    [self setBackgroundColor:[UIColor clearColor]];
    tfHidden = [[UITextField alloc] initWithFrame:CGRectZero];
    [tfHidden setHidden:YES];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 200)];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    [tfHidden setInputView:pickerView];
    [pickerView release];
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
    if (self.tag == VALUEVIEW_TYPE_LEFT) {
        CGRect frame = self.frame;
        btnValue = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - frame.size.height, 0, frame.size.height, frame.size.height)];
        [btnValue setBackgroundColor:[UIColor greenColor]];
        [btnValue.layer setCornerRadius:5];
        [btnValue.layer setBorderColor:[UIColor darkGrayColor].CGColor];
        [btnValue.layer setBorderWidth:1];
        UIFont *font = [UIFont boldSystemFontOfSize:25];
        [btnValue.titleLabel setFont:font];
        lblValueName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height)];
        [lblValueName setBackgroundColor:[UIColor clearColor]];
        [self addSubview:btnValue];
        [self addSubview:lblValueName];        
    }
    else {
        CGRect frame = self.frame;
        btnValue = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        [btnValue setBackgroundColor:[UIColor greenColor]];
        [btnValue.layer setCornerRadius:5];
        [btnValue.layer setBorderColor:[UIColor darkGrayColor].CGColor];
        [btnValue.layer setBorderWidth:1];
        UIFont *font = [UIFont boldSystemFontOfSize:25];
        [btnValue.titleLabel setFont:font];
        lblValueName = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height)];
        [lblValueName setBackgroundColor:[UIColor clearColor]];
        [self addSubview:btnValue];
        [self addSubview:lblValueName];  
        [lblValueName setTextAlignment:UITextAlignmentRight];
    }

    UIFont *font = [UIFont boldSystemFontOfSize:20];
    [lblValueName setFont:font];
    [btnValue addTarget:self
                 action:@selector(startTap:) 
       forControlEvents:UIControlEventTouchDown];
    [btnValue addTarget:self
                 action:@selector(touchUpInside:) 
       forControlEvents:UIControlEventTouchUpInside];
    [btnValue addTarget:self
                 action:@selector(touchUpOutside:)
       forControlEvents:UIControlEventTouchUpOutside];
    [self setValue:0];
    [self setTitle:@"Untitled"];
}

- (void) didLongPress{
    if (longPressTimer) {
        [longPressTimer invalidate];
        longPressTimer = nil;
    }
    [(UIPickerView*)tfHidden.inputView reloadAllComponents];
    [(UIPickerView*)tfHidden.inputView selectRow:[DataManager teamFoulDangerLimit] - 1
                                     inComponent:0
                                        animated:NO];
    [tfHidden becomeFirstResponder];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                             delegate:(id)self
//                                                    cancelButtonTitle:nil
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:@"1",@"2",@"3",@"4",@"5" ,@"6",@"7",@"8",@"9",@"10", nil];
//    if (!actionSheet.isVisible) {
//        [actionSheet showFromRect:btnValue.frame
//                           inView:self
//                         animated:YES];
//    }
//    F_RELEASE(actionSheet);
    NSLog(@"[Player foul] Long pressed");


}
- (void) touchUpInside:(id)sender{
    [self invalidateTimer];
}

- (void) touchUpOutside:(id)sender{
    [self invalidateTimer];
}
- (void) startTap:(UITapGestureRecognizer*)gesture{
    [self invalidateTimer];
    longPressTimer = [NSTimer scheduledTimerWithTimeInterval:kLongPressInterval
                                                      target:self
                                                    selector:@selector(didLongPress)
                                                    userInfo:nil
                                                     repeats:NO];
}

- (void) invalidateTimer{
    if (longPressTimer) {
        [longPressTimer invalidate];
        longPressTimer = nil;
    }
}
- (void) setTitle:(NSString*)title{
    [lblValueName setText:title];
}

- (void) setValue:(NSInteger)value{
    _value = value;
    [btnValue setTitle:[NSString stringWithFormat:@"%d",value] forState:UIControlStateNormal];
}

- (void) reset{
    [self setValue:0];    
    [btnValue setBackgroundColor:[UIColor greenColor]];
}

- (void) addValue{
    _value += 1;
    NSInteger foulDanger = [DataManager teamFoulDangerLimit];
    if (_value < foulDanger) {
        [btnValue setBackgroundColor:[UIColor greenColor]];
    }
    else {
        [btnValue setBackgroundColor:[UIColor redColor]];
        if (_value == foulDanger) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTeamFoulReachedLimit
                                                                object:nil];
        }
    }
    [btnValue setTitle:[NSString stringWithFormat:@"%d",_value] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShouldCheckTeamFoul
                                                        object:nil];
}
- (void) subtractValue{
    _value -= 1;
    NSInteger foulDanger = [DataManager teamFoulDangerLimit];
    if (_value < foulDanger) {
        [btnValue setBackgroundColor:[UIColor greenColor]];
    }
    else {
        [btnValue setBackgroundColor:[UIColor redColor]];
    }
    [btnValue setTitle:[NSString stringWithFormat:@"%d",_value] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShouldCheckTeamFoul
                                                        object:nil];
}
- (NSInteger) value{
    return _value;
}
- (void) updateValue{
    [self setValue:_value];
}

- (BOOL) isReachLimit{
    return self.value >= [DataManager teamFoulDangerLimit];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(resetValue)) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Handling observer
- (void)dangerLimitDidChange:(NSNotification*)notification{
    NSInteger newDangerLimit = [(NSNumber*)[notification object] intValue];
    if (newDangerLimit <= _value) {
        [btnValue setBackgroundColor:[UIColor redColor]];
    } else{
        [btnValue setBackgroundColor:[UIColor greenColor]];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex > -1) {
        [DataManager setFoulDangerLimit:buttonIndex+1];
    }

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
    [DataManager setTeamFoulDangerLimit:row+1];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 300;
}
@end
