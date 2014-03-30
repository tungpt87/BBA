//
//  BBScoreCardViewController.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/11/12.
//  Copyright (c) 2012 __MyCompanyNam e__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface BBScoreCardViewController : UIViewController<MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UIWebViewDelegate>{
    IBOutlet UIWebView *webView;
    NSMutableDictionary *_dictionary;
    NSString *_defaultName;
    IBOutlet UIButton *btnPrint, *btnEmail, *btnOpen, *btnDone;
    IBOutlet UILabel *lblTitle;
    UIActionSheet *as;
}

- (id) initWithMatchDictionary:(NSDictionary*)dictionary defaultName:(NSString*)defaultName;
@end
