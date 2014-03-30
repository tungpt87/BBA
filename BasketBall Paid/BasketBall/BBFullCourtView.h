//
//  BBFullCourtView.h
//  BasketBall
//
//  Created by TungPT on 1/5/13.
//
//

#import <UIKit/UIKit.h>
#import "BBDrawView.h"
@interface BBFullCourtView : UIView<BBDrawViewDelegate>{

}
@property (retain, nonatomic) IBOutlet UIButton *btnToggleLineDraw;
@property (retain, nonatomic) IBOutlet BBDrawView *drawableCourt;
@property (retain, nonatomic) IBOutlet UIButton *btnUndo;
@property (retain, nonatomic) IBOutlet UIButton *btnRemoveAll;
+ (BBFullCourtView*) shareView;
- (IBAction)toggleLineDraw:(id)sender;
- (IBAction)undoLast:(id)sender;
- (IBAction)removeAll:(id)sender;
- (void) setTeamAPlayers:(NSArray*)players;
- (void) setTeamBPlayers:(NSArray*)players;
@end
