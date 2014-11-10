//
//  LSTrafficEventsViewController.m
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSTrafficEventsViewController.h"

#import "LSBeRoadsClient.h"
#import "LSLocationManager.h"

#import "TrafficEvent.h"

#import <UIRefreshControl+AFNetworking.h>

#import "LSTrafficEventDetailViewController.h"

#import "CSNotificationView+AFNetworking.h"
#import "LSTrafficEventsBeRoadsCell.h"

@interface LSTrafficEventsViewController ()

@property (nonatomic,strong) NSArray* trafficEvents;

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];

    // Empty DataSet
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self reloadTrafficEvents];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.navigationController.view.layer.shadowOpacity = 0.75f;
    self.navigationController.view.layer.shadowRadius = 10.0f;
    self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:LSMainStoryboardIDs.viewControllers.menu];
    }
    
    if (self.slidingViewController) {
        [self.view addGestureRecognizer:[self.slidingViewController panGesture]];
    }
}

- (void)reloadTrafficEvents{
    [[LSBeRoadsClient sharedClient] getTrafficEvents:^(NSArray* trafficEvents, NSError* error, NSURLSessionDataTask* task) {
        self.trafficEvents = trafficEvents;
        [self.tableView reloadData];
        
        [CSNotificationView showNotificationViewForTaskWithErrorOnCompletion:task controller:self];
        [self.refreshControl setRefreshingWithStateOfTask:task];
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
    static NSString *CellIdentifier = @"detailTrafficEvent";
    LSTrafficEventsBeRoadsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    /*
     if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
     }
     */
    
    // Configure the cell...
    TrafficEvent* currentTrafficEvent = [self.trafficEvents objectAtIndex:indexPath.row];
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"%ld km",(long)currentTrafficEvent.distance];
    cell.titleLabel.text = [currentTrafficEvent location];
    
    return cell;
}

#pragma mark Prepare For Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([[segue identifier] isEqualToString:@"detailTrafficEvent"]) {
        LSTrafficEventDetailViewController* detailViewController = nil;
        if ([[segue destinationViewController] isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navigationController = [segue destinationViewController];
            detailViewController = (LSTrafficEventDetailViewController*) [navigationController topViewController];
        } else {
            detailViewController = (LSTrafficEventDetailViewController*) [segue destinationViewController];
        }
        detailViewController.trafficEvent = [_trafficEvents objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

#pragma mark - Empty DataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"NoResultTitle", @"No Result Title")];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"NoResultDescription", @"No Result Description")];
}


#pragma mark IBActions

- (IBAction)pullTableViewDidTriggerRefresh:(id)sender {
    [self reloadTrafficEvents];
}

- (IBAction)revealMenu:(id)sender
{
    if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered) {
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
    } else {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}

@end
