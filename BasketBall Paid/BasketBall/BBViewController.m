//
//  BBViewController.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBViewController.h"
#import "BBMatchesListTableViewController.h"
@interface BBViewController ()

@end

@implementation BBViewController
- (void) timerFired:(NSTimer*)timer{


}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:[NSDate date] repeats:NO];
    NSString *instructionsHtml = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"instruction" ofType:@"html"]
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    [instructionWebView setOpaque:NO];
    [instructionWebView setBackgroundColor:[UIColor clearColor]];
    [instructionWebView loadHTMLString:instructionsHtml
                               baseURL:nil];
    
    if ([DataManager userDefaultObjectForKey:kKey_QuickSave]) {
        [CommonUtils displayAlertWithTitle:@"Previous Data"
                                   message:LOCALIZE(kMessageConfirmLoadPreviousData)
                               cancelTitle:LOCALIZE(kButtonTitleNo)
                                       tag:ALERTVIEW_TAG_CONFIRM_LOAD_PREVIOUSDATA
                                  delegate:self
                         otherButtonTitles:LOCALIZE(kButtonTitleYes)];
    }

}
- (IBAction)showInstructions:(id)sender{
    [CommonUtils displayPopUpWithContentView:instructionView];
}
- (IBAction)closeInstructions:(id)sender{
    [CommonUtils dismissPopUpView];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}


#pragma mark - IBAction
- (IBAction)btnStartNewMatchTapped:(id)sender{
    
    BBNewMatchViewController *newMatchViewController = [[BBNewMatchViewController alloc] init];
    [newMatchViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];

    [self presentModalViewController:newMatchViewController
                            animated:YES];
    [newMatchViewController release];

}

- (IBAction)btnRecordedStatisticsTapped:(id)sender{
    BBMatchesListTableViewController *matchesListTableViewController = [[BBMatchesListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:matchesListTableViewController];
    [matchesListTableViewController release];
    [navController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:navController
                            animated:YES];
    [navController release];
    
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:string]];
//    NSArray *arr = [NSArray arrayWithObjects:@"Name 1",@"Name 2",@"Name 3", nil];
//    [[DataManager defaultManager] displayAutofillPopOverForTextField:textField inView:self.view dataSource:arr delegate:self animated:YES];
//    return NO;
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [[DataManager defaultManager] dismissAutofillPopOverViewWithAnimated:YES];
//}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [DataManager userDefaultRemoveObjectForKey:kKey_QuickSave];
    } else {
        [self btnStartNewMatchTapped:nil];
    }
}
@end
