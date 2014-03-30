//
//  BBFullCourtView.m
//  BasketBall
//
//  Created by TungPT on 1/5/13.
//
//

#import "BBFullCourtView.h"
#import "BBBallPin.h"
#import "BBPlayerPin.h"
static BBFullCourtView *instance;
@implementation BBFullCourtView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setClipsToBounds:YES];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.drawableCourt setDelegate:self];
    [self checkButtonState];
}
- (IBAction)refresh:(id)sender {
    NSMutableArray *players = [NSMutableArray array];
    for (int i = 0; i < 5; ++i) {
        BBPlayer *player = [[BBPlayer alloc] init];
        [player setNumber:[NSString stringWithFormat:@"%d",i+1]];
        [players addObject:player];
        [player release];
    }
    [self setTeamAPlayers:players];
    [players removeAllObjects];
    for (int i = 0; i < 5; ++i) {
        BBPlayer *player = [[BBPlayer alloc] init];
        [player setNumber:[NSString stringWithFormat:@"%d",i+1]];
        [players addObject:player];
        [player release];
    }
    [self setTeamBPlayers:players];
}
+ (BBFullCourtView *)shareView{
    if (!instance) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"BBFullCourtView"
                                                     owner:self
                                                   options:nil];
        instance = [[arr objectAtIndex:0] retain];
//        UIImageView *imvBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//        [imvBackground setContentMode:UIViewContentModeScaleAspectFill];
//        [imvBackground setImage:[UIImage imageNamed:@"fullcourt.png"]];
//        [imvBackground setUserInteractionEnabled:YES];
//        [instance addSubview:imvBackground];
//        [imvBackground release];
        
        NSMutableArray *players = [NSMutableArray array];
        for (int i = 0; i < 5; ++i) {
            BBPlayer *player = [[BBPlayer alloc] init];
            [player setNumber:[NSString stringWithFormat:@"%d",i+1]];
            [players addObject:player];
            [player release];
        }
        [instance setTeamAPlayers:players];
        [players removeAllObjects];
        for (int i = 0; i < 5; ++i) {
            BBPlayer *player = [[BBPlayer alloc] init];
            [player setNumber:[NSString stringWithFormat:@"%d",i+1]];
            [players addObject:player];
            [player release];
        }
        [instance setTeamBPlayers:players];
    }
    return instance;
}

- (IBAction)toggleLineDraw:(id)sender {
    [self.drawableCourt toggleLineDraw];
    BOOL lineDrawOn = self.drawableCourt.lineDrawOn;
    if (lineDrawOn) {
        [self.btnToggleLineDraw setTitle:kButtonToggleLineDraw_On
                                forState:UIControlStateNormal];
    } else {
        [self.btnToggleLineDraw setTitle:kButtonToggleLineDraw_Off
                                forState:UIControlStateNormal];
    }
}

- (void) checkButtonState{
    [self.btnUndo setEnabled:(self.drawableCourt.numberOfLine > 0)?YES:NO];
    [self.btnRemoveAll setEnabled:(self.drawableCourt.numberOfLine > 0)?YES:NO];
}
- (IBAction)undoLast:(id)sender {
    [self.drawableCourt undoLast];
}

- (IBAction)removeAll:(id)sender {
    [self.drawableCourt removeAll];
    [self checkButtonState];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (![BBBallPin defaultBallPin].isAppeared) {
        [self addSubview:[BBBallPin defaultBallPin]];
        [BBBallPin defaultBallPin].isAppeared = YES;
    }
    [self.layer setCornerRadius:10];
    [self.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.layer setBorderWidth:3];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOffset:CGSizeMake(3, 3)];
    [self.layer setShadowOpacity:0.7];
}
- (void)setTeamAPlayers:(NSArray *)players{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[BBPlayerPin class]] && subview.tag == 1) {
            [subview removeFromSuperview];
        }
    }
    CGFloat x = 90, y = 90;
    for (int i = 0; i < players.count; ++i) {
        y = 95 + i * 70;
        BBPlayer *player = [players objectAtIndex:i];
        BBPlayerPin *playerPin = [[BBPlayerPin alloc] initWithPlayer:player];
        player.fullCourtLocation = CGPointMake(x, y);

        [playerPin setTag:1];
        [playerPin setColor:[UIColor blueColor]];
        [self addSubview:playerPin];
        [playerPin release];
    }
}

- (void)setTeamBPlayers:(NSArray *)players{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[BBPlayerPin class]] && subview.tag == 2) {
            [subview removeFromSuperview];
        }
    }
    CGFloat x = 90, y = 510;
    for (int i = 0; i < players.count; ++i) {
        y = 510 + i * 70;
        BBPlayer *player = [players objectAtIndex:i];
        BBPlayerPin *playerPin = [[BBPlayerPin alloc] initWithPlayer:player];
        player.fullCourtLocation = CGPointMake(x, y);
        [playerPin setColor:[UIColor redColor]];
        [playerPin setTag:2];
        [self addSubview:playerPin];
        [playerPin release];
    }
}
- (IBAction) dismiss{
    [CommonUtils dismissPopUpView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - BBDrawViewDelegate
- (void)drawViewDidDrawALine:(BBDrawView *)drawView{
    [self checkButtonState];
}

- (void)drawViewDidUndo:(BBDrawView *)drawView{
    [self checkButtonState];
}


- (void)dealloc {
    [_drawableCourt release];
    [_btnToggleLineDraw release];
    [_btnUndo release];
    [_btnRemoveAll release];
    [super dealloc];
}
@end
