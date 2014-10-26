//
//  LSRadarsViewController.m
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSRadarsViewController.h"

#import "LSBeRoadsClient.h"
#import "LSLocationManager.h"

#import "Radar.h"

#import <UIRefreshControl+AFNetworking.h>

#import "CSNotificationView+AFNetworking.h"
#import "LSNoResultView.h"
#import "LSBeRoadsRadarCell.h"

@interface LSRadarsViewController ()

@property (nonatomic,strong) NSArray* radars;

@property (nonatomic,strong) LSNoResultView* noResultView;

@end

@implementation LSRadarsViewController

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
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    self.noResultView = [[UINib nibWithNibName:@"NoResults_iPhone" bundle:nil] instantiateWithOwner:self options:nil][0];
    
    [self reloadRadars];
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
    
    [self.view addGestureRecognizer:[self.slidingViewController panGesture]];
}

- (void)reloadRadars{
    [[LSBeRoadsClient sharedClient] getRadars:^(NSArray * radars, NSError * error, NSURLSessionDataTask* task) {
        self.radars = radars;
        [self.tableView reloadData];
        
        if ([self.radars count] == 0) {
            CGRect frame = self.view.frame;
            _noResultView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
            [_noResultView showInView:self.view];
        } else{
            [_noResultView removeFromView];
        }
        
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
    self.title = NSLocalizedString(@"Radars", @"Radars");
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
    return [self.radars count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"beRoadsRadarCell";
    LSBeRoadsRadarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    // Configure the cell...
    Radar* currentRadar = [self.radars objectAtIndex:indexPath.row];
    cell.titleLabel.text = [currentRadar address];
    cell.speedLimitLabel.text = [NSString stringWithFormat:@"%ld", (long)currentRadar.speedLimit];
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"%ld km",(long)currentRadar.distance];
    if([[currentRadar type] isEqual: @"fixed"]){
        cell.typeRadarLabel.text = @"";
    }else{
        cell.typeRadarLabel.text = [currentRadar type];
    }
    
    
    return cell;
}

#pragma mark IBActions

- (IBAction)pullTableViewDidTriggerRefresh:(id)sender {
    [self reloadRadars];
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
