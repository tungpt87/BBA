//
//  BBTimeOutView.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBTimeOutView.h"

@implementation BBTimeOutView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib{
    [self setBackgroundColor:[UIColor clearColor]];
    UILabel *lblValueName;
    if (self.tag == TIMEOUTVIEW_TYPE_LEFT) {
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

    [lblValueName setText:@"Time Out"];
    F_RELEASE(lblValueName);
    [self setValue:0];

}

- (void) setValue:(NSInteger)value{
    _value = value;
    [btnValue setTitle:[NSString stringWithFormat:@"%d",_value]
              forState:UIControlStateNormal];
    if (_value == kTimeOutDangerLimit) {
        [btnValue setBackgroundColor:[UIColor redColor]];
    } else if (_value < kTimeOutDangerLimit){
        [btnValue setBackgroundColor:[UIColor greenColor]];
    }
}

- (NSInteger)value{
    return _value;
}
- (void)subtractValue{
    [self setValue:_value - 1];
}

- (void)addValue{
    [self setValue:_value + 1];
}
- (void) startTap:(id)sender{
    [self setValue:_value + 1];
    if (self.delegate) {
        [self.delegate timeOutViewDidIncreaseValue:self];
    }
}

- (void) reset{
    [self setValue:0];
    [btnValue setBackgroundColor:[UIColor greenColor]];
}

- (void) setEnable:(BOOL)enable{
    [self setUserInteractionEnabled:enable];
}
- (void)dealloc{
    [super dealloc];
    [self setDelegate:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
