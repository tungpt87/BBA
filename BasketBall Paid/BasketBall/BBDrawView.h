//
//  BBDrawView.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 2/23/13.
//
//

#import <UIKit/UIKit.h>
@class BBDrawView;
@protocol BBDrawViewDelegate <NSObject>

@optional
- (void) drawViewDidDrawALine:(BBDrawView*)drawView;
- (void) drawViewDidUndo:(BBDrawView*)drawView;


@end
@interface BBDrawView : UIView{
    NSMutableArray *arrPath;
    UIBezierPath *currentPath;
    CGPoint startPoint;
    BOOL shouldRedraw;
}
@property (nonatomic) BOOL lineDrawOn;
@property (nonatomic, assign) id <BBDrawViewDelegate> delegate;
- (void) toggleLineDraw;
- (void) undoLast;
- (void) removeAll;
- (NSInteger) numberOfLine;
@end
