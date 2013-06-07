//
//  LSCamerasViewController.m
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSCamerasViewController.h"
#import "LSCameraDetailViewController.h"
#import "Camera.h"
#import "Zone.h"

#import "LSLocationManager.h"

#import "LSBeRoadsClient.h"

#import "UIImageView+AFNetworking.h"

@interface LSCamerasViewController ()

@property (nonatomic, strong) NSArray* zones;

@end

@implementation LSCamerasViewController

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
    
    self.navigationItem.title = NSLocalizedString(@"Camera", @"Camera");
    self.title = NSLocalizedString(@"Camera", @"Camera");
    
    [self reloadCameras];
}

- (void)reloadCameras{
    [[LSBeRoadsClient sharedClient] getCameras:^(NSArray * cameras, NSError * error) {
        self.cameras = cameras;
        [self createZones];
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

-(void)awakeFromNib{
    self.title = NSLocalizedString(@"Cameras", @"Cameras");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.zones count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.zones objectAtIndex:section] cameras] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"beroadsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    __weak UITableViewCell* weakCell = cell;
    
    // Configure the cell...
    Camera* currentCamera = [[[self.zones objectAtIndex:indexPath.section] cameras] objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentCamera.img]]
                          placeholderImage:[UIImage imageNamed:@"placeholder-cell"]
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakCell.imageView.image = image;
        [weakCell setNeedsDisplay];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error : %@",error);
    }];
    cell.textLabel.text = currentCamera.city;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[self.zones objectAtIndex:section] title];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"detailCamera"]) {
        LSCameraDetailViewController* detailViewController = [segue destinationViewController];
        detailViewController.camera = [_cameras objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

- (void)createZones{
    NSMutableArray* zonesMutable = [NSMutableArray array];
    NSArray* titlesZones = [_cameras valueForKeyPath:@"@distinctUnionOfObjects.zone"];
    
    for (NSString* title in titlesZones) {
        Zone* zone = [[Zone alloc] init];
        zone.title = title;
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"zone LIKE %@",title];
        zone.cameras = [_cameras filteredArrayUsingPredicate:predicate];
        [zonesMutable addObject:zone];
    }
    
    _zones = [NSArray arrayWithArray:zonesMutable];
}

#pragma mark PullToRefreshDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView;
{
    [self reloadCameras];
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