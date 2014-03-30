//
//  BBViewController.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBNewMatchViewController.h"

@interface BBViewController : UIViewController<UITextFieldDelegate, UIWebViewDelegate, UIAlertViewDelegate>{
    IBOutlet UIView *instructionView;
    
    IBOutlet UIWebView *instructionWebView;
}

- (IBAction)btnStartNewMatchTapped:(id)sender;
- (IBAction)btnRecordedStatisticsTapped:(id)sender;

@end
