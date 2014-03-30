//
//  BBReportCardViewController.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface BBReportCardViewController : UIViewController<UIScrollViewDelegate, UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    IBOutlet UIWebView *webViewA, *webViewB, *currentWebView;
    NSDictionary *_dictionary;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIPageControl *pageControl;
    UIActionSheet *as;
    NSInteger _teamIndex;
}
- (id) initWithDictionary:(NSDictionary*)dictionary;
@end
