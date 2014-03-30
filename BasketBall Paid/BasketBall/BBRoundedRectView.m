//
//  BBRoundedRectView.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 8/3/12.
//
//

#import "BBRoundedRectView.h"
#import <QuartzCore/QuartzCore.h>
@implementation BBRoundedRectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.layer setCornerRadius:10];
        [self.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.layer setBorderWidth:3];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.layer setCornerRadius:10];
    [self.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.layer setBorderWidth:3];
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
