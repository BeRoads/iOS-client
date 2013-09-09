//
//  LSRadarsViewController.m
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSRadarsViewController.h"

#import "Radar.h"

#import "LSBeRoadsClient.h"

#import "LSBeRoadsRadarCell.h"

#import "LSNoResultView.h"

@interface LSRadarsViewController ()

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
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    self.noResultView = [[UINib nibWithNibName:@"NoResults_iPhone" bundle:nil] instantiateWithOwner:self options:nil][0];
    
    ((PullTableView*)self.tableView).pullTableIsLoadingMoreEnabled = NO;
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
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
}

- (void)reloadRadars{
    [[LSBeRoadsClient sharedClient] getRadars:^(NSArray * radars, NSError * error) {
        self.radars = radars;
        [self.tableView reloadData];
        
        if ([self.radars count] == 0) {
            [_noResultView showInView:self.view];
        } else{
            [_noResultView removeFromView];
        }
        
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
    self.title = NSLocalizedString(@"Radars", @"Radars");
}

#pragma mark - IBActions

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
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
    cell.speedLimitLabel.text = [currentRadar speedLimit];
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"%d km",currentRadar.distance];
    if([[currentRadar type] isEqual: @"fixed"]){
        cell.typeRadarLabel.text = @"";
    }else{
        cell.typeRadarLabel.text = [currentRadar type];
    }
    
    
    return cell;
}

#pragma mark PullToRefreshDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView;
{
    [self reloadRadars];
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
