//
//  BBPlayerReportCardViewController.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface BBPlayerReportCardViewController : UIViewController<UIDocumentInteractionControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    NSMutableArray *arrLocationOfFieldShot;
    NSInteger _playerIndex, _teamIndex;
    NSDictionary *dictMatch;
    IBOutlet UIImageView *imageView;
    IBOutlet UIWebView *webView;
    UIActionSheet *as;
}

- (id) initWithPlayerIndex:(NSInteger)playerIndex teamIndex:(NSInteger)teamIndex matchDictionary:(NSDictionary*)dictionary;

@end
