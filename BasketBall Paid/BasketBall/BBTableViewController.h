//
//  BBTableViewControllerViewController.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBTableViewController : UITableViewController{
    BOOL shouldScrollToBottom;
}
@property (nonatomic) BOOL shouldScrollToBottom;
@end
