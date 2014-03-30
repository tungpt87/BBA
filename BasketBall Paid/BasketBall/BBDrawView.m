//
//  BBDrawView.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 2/23/13.
//
//

#import "BBDrawView.h"

@implementation BBDrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    arrPath = [[NSMutableArray alloc] init];
    self.lineDrawOn = YES;
    shouldRedraw = NO;
}
- (void) undoLast{
    if (arrPath && arrPath.count > 0) {
        [arrPath removeObjectAtIndex:arrPath.count-1];
    }
    [self setNeedsDisplay];
    if ([self.delegate respondsToSelector:@selector(drawViewDidUndo:)]) {
        [self.delegate drawViewDidUndo:self];
    }
}

- (void) removeAll{
    [arrPath removeAllObjects];
    [self setNeedsDisplay];
}
- (void)toggleLineDraw{
    self.lineDrawOn = !self.lineDrawOn;
}
- (NSInteger)numberOfLine{
    if (!arrPath) {
        return 0;
    }
    return arrPath.count;
}
- (void)drawRect:(CGRect)rect{
    NSLog(@"drawRect");
    [super drawRect:rect];
    [[UIImage imageNamed:@"fullcourt.png"] drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    if (self.lineDrawOn) {
        [[UIColor blueColor] setStroke];
        for (UIBezierPath *path in arrPath) {
            [path setLineWidth:kLineWidth];
            [path setLineJoinStyle:kCGLineJoinBevel];
            [path setLineCapStyle:kCGLineCapRound];
            [path strokeWithBlendMode:kCGBlendModeNormal
                                alpha:1];
        }
        if (currentPath) {
            [currentPath setLineCapStyle:kCGLineCapRound];
            [currentPath setLineWidth:kLineWidth];
            [currentPath setLineJoinStyle:kCGLineJoinRound];
            [currentPath strokeWithBlendMode:kCGBlendModeNormal
                                       alpha:1];
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (YES){//event.type == UIEventTypeMotion) {
        if (self.lineDrawOn) {
            startPoint = [[touches anyObject] locationInView:self];
            currentPath = [[UIBezierPath alloc] init];
            [currentPath moveToPoint:startPoint];
        }
    }
    NSLog(@"Touch began");
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (YES){//event.type == UIEventTypeMotion) {
        if (currentPath) {
            CGPoint currentPoint = [[touches anyObject] locationInView:self];
            [currentPath removeAllPoints];
            [currentPath moveToPoint:startPoint];
            [currentPath addLineToPoint:currentPoint];
            [self setNeedsDisplay];
            shouldRedraw = YES;
        }
    }
    NSLog(@"Touch moved");
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (YES){//event.type == UIEventTypeMotion) {
        if (self.lineDrawOn) {
            if (currentPath) {
                CGPoint endPoint = [[touches anyObject] locationInView:self];
                [currentPath removeAllPoints];
                [currentPath moveToPoint:startPoint];
                [currentPath addLineToPoint:endPoint];
                if (shouldRedraw) {
                    [arrPath addObject:currentPath];
                    [self setNeedsDisplay];
                    shouldRedraw = NO;
                }
                F_RELEASE(currentPath);
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(drawViewDidDrawALine:)]) {
        [self.delegate drawViewDidDrawALine:self];
    }
    NSLog(@"Touch ended");
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if (event) {
        F_RELEASE(currentPath);
        [self setNeedsDisplay];
    }
    NSLog(@"Touch canceled");
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
