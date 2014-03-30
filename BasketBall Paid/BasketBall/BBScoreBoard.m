//
//  BBScoreBoard.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBScoreBoard.h"

@implementation BBScoreBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    UIImageView *imvBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [imvBackGround setImage:[UIImage imageNamed:@"scoreboard.png"]];
    [self addSubview:imvBackGround];
    [imvBackGround release];
    scoreA = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    scoreB = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
    
    [scoreA setBackgroundColor:[UIColor clearColor]];
    [scoreB setBackgroundColor:[UIColor clearColor]];
    [scoreA setTextColor:[UIColor whiteColor]];
    [scoreB setTextColor:[UIColor whiteColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:scoreA];
    [self addSubview:scoreB];
    [scoreA setText:@"000"];
    [scoreB setText:@"000"];
    [scoreA setTextAlignment:UITextAlignmentCenter];
    [scoreB setTextAlignment:UITextAlignmentCenter];
    UIFont *font = [UIFont systemFontOfSize:30];
    [scoreA setFont:font];
    [scoreB setFont:font];
}

- (void) addValue:(NSInteger)aValue forIndex:(NSInteger)index{
    if (index == 0) {
        valueA +=aValue;
        if (valueA < 10) {
            [scoreA setText:[NSString stringWithFormat:@"00%d",valueA]];
        } else if (valueA < 100) {
            [scoreA setText:[NSString stringWithFormat:@"0%d",valueA]];
        } else {
            [scoreA setText:[NSString stringWithFormat:@"%d",valueA]];
        }
    } else if (index == 1){
        valueB +=aValue;
        if (valueB < 10) {
            [scoreB setText:[NSString stringWithFormat:@"00%d",valueB]];
        } else if (valueB < 100){
            [scoreB setText:[NSString stringWithFormat:@"0%d",valueB]];
        } else {
            [scoreB setText:[NSString stringWithFormat:@"%d",valueB]];
        }
    }
}

- (void) subtractValue:(NSInteger)aValue forIndex:(NSInteger)index{
    if (index == 0) {
        valueA -=aValue;
        [scoreA setText:[NSString stringWithFormat:@"%0.3d",valueA]];
    } else if (index == 1){
        valueB -=aValue;
        [scoreB setText:[NSString stringWithFormat:@"%0.3d",valueB]];
    }
}
- (NSInteger) valueForIndex:(NSInteger)index{
    if (index == 0) {
        return valueA;
    } else {
        return valueB;
    }
}

- (void) setValue:(NSInteger)value ForIndex:(NSInteger)index{
    if (index == 0) {
        valueA = value;
        [scoreA setText:[NSString stringWithFormat:@"%0.3d",valueA]];
    } else{
        valueB = value;
        [scoreB setText:[NSString stringWithFormat:@"%0.3d",valueB]];
    }
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
