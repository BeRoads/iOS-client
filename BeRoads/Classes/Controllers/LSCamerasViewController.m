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
#import "LSNoResultView.h"

@interface LSCamerasViewController ()

@property (nonatomic, strong) NSArray* zones;

@property (nonatomic,strong) LSNoResultView* noResultView;

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

    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.noResultView = [[UINib nibWithNibName:@"NoResults_iPhone" bundle:nil] instantiateWithOwner:self options:nil][0];
    
    ((PullTableView*)self.tableView).pullTableIsLoadingMore = NO;
    
    [self reloadCameras];
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
    
    [self.view addGestureRecognizer:[self.slidingViewController panGesture]];
}

- (void)reloadCameras{
    [[LSBeRoadsClient sharedClient] getCameras:^(NSArray * cameras, NSError * error) {
        self.cameras = cameras;
        [self createZones];
        [self.tableView reloadData];
        
        if ([self.cameras count] == 0) {
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

-(void)awakeFromNib{
    self.title = NSLocalizedString(@"Cameras", @"Cameras");
}

#pragma mark - IBACTION

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
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
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressGesture];
    
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


- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
	// only when gesture was recognized, not when ended
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		// get affected cell
		UITableViewCell *cell = (UITableViewCell *)[gesture view];
        
		// get indexPath of cell
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        //get the camera's zone
        Zone* selectedZone = [self.zones objectAtIndex:indexPath.section];
        //get the selected camera
        Camera* selectedCamera = [[[self.zones objectAtIndex:indexPath.section] cameras] objectAtIndex:indexPath.row];
        
        //retrieve user's preferences
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSMutableArray *mutableArrayCopy = [[prefs objectForKey:@"webcams_favorites"] mutableCopy];
        //if there is no favorites array, we create it
        if(!mutableArrayCopy){
            mutableArrayCopy = [[NSMutableArray alloc] init];
            [prefs setObject:[[NSArray alloc] init] forKey:@"webcams_favorites"];
        }
        
        bool present = false;
        for(NSData *cameraEncodedObject in mutableArrayCopy){
            Camera *camera = [NSKeyedUnarchiver unarchiveObjectWithData:cameraEncodedObject];
            if([[camera idCamera] isEqual:[selectedCamera idCamera]])
                present = true;
        }
     
        NSData *cameraEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:selectedCamera];
        //if it's not already stored as favorites
        if(!present && ![[selectedZone title] isEqualToString:NSLocalizedString(@"Favorites", @"Favorites")]){
            NSLog(@"Added element at row %@", indexPath);
            [mutableArrayCopy addObject:cameraEncodedObject];
        }else{
            //it's already in favorites and he push in the favorites zone so we delete it
            [mutableArrayCopy removeObject:cameraEncodedObject];
        }
        //we copy to a NSArray so NSUserDefaults don't get angry
        NSArray *array = [NSArray arrayWithArray:mutableArrayCopy];
        [prefs setObject:array forKey:@"webcams_favorites"];
        //we update the favorites zone view
        [self updateFavorites];
        
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[self.zones objectAtIndex:section] title];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"detailCamera"]) {
        LSCameraDetailViewController* detailViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Camera* selectedCamera = [[[self.zones objectAtIndex:indexPath.section] cameras] objectAtIndex:indexPath.row];
        detailViewController.camera = selectedCamera;
    }
}

- (void) updateFavorites{
    /**
     Get the favorites zone and set the cameras NSArray to the content stored in NSUserDefaults as "webcams_favorites".
     If the favorite zone don't exists, it does nothin'
     **/
    for(Zone* z in _zones){
        if([[z title] isEqualToString:NSLocalizedString(@"Favorites", @"Favorites")]){
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSMutableArray *mutableArrayCopy = [[prefs objectForKey:@"webcams_favorites"] mutableCopy];
            NSMutableArray *webcams_favorites = [[NSMutableArray alloc] init];
            if(mutableArrayCopy){
                for(NSData *cameraEncodedObject in mutableArrayCopy){
                    [webcams_favorites addObject:[NSKeyedUnarchiver unarchiveObjectWithData:cameraEncodedObject]];
                }
            }
            z.cameras = webcams_favorites;
        }
    }
    [self.tableView reloadData];
    
}

- (void)createZones{
    NSMutableArray* zonesMutable = [NSMutableArray array];
    NSArray* titlesZones = [_cameras valueForKeyPath:@"@distinctUnionOfObjects.zone"];
    
    

    Zone* zone = [[Zone alloc] init];
    zone.title = NSLocalizedString(@"Favorites", @"Favorites");
    [zonesMutable addObject:zone];
    
    for (NSString* title in titlesZones) {
        Zone* zone = [[Zone alloc] init];
        zone.title = title;
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"zone LIKE %@",title];
        zone.cameras = [_cameras filteredArrayUsingPredicate:predicate];
        [zonesMutable addObject:zone];
    }
    
    _zones = [NSArray arrayWithArray:zonesMutable];
    [self updateFavorites];
}

#pragma mark PullToRefreshDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView;
{
    [self reloadCameras];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView{
    pullTableView.pullTableIsLoadingMore = NO;
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