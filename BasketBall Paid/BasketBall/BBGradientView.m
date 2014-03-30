//
//  BBGradientView.m
//  BasketBall
//
//  Created by TungPT on 12/18/12.
//
//

#import "BBGradientView.h"
#import <QuartzCore/QuartzCore.h>
@implementation BBGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:NO];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.layer setCornerRadius:self.cornerRadius];
    [self setClipsToBounds:YES];
    [self.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.layer setBorderWidth:2];
}
- (void)setColor:(UIColor *)color{
    _color = [color retain];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    float locations[4] = {0.4,1,1,1};
    CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [NSArray arrayWithObjects:(id)self.color.CGColor,[UIColor whiteColor].CGColor,[UIColor lightGrayColor].CGColor,self.color.CGColor, nil], locations);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(self.frame.size.width/2, self.frame.size.height), CGPointMake(self.frame.size.width/2, 0), kCGGradientDrawsAfterEndLocation);

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
