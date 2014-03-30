//
//  BBStatisticOptionViewController.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBStatisticOptionViewController.h"
#import "BBReportCardViewController.h"
#import "BBScoreCardViewController.h"
#import "BBMatchRunSheetViewController.h"
@interface BBStatisticOptionViewController ()

@end

@implementation BBStatisticOptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    if (self) {
        _dictMatch = [[NSDictionary alloc] initWithDictionary:dictionary];
        NSString *matchName = (NSString*)[_dictMatch objectForKey:kKey_Match_MatchName];
        [self setTitle:[NSString stringWithFormat:@"%@%@",TITLE_STATISTICSOPTION,matchName]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - IBActions
- (IBAction)btnScoreCardDidTap:(id)sender{
    BBScoreCardViewController *scoreCard = [[BBScoreCardViewController alloc] initWithMatchDictionary:_dictMatch defaultName:nil];
    [self.navigationController pushViewController:scoreCard
                                         animated:YES];
    F_RELEASE(scoreCard);
}

- (IBAction)btnStatisticsDidTap:(id)sender{
    BBReportCardViewController *reportCard = [[BBReportCardViewController alloc] initWithDictionary:_dictMatch];
    [self.navigationController pushViewController:reportCard
                                         animated:YES];
    F_RELEASE(reportCard);
}

- (IBAction)btnSequentialOfRunSheetDidTap:(id)sender{
    BBMatchRunSheetViewController *matchRunSheet = [[BBMatchRunSheetViewController alloc] initWithDictionary:_dictMatch];
    [self.navigationController pushViewController:matchRunSheet 
                                         animated:YES];
    F_RELEASE(matchRunSheet);
}
@end
