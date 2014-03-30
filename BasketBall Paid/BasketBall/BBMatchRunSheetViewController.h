//
//  BBMatchRunSheetViewController.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface BBMatchRunSheetViewController : UIViewController<UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate>{
    NSDictionary *_dictionary;
    IBOutlet UITextView *textView;
    IBOutlet UILabel *teamNameA, *teamNameB, *scoreA, *scoreB;
    UIActionSheet *as;
}
- (id) initWithDictionary:(NSDictionary*)dictionary;
@end
