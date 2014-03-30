//
//  BBStatisticOptionViewController.h
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBStatisticOptionViewController : UIViewController{
    NSDictionary *_dictMatch;
}
- (id) initWithDictionary:(NSDictionary*)dictionary;
- (IBAction)btnScoreCardDidTap:(id)sender;
- (IBAction)btnStatisticsDidTap:(id)sender;
@end
