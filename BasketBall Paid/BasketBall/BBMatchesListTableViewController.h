//
//  BBMatchesListTableViewController.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMatchesListTableViewController : UITableViewController{
    NSMutableArray *_arrMatches;
}
- (id) initWithArrayOfMatches:(NSArray*)arrMatches;
@end
