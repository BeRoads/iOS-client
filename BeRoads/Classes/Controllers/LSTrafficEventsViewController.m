//
//  LSTrafficEventsViewController.m
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSTrafficEventsViewController.h"

#import "LSBeRoadsClient.h"

#import "TrafficEvent.h"

#import "LSLocationManager.h"

#import "LSTrafficEventsBeRoadsCell.h"

#import "LSTrafficDetailViewController.h"

@interface LSTrafficEventsViewController ()

@end

@implementation LSTrafficEventsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    ((PullTableView*)self.tableView).pullTableIsLoadingMoreEnabled = NO;
    [self reloadTrafficEvents];
}

- (void)reloadTrafficEvents{
    [[LSBeRoadsClient sharedClient] getTrafficEvents:^(NSArray * trafficEvents, NSError * error) {
        self.trafficEvents = trafficEvents;
        [self.tableView reloadData];
        
        PullTableView* pullTableView = (PullTableView*)self.tableView;
        if (pullTableView.pullTableIsRefreshing) {
            pullTableView.pullTableIsRefreshing = NO;
        }
    } location:[[LSLocationManager sharedLocationManager] location].coordinate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib{
    self.title = NSLocalizedString(@"Traffic", @"Traffic");
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
    return [self.trafficEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"beroadsCell";
    LSTrafficEventsBeRoadsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    /*
     if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
     }
     */
    
    // Configure the cell...
    TrafficEvent* currentTrafficEvent = [self.trafficEvents objectAtIndex:indexPath.row];
    
    CLLocation* trafficEventLocation = [[CLLocation alloc] initWithLatitude:[currentTrafficEvent.lat floatValue] longitude:[currentTrafficEvent.lng floatValue]];
    int distance = (int) [trafficEventLocation distanceFromLocation:[[LSLocationManager sharedLocationManager]location]]/1000;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%d km",distance];
                
    cell.titleLabel.text = [currentTrafficEvent location];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"detailTrafficEvent"]) {
        LSTrafficDetailViewController* detailViewController = [segue destinationViewController];
        detailViewController.trafficEvent = [_trafficEvents objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

#pragma mark PullToRefreshDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView;
{
    [self reloadTrafficEvents];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView{
}

#pragma mark - Table view data source

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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
