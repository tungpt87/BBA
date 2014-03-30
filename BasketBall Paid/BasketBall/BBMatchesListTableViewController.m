//
//  BBMatchesListTableViewController.m
//  BasketBall
//
//  Created by Tung Pham Thanh on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBMatchesListTableViewController.h"
#import "BBStatisticOptionViewController.h"
@interface BBMatchesListTableViewController ()

@end

@implementation BBMatchesListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setTitle:LOCALIZE(TITLE_MATCHESLIST)];
    }
    return self;
}

- (id) initWithArrayOfMatches:(NSArray*)arrMatches{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _arrMatches = [[NSMutableArray alloc] initWithArray:arrMatches];
        [self setTitle:LOCALIZE(TITLE_MATCHESLIST)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_arrMatches) {
        _arrMatches = [[NSMutableArray alloc] initWithArray:[DataManager arrayOfRecordedMatchs]];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:LOCALIZE(BARBUTTONTITLE_HOME    )
                                                                      style:UIBarButtonSystemItemDone
                                                                     target:self
                                                                     action:@selector(backToHome)];
    self.navigationItem.leftBarButtonItem = doneBarButton;
    
    UIBarButtonItem *editbutton = [[UIBarButtonItem alloc] initWithTitle:LOCALIZE(BARBUTTONTITLE_EDIT)
                                                                   style:UIBarButtonSystemItemEdit
                                                                  target:self
                                                                  action:@selector(editAction)];
    self.navigationItem.rightBarButtonItem = editbutton;
    [editbutton release];
    [doneBarButton release];
}
- (void) backToHome{
    [self.navigationController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [ROOT_VIEW_CONTROLLER dismissModalViewControllerAnimated:YES];

}

- (void) editAction{
    [self.tableView setEditing:YES animated:YES];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneEditingAction)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = doneButton;
    [doneButton release];
}

- (void) doneEditingAction{
    [self.tableView setEditing:NO
                      animated:YES];
    UIBarButtonItem *editbutton = [[UIBarButtonItem alloc] initWithTitle:LOCALIZE(BARBUTTONTITLE_EDIT) 
                                                                   style:UIBarButtonSystemItemEdit
                                                                  target:self
                                                                  action:@selector(editAction)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = editbutton;
    [editbutton release];

    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_arrMatches) {
        return _arrMatches.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *match = (NSDictionary*)[_arrMatches objectAtIndex:indexPath.row];
    NSString *matchTitle = [match objectForKey:kKey_Match_MatchName];
    matchTitle = [matchTitle stringByDeletingPathExtension];
    matchTitle = [matchTitle stringByReplacingOccurrencesOfString:kFileNamePrefix_Match 
                                                       withString:@""];
    NSString *date = [match objectForKey:kKey_NewMatch_Date];
    [cell.textLabel setText:matchTitle];
    [cell.detailTextLabel setText:date];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [DataManager deleteMatchWithIndex:indexPath.row];
        _arrMatches = [[NSMutableArray arrayWithArray:[DataManager arrayOfRecordedMatchs]]retain];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView reloadData];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileName = [(NSDictionary *)[_arrMatches objectAtIndex:indexPath.row] objectForKey:kKey_Match_FileName];
    NSDictionary *dictionary = [[DataManager statisicDictionaryWithFile:fileName] retain];

    BBStatisticOptionViewController *statisticOptionViewController = [[BBStatisticOptionViewController alloc] initWithDictionary:dictionary];
    [dictionary release];
    [self.navigationController pushViewController:statisticOptionViewController animated:YES];
    F_RELEASE(statisticOptionViewController);
}

@end
